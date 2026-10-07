#!/usr/bin/env python3
"""
release_from_changelog.py

Build a release note from a docs version's CHANGELOG folder and create a git
tag for that release (optionally publishing a GitHub release too).

What it does
------------
1. Resolves the SDK docs version to release (defaults to the newest
   ``docs/vX.Y.Z`` folder; override with ``--version``).
2. Reads every per-module changelog in ``docs/vX.Y.Z/CHANGELOG/*.md`` and
   extracts the latest entry from each (the first ``## <ver> - <date>`` block),
   aggregating them into a single release note grouped by module.
3. Writes the note to a file (``--out``, default
   ``docs/vX.Y.Z/RELEASE_NOTES.md``).
4. Creates an annotated git tag whose message is the release note. The tag name
   defaults to the bare version (e.g. ``1.0.36``) to match this repo's existing
   tags; override with ``--tag``.
5. Optionally pushes the tag (``--push``) and/or creates a GitHub release with
   the ``gh`` CLI (``--gh-release``).

Run ``--dry-run`` first to preview the note and the exact git commands without
changing anything.

Usage
-----
    python3 scripts/release_from_changelog.py --dry-run
    python3 scripts/release_from_changelog.py                 # create tag
    python3 scripts/release_from_changelog.py --version v1.0.36
    python3 scripts/release_from_changelog.py --tag v1.0.36 --push
    python3 scripts/release_from_changelog.py --gh-release --push

Only the Python standard library, a ``git`` CLI, and (for ``--gh-release``) the
GitHub ``gh`` CLI are required.
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
DOCS_DIR = REPO_ROOT / "docs"

VERSION_DIR_RE = re.compile(r"v\d+(?:\.\d+){1,3}")
# A changelog section header: "## 2.0.32 - 25 Jul, 2025"
SECTION_RE = re.compile(r"^##\s+(\d+(?:\.\d+){1,3})\s*-\s*(.+?)\s*$")


def log(msg: str = "") -> None:
    print(msg, flush=True)


def version_key(version: str) -> tuple[int, ...]:
    return tuple(int(p) for p in version.split("."))


# --------------------------------------------------------------------------- #
# Version resolution
# --------------------------------------------------------------------------- #

def find_docs_dir(explicit: str | None) -> Path:
    """Resolve the docs/vX.Y.Z folder to release from."""
    if explicit:
        name = explicit if explicit.startswith("v") else "v" + explicit
        candidate = DOCS_DIR / name
        if not candidate.is_dir():
            sys.exit(f"error: docs version folder not found: {candidate}")
        return candidate

    version_dirs = [
        d for d in DOCS_DIR.iterdir()
        if d.is_dir() and re.fullmatch(VERSION_DIR_RE, d.name)
    ]
    if not version_dirs:
        sys.exit(f"error: no versioned docs folders found under {DOCS_DIR}")
    return max(version_dirs, key=lambda d: version_key(d.name[1:]))


# --------------------------------------------------------------------------- #
# Changelog parsing
# --------------------------------------------------------------------------- #

def latest_entry(changelog_text: str) -> tuple[str, str, str] | None:
    """Return ``(version, date, body)`` for the first (latest) section.

    ``body`` is the markdown between this section header and the next ``## ``
    header (the ``### Added`` / ``### Fixed`` blocks), with trailing blank lines
    trimmed. Returns ``None`` if the file has no recognizable section.
    """
    lines = changelog_text.splitlines()
    start = None
    version = date = ""
    for i, line in enumerate(lines):
        m = SECTION_RE.match(line)
        if m:
            start = i
            version, date = m.group(1), m.group(2)
            break
    if start is None:
        return None

    # Collect body until the next "## " section header.
    body_lines: list[str] = []
    for line in lines[start + 1:]:
        if SECTION_RE.match(line):
            break
        body_lines.append(line)
    body = "\n".join(body_lines).strip("\n")
    return (version, date, body)


def all_entries(changelog_text: str) -> list[tuple[str, str, str]]:
    """Return every ``(version, date, body)`` section, newest first."""
    entries: list[tuple[str, str, str]] = []
    current: list[str] | None = None
    version = date = ""
    for line in changelog_text.splitlines():
        m = SECTION_RE.match(line)
        if m:
            if current is not None:
                entries.append((version, date, "\n".join(current).strip("\n")))
            version, date = m.group(1), m.group(2)
            current = []
        elif current is not None:
            current.append(line)
    if current is not None:
        entries.append((version, date, "\n".join(current).strip("\n")))
    return entries


def module_name_from_file(path: Path) -> str:
    """Doc filename stem is the module name, e.g. 'MapplsAPIKit'."""
    return path.stem


def find_previous_docs_dir(docs_dir: Path) -> Path | None:
    """The highest docs/vX.Y.Z folder that is older than ``docs_dir``."""
    current = version_key(docs_dir.name[1:])
    older = [
        d for d in DOCS_DIR.iterdir()
        if d.is_dir() and re.fullmatch(VERSION_DIR_RE, d.name)
        and version_key(d.name[1:]) < current
    ]
    return max(older, key=lambda d: version_key(d.name[1:])) if older else None


def _top_version(path: Path) -> str | None:
    """Newest version listed in a changelog file, or None."""
    if not path.exists():
        return None
    entries = all_entries(path.read_text(encoding="utf-8"))
    return entries[0][0] if entries else None


def build_release_note(docs_dir: Path, docs_version: str) -> tuple[str, dict[str, str]]:
    """Assemble the release note from the version's CHANGELOG folder.

    Each module's changelog is compared with the same module's changelog in the
    previous docs version. Only the entries released since then go into the
    note, so it describes what actually changed in this doc version. Modules
    with no new entries are listed as unchanged. If there is no previous docs
    version, each module's latest entry is used.

    Returns ``(note_markdown, module_versions)`` where ``module_versions`` maps
    each module to the newest version in its changelog.
    """
    changelog_dir = docs_dir / "CHANGELOG"
    bare = docs_version.lstrip("v")
    prev_dir = find_previous_docs_dir(docs_dir)
    prev_label = prev_dir.name if prev_dir else None

    module_versions: dict[str, str] = {}
    updated: list[tuple[str, str | None, str]] = []   # (module, old, new)
    unchanged: list[tuple[str, str]] = []             # (module, version)
    sections: list[str] = []

    if not changelog_dir.is_dir():
        log(f"  ! no CHANGELOG folder at {changelog_dir}; "
            f"release note will have no per-module detail")
    else:
        for md in sorted(changelog_dir.glob("*.md")):
            module = module_name_from_file(md)
            entries = all_entries(md.read_text(encoding="utf-8"))
            if not entries:
                continue
            newest = entries[0][0]
            module_versions[module] = newest

            if prev_dir is not None:
                old = _top_version(prev_dir / "CHANGELOG" / md.name)
                if old is None:
                    new_entries = entries[:1]          # new module: latest entry
                else:
                    new_entries = [e for e in entries
                                   if version_key(e[0]) > version_key(old)]
            else:
                old = None
                new_entries = entries[:1]

            if not new_entries:
                unchanged.append((module, newest))
                continue

            updated.append((module, old, newest))
            block = [f"### {module}", ""]
            for ver, date, body in new_entries:
                block.append(f"#### {ver} ({date})")
                block.append("")
                # Changelog bodies use "### Added" etc.; nest them under the
                # "#### <version>" heading so the hierarchy stays valid.
                text = re.sub(r"^###\s+", "##### ", body.strip(), flags=re.M)
                block.append(text if text else "_No details provided._")
                block.append("")
            sections.append("\n".join(block).rstrip())

    lines: list[str] = [
        f"# Mappls iOS SDK {bare}",
        "",
        f"Documentation: [`docs/{docs_version}/README.md`]"
        f"(docs/{docs_version}/README.md)",
        "",
    ]

    since = f" since {prev_label}" if prev_label else ""
    if updated:
        lines += [f"## Updated SDKs{since}", ""]
        for module, old, new in updated:
            lines.append(f"- **{module}** {old} → {new}" if old and old != new
                         else f"- **{module}** {new}")
        lines.append("")
    else:
        lines += [f"## Updated SDKs{since}", "",
                  "_No SDK changes in this release._", ""]

    if unchanged:
        lines += ["## Unchanged SDKs", ""]
        lines += [f"- {module} {ver}" for module, ver in unchanged]
        lines.append("")

    if sections:
        lines += ["## Changelog", ""]
        lines.append("\n\n".join(sections))

    note = "\n".join(lines).rstrip() + "\n"
    return note, module_versions


# --------------------------------------------------------------------------- #
# Git / GitHub
# --------------------------------------------------------------------------- #

def run(cmd: list[str], dry_run: bool, check: bool = True) -> int:
    """Run a command (or just print it in dry-run)."""
    printable = " ".join(cmd)
    if dry_run:
        log(f"    DRY-RUN $ {printable}")
        return 0
    log(f"    $ {printable}")
    result = subprocess.run(cmd)
    if check and result.returncode != 0:
        sys.exit(f"error: command failed ({result.returncode}): {printable}")
    return result.returncode


def tag_exists(tag: str) -> bool:
    result = subprocess.run(
        ["git", "tag", "--list", tag], capture_output=True, text=True
    )
    return bool(result.stdout.strip())


def working_tree_dirty() -> bool:
    result = subprocess.run(
        ["git", "status", "--porcelain"], capture_output=True, text=True
    )
    return bool(result.stdout.strip())


# --------------------------------------------------------------------------- #
# Main
# --------------------------------------------------------------------------- #

def main() -> int:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("--version", default=None,
                        help="Docs version to release, e.g. v1.0.36 "
                             "(defaults to the newest docs folder).")
    parser.add_argument("--tag", default=None,
                        help="Tag name to create (defaults to the bare version, "
                             "e.g. 1.0.36, matching existing repo tags).")
    parser.add_argument("--out", default=None,
                        help="Where to write the release note "
                             "(default: docs/<version>/RELEASE_NOTES.md).")
    parser.add_argument("--push", action="store_true",
                        help="Push the created tag to origin.")
    parser.add_argument("--gh-release", action="store_true",
                        help="Also create a GitHub release with the note "
                             "(requires the gh CLI).")
    parser.add_argument("--remote", default="origin",
                        help="Remote to push the tag to (default: origin).")
    parser.add_argument("--allow-dirty", action="store_true",
                        help="Allow tagging even if the working tree has "
                             "uncommitted changes.")
    parser.add_argument("--dry-run", action="store_true",
                        help="Preview the note and git commands; change nothing.")
    args = parser.parse_args()

    docs_dir = find_docs_dir(args.version)
    docs_version = docs_dir.name          # e.g. "v1.0.36"
    bare = docs_version.lstrip("v")
    tag = args.tag or bare
    out_path = Path(args.out) if args.out else (docs_dir / "RELEASE_NOTES.md")

    log(f"Repo root     : {REPO_ROOT}")
    log(f"Docs version  : {docs_version}")
    log(f"Tag           : {tag}")
    log(f"Release note  : {out_path.relative_to(REPO_ROOT) if out_path.is_relative_to(REPO_ROOT) else out_path}")
    log(f"Mode          : {'DRY-RUN (no changes)' if args.dry_run else 'APPLY'}")
    log("")

    # 1. Build the release note.
    note, module_versions = build_release_note(docs_dir, docs_version)
    log(f"Assembled release note from {len(module_versions)} module changelog(s).")
    log("")
    log("----- RELEASE NOTE PREVIEW -----")
    log(note)
    log("--------------------------------")
    log("")

    # 2. Safety checks for tagging.
    if tag_exists(tag):
        sys.exit(f"error: git tag '{tag}' already exists. "
                 f"Use --tag to choose another name or delete the existing tag.")
    if working_tree_dirty() and not args.allow_dirty and not args.dry_run:
        log("warning: working tree has uncommitted changes. The tag will point "
            "at the current HEAD, not your uncommitted work.")
        log("         Re-run with --allow-dirty to proceed, or commit first.")
        return 1

    # 3. Write the note file.
    if args.dry_run:
        log(f"  DRY-RUN would write release note -> "
            f"{out_path.relative_to(REPO_ROOT) if out_path.is_relative_to(REPO_ROOT) else out_path}")
    else:
        out_path.write_text(note, encoding="utf-8")
        log(f"  wrote release note -> "
            f"{out_path.relative_to(REPO_ROOT) if out_path.is_relative_to(REPO_ROOT) else out_path}")

    # 4. Create the annotated tag with the note as its message.
    log("")
    log("Creating annotated git tag...")
    # Pass the note via the file so multi-line messages are preserved.
    # --cleanup=verbatim is essential: the note is markdown, and without it git
    # would strip every line starting with '#' (treating headings as comments).
    tag_cmd = ["git", "tag", "-a", tag, "--cleanup=verbatim", "-F", str(out_path)]
    if args.dry_run:
        run(tag_cmd, dry_run=True)
    else:
        run(tag_cmd, dry_run=False)
        log(f"  created tag {tag}")

    # 5. Optionally push.
    if args.push:
        log("")
        log("Pushing tag...")
        run(["git", "push", args.remote, tag], dry_run=args.dry_run)

    # 6. Optionally create a GitHub release.
    if args.gh_release:
        log("")
        log("Creating GitHub release...")
        gh_cmd = ["gh", "release", "create", tag,
                  "--title", f"Mappls iOS SDK {bare}",
                  "--notes-file", str(out_path)]
        run(gh_cmd, dry_run=args.dry_run)

    log("")
    log("Done.")
    if args.dry_run:
        log("This was a dry run. Re-run without --dry-run to apply.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
