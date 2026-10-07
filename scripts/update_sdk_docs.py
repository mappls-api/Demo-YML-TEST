#!/usr/bin/env python3
"""
update_sdk_docs.py

Update Mappls iOS SDK documentation to reflect the latest module versions
released on Swift Package Manager (the distribution repos under
https://github.com/MapmyIndia).

What it does
------------
1. Locates the newest ``docs/vX.Y.Z`` documentation folder.
2. For every module ``.md`` inside it, discovers the SPM distribution repo URL
   (the ``https://github.com/MapmyIndia/...`` line that follows "Enter the
   repository URL" / an SPM install block).
3. Queries each distribution repo's git tags (``git ls-remote --tags``) to find
   the latest released semantic version.
4. If a module's latest released version is newer than the local doc, the local
   module doc is REPLACED with the distribution repo's full README (fetched at
   the matching version tag) so ALL content is copied -- new API sections, the
   real changelog, everything. When a repo exposes no README, or when
   ``--row-only`` is given, the script instead splices a single version-history
   row (real date/description if a README exists, otherwise ``--date`` /
   ``--note``). Use ``--no-fetch`` to never touch the network.
5. Refreshes the module version numbers in the "Documentation History" table of
   the root ``README.md`` and the versioned ``docs/vX.Y.Z/README.md`` so the
   current-version row lists the latest module versions.

Updating in place vs. creating a new doc version
-------------------------------------------------
By default the script asks whether to:
  (1) update the CURRENT doc version in place (e.g. keep editing ``v1.0.35``),
      or
  (2) create a NEW doc version folder (e.g. copy ``v1.0.35`` to ``v1.0.36``),
      add it as the newest row of the Documentation History tables, and update
      module versions there.
Use ``--update-current`` or ``--new-version [VERSION]`` to skip the prompt.

Run ``--dry-run`` first to preview everything without touching files.

Usage
-----
    python3 scripts/update_sdk_docs.py --dry-run
    python3 scripts/update_sdk_docs.py                 # prompt, then apply
    python3 scripts/update_sdk_docs.py --update-current
    python3 scripts/update_sdk_docs.py --new-version   # auto-bump patch
    python3 scripts/update_sdk_docs.py --new-version v1.0.40
    python3 scripts/update_sdk_docs.py --docs-version v1.0.35
    python3 scripts/update_sdk_docs.py --only MapplsMap MapplsAPIKit

Only the Python standard library and a working ``git`` CLI are required.
"""

from __future__ import annotations

import argparse
import datetime as _dt
import re
import shutil
import subprocess
import sys
import urllib.error
import urllib.request
from dataclasses import dataclass, field
from pathlib import Path

# --------------------------------------------------------------------------- #
# Helpers
# --------------------------------------------------------------------------- #

REPO_ROOT = Path(__file__).resolve().parent.parent
DOCS_DIR = REPO_ROOT / "docs"

# Matches a Mappls distribution repo URL, with or without a trailing ".git".
# The distribution repos live under a couple of GitHub orgs ("MapmyIndia" and
# "mappls-api"), so accept either rather than hard-coding one.
DIST_URL_RE = re.compile(
    r"https://github\.com/(?:MapmyIndia|mappls-api)/"
    r"[A-Za-z0-9._-]*distribution[A-Za-z0-9._-]*(?:\.git)?"
)

# Authoritative module -> distribution repo map (keyed by the module doc's
# filename stem). These are the canonical MapmyIndia SPM repos this project
# tracks. We PIN to these rather than trusting whatever URL happens to live
# inside a doc, because copying a full remote README can introduce links to a
# different/older distribution channel (e.g. the parallel "mappls-api" org).
MODULE_REPOS: dict[str, str] = {
    "MapplsAPICore": "https://github.com/MapmyIndia/mappls-api-core-distribution.git",
    "MapplsAPIKit": "https://github.com/MapmyIndia/mappls-api-kit-distribution.git",
    "MapplsMap": "https://github.com/MapmyIndia/mappls-map-ios-distribution.git",
    "MapplsUIWidgets": "https://github.com/MapmyIndia/mappls-ui-widget-ios-distribution.git",
    "MapplsNearbyUI": "https://github.com/MapmyIndia/mappls-nearby-ui-ios-distribution.git",
    "MapplsDirectionUI": "https://github.com/MapmyIndia/mappls-direction-ui-ios-distribution.git",
    "MapplsFeedbackKit": "https://github.com/MapmyIndia/mappls-feedback-kit-ios-distribution.git",
    "MapplsFeedbackUIKit": "https://github.com/MapmyIndia/mappls-feedback-ui-kit-ios-distribution.git",
    "MapplsAnnotationExtension": "https://github.com/MapmyIndia/mappls-annotation-extension-ios-distribution.git",
    "MapplsGeofenceUI": "https://github.com/MapmyIndia/mappls-geofence-ui-ios-distribution.git",
}

# A git tag that is a plain semantic version, e.g. "1.0.18" or "2.0.37".
SEMVER_TAG_RE = re.compile(r"^\d+(?:\.\d+){1,3}$")

# A row in a "Version History" markdown table. Captures the version string.
# Handles the real-world inconsistency of optional spaces/backticks:
#   | `1.0.18 `| 17 Jul 2026 | - Improvements. |
#   | `2.0.37`| 17 jul 2026 | - Improvements and Bug Fixes.|
VERSION_ROW_RE = re.compile(r"^\s*\|\s*`?\s*(\d+(?:\.\d+){1,3})\s*`?\s*\|")


def log(msg: str = "") -> None:
    print(msg, flush=True)


def version_key(version: str) -> tuple[int, ...]:
    """Return a sortable tuple for a dotted numeric version string."""
    return tuple(int(part) for part in version.split("."))


def is_newer(candidate: str, baseline: str | None) -> bool:
    """True if ``candidate`` is a strictly higher version than ``baseline``."""
    if baseline is None:
        return True
    return version_key(candidate) > version_key(baseline)


# --------------------------------------------------------------------------- #
# Git interaction
# --------------------------------------------------------------------------- #

def latest_remote_version(repo_url: str) -> str | None:
    """Return the highest semantic-version git tag for ``repo_url``.

    Uses ``git ls-remote`` so no clone is needed. Returns ``None`` when the
    repo is unreachable or exposes no version-like tags.
    """
    if not repo_url.endswith(".git"):
        repo_url = repo_url + ".git"
    try:
        result = subprocess.run(
            ["git", "ls-remote", "--tags", "--refs", repo_url],
            capture_output=True,
            text=True,
            timeout=60,
            check=True,
        )
    except (subprocess.CalledProcessError, subprocess.TimeoutExpired, FileNotFoundError) as exc:
        log(f"    ! could not read tags from {repo_url}: {exc}")
        return None

    versions: list[str] = []
    for line in result.stdout.splitlines():
        # line format: "<sha>\trefs/tags/<tag>"
        parts = line.split("refs/tags/")
        if len(parts) != 2:
            continue
        tag = parts[1].strip()
        if SEMVER_TAG_RE.match(tag):
            versions.append(tag)

    if not versions:
        return None
    return max(versions, key=version_key)


def remote_default_branch(repo_url: str) -> str | None:
    """Return the default branch name (e.g. 'main') of a remote repo."""
    if not repo_url.endswith(".git"):
        repo_url = repo_url + ".git"
    try:
        result = subprocess.run(
            ["git", "ls-remote", "--symref", repo_url, "HEAD"],
            capture_output=True, text=True, timeout=60, check=True,
        )
    except (subprocess.CalledProcessError, subprocess.TimeoutExpired,
            FileNotFoundError):
        return None
    # Output starts with: "ref: refs/heads/main\tHEAD"
    for line in result.stdout.splitlines():
        if line.startswith("ref:") and "refs/heads/" in line:
            return line.split("refs/heads/")[1].split("\t")[0].strip()
    return None


# --------------------------------------------------------------------------- #
# Remote documentation (fetched from the distribution repos)
# --------------------------------------------------------------------------- #

def repo_slug(repo_url: str) -> str:
    """Turn a distribution repo URL into its ``owner/name`` slug."""
    slug = repo_url
    slug = slug.replace("https://github.com/", "")
    slug = slug.replace("http://github.com/", "")
    if slug.endswith(".git"):
        slug = slug[:-4]
    return slug.strip("/")


def _http_get(url: str, timeout: int = 30) -> str | None:
    """Fetch a URL, returning its text body or ``None`` on any failure."""
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "mappls-docs-updater"})
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            if resp.status != 200:
                return None
            charset = resp.headers.get_content_charset() or "utf-8"
            return resp.read().decode(charset, errors="replace")
    except (urllib.error.URLError, urllib.error.HTTPError, TimeoutError,
            OSError, ValueError):
        return None


def _candidate_refs(version: str, default_branch: str | None) -> list[str]:
    """Refs to try, in order: exact version tag, default branch, main, master."""
    refs: list[str] = [version]
    if default_branch:
        refs.append(default_branch)
    for b in ("main", "master"):
        if b not in refs:
            refs.append(b)
    return refs


def fetch_remote_file(repo_url: str, version: str, default_branch: str | None,
                      filenames: tuple[str, ...]) -> str | None:
    """Fetch the first available file (by name, across refs) from a repo.

    Tries the exact version tag first (so content matches the released
    version), then the default branch / main / master. Returns the file text or
    ``None`` if none of the names exist at any ref.
    """
    slug = repo_slug(repo_url)
    for ref in _candidate_refs(version, default_branch):
        for filename in filenames:
            url = f"https://raw.githubusercontent.com/{slug}/{ref}/{filename}"
            text = _http_get(url)
            if text:
                return text
    return None


def fetch_remote_readme(repo_url: str, version: str,
                        default_branch: str | None) -> str | None:
    """Fetch the distribution repo's README documentation.

    Repos are inconsistent about the README filename casing
    (README.md vs Readme.md vs readme.md), so try each.
    """
    return fetch_remote_file(
        repo_url, version, default_branch,
        ("README.md", "Readme.md", "readme.md"),
    )


def fetch_remote_changelog(repo_url: str, version: str,
                           default_branch: str | None) -> str | None:
    """Fetch a native CHANGELOG file from the distribution repo, if present."""
    return fetch_remote_file(
        repo_url, version, default_branch,
        ("CHANGELOG.md", "Changelog.md", "changelog.md",
         "CHANGELOG", "CHANGES.md"),
    )


def derive_changelog_from_readme(readme_text: str, module_name: str) -> str | None:
    """Convert a README "Version History" table into CHANGELOG markdown.

    Produces the same shape the local ``CHANGELOG/<Module>.md`` files use:

        # Changes to the <Module> SDK for iOS

        ## <ver> - <date>

        ### Changes
        - <bullet>
        - <bullet>

    Returns ``None`` if no version-history rows are found.
    """
    rows: list[tuple[str, str, str]] = []
    for line in readme_text.splitlines():
        m = VERSION_ROW_RE.match(line)
        if not m:
            continue
        version = m.group(1)
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) < 3:
            continue
        date = cells[1].strip()
        description = cells[2].strip()
        rows.append((version, date, description))

    if not rows:
        return None

    out: list[str] = [f"# Changes to the {module_name} SDK for iOS", ""]
    for version, date, description in rows:
        out.append(f"## {version} - {date}")
        out.append("")
        out.append("### Changes")
        # Descriptions use "<br>" (or "<Br>") as line separators and often
        # start each item with a leading "- ". Normalise into clean bullets.
        parts = re.split(r"(?i)<br\s*/?>", description)
        wrote_bullet = False
        for part in parts:
            text = part.strip()
            text = re.sub(r"^-\s*", "", text).strip()  # drop existing leading dash
            if not text:
                continue
            out.append(f"- {text}")
            wrote_bullet = True
        if not wrote_bullet:
            out.append("- Improvements and bug fixes.")
        out.append("")
    return "\n".join(out).rstrip() + "\n"


def extract_history_row(readme_text: str, version: str) -> tuple[str, str] | None:
    """Pull the (date, description) for ``version`` from a Version History table.

    Returns ``(date, description)`` with surrounding whitespace trimmed, or
    ``None`` if no row for that version is present.
    """
    for line in readme_text.splitlines():
        row = VERSION_ROW_RE.match(line)
        if not row or row.group(1) != version:
            continue
        # Split the markdown row into cells. Leading/trailing pipes produce
        # empty first/last cells which we drop.
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) >= 3:
            date = cells[1].strip()
            description = cells[2].strip()
            return (date, description)
    return None


# --------------------------------------------------------------------------- #
# Doc discovery
# --------------------------------------------------------------------------- #

@dataclass
class ModuleDoc:
    name: str                 # e.g. "MapplsAPICore" (the .md stem)
    path: Path                # path to the module .md
    repo_url: str             # discovered SPM distribution URL
    current_doc_version: str | None = None   # top row of its Version History
    latest_remote: str | None = None         # highest tag on the repo
    updated: bool = False


def find_latest_docs_dir(explicit: str | None) -> Path:
    """Return the docs/vX.Y.Z directory to operate on."""
    if explicit:
        candidate = DOCS_DIR / explicit
        if not candidate.is_dir():
            sys.exit(f"error: docs version folder not found: {candidate}")
        return candidate

    version_dirs = [
        d for d in DOCS_DIR.iterdir()
        if d.is_dir() and re.fullmatch(r"v\d+(?:\.\d+){1,3}", d.name)
    ]
    if not version_dirs:
        sys.exit(f"error: no versioned docs folders found under {DOCS_DIR}")
    return max(version_dirs, key=lambda d: version_key(d.name[1:]))


def bump_patch(docs_version: str) -> str:
    """Return the next doc-folder version by bumping the last numeric part.

    e.g. ``v1.0.35`` -> ``v1.0.36``.
    """
    bare = docs_version.lstrip("v")
    parts = bare.split(".")
    parts[-1] = str(int(parts[-1]) + 1)
    return "v" + ".".join(parts)


def normalise_version_arg(value: str) -> str:
    """Accept ``1.0.36`` or ``v1.0.36`` and return the ``vX.Y.Z`` form."""
    value = value.strip()
    if not value.startswith("v"):
        value = "v" + value
    if not re.fullmatch(r"v\d+(?:\.\d+){1,3}", value):
        sys.exit(f"error: invalid version '{value}'. Expected form like v1.0.36")
    return value


def discover_spm_url(md_text: str, module_name: str | None = None) -> str | None:
    """Find the SPM distribution URL that this module should be installed from.

    A module doc contains the module's own install URL in an SPM
    "Add Package Dependencies" block, but it may ALSO list its dependencies'
    distribution URLs in a separate table. We must return the module's own URL,
    not a dependency's.

    Strategy, most to least reliable:
      1. Take the first distribution URL inside the install block (a bounded
         window right after the "Enter the repository URL" prompt).
      2. Otherwise, among all distribution URLs in the doc, prefer the one whose
         repo name best matches ``module_name`` (e.g. "MapplsDirectionUI" ->
         ".../mappls-direction-ui-...").
      3. Otherwise, the first distribution URL anywhere.
    """
    lower = md_text.lower()

    # (1) Install block: search only a short window after the prompt so we stop
    #     before any "Dependencies" table that follows.
    anchor = lower.find("enter the repository url")
    if anchor != -1:
        window = md_text[anchor:anchor + 400]
        match = DIST_URL_RE.search(window)
        if match:
            return match.group(0)

    all_urls = DIST_URL_RE.findall(md_text)
    if not all_urls:
        return None

    # (2) Prefer the URL whose repo slug matches the module name.
    if module_name:
        # "MapplsDirectionUI" -> tokens like "direction", "ui"
        tokens = re.findall(r"[A-Z][a-z0-9]+", module_name.replace("Mappls", ""))
        tokens = [t.lower() for t in tokens if t.lower() not in ("i", "o")]
        best = None
        best_score = -1
        for url in all_urls:
            slug = url.rsplit("/", 1)[-1].lower()
            score = sum(1 for t in tokens if t in slug)
            if score > best_score:
                best_score, best = score, url
        if best is not None and best_score > 0:
            return best

    # (3) First distribution URL anywhere.
    return all_urls[0]


def top_version_in_history(md_text: str) -> str | None:
    """Return the version of the first row in the module's Version History."""
    in_table = False
    for line in md_text.splitlines():
        row = VERSION_ROW_RE.match(line)
        if row:
            return row.group(1)
        # keep scanning; the first matching row anywhere is the newest listed
        _ = in_table
    return None


def collect_modules(docs_dir: Path, only: list[str] | None) -> list[ModuleDoc]:
    modules: list[ModuleDoc] = []
    for md_path in sorted(docs_dir.glob("*.md")):
        if md_path.name.lower() == "readme.md":
            continue
        if only and md_path.stem not in only:
            continue
        text = md_path.read_text(encoding="utf-8")
        # Prefer the pinned authoritative repo; fall back to discovering the URL
        # from the doc only for modules we haven't explicitly mapped.
        url = MODULE_REPOS.get(md_path.stem)
        if not url:
            url = discover_spm_url(text, module_name=md_path.stem)
        if not url:
            continue  # module not distributed via SPM (yet)
        modules.append(
            ModuleDoc(
                name=md_path.stem,
                path=md_path,
                repo_url=url,
                current_doc_version=top_version_in_history(text),
            )
        )
    return modules


# --------------------------------------------------------------------------- #
# Doc editing
# --------------------------------------------------------------------------- #

def insert_version_history_row(md_text: str, version: str, date_str: str,
                               description: str) -> str | None:
    """Insert a new row at the top of the Version History table.

    Returns the new text, or ``None`` if the table could not be located.
    """
    lines = md_text.splitlines(keepends=True)
    for idx, line in enumerate(lines):
        if VERSION_ROW_RE.match(line):
            # Use the existing top row's line terminator so the inserted row
            # sits on its own line regardless of how the file ends lines.
            terminator = "\n"
            if line.endswith("\r\n"):
                terminator = "\r\n"
            # Clean, consistent row; always terminated so the next row stays
            # on its own line.
            new_row = f"| `{version}` | {date_str} | {description}|{terminator}"
            lines.insert(idx, new_row)
            return "".join(lines)
    return None


def update_readme_versions(readme_path: Path, docs_version: str,
                           module_versions: dict[str, str],
                           dry_run: bool) -> bool:
    """Update module version numbers on the current docs-version row of a README.

    The Documentation History table lists entries like
    ``[MapplsAPICore - 1.0.18](...)``. We only touch the row whose version
    label matches ``docs_version`` (e.g. ``1.0.35``) so historical rows stay
    intact.
    """
    text = readme_path.read_text(encoding="utf-8")
    lines = text.splitlines(keepends=True)
    bare_version = docs_version.lstrip("v")

    changed = False
    for i, line in enumerate(lines):
        # Identify the current-version row of the Documentation History table.
        if not line.lstrip().startswith("|"):
            continue
        if f"[{bare_version}]" not in line and f"| {bare_version} " not in line \
                and f"[{bare_version}](" not in line:
            # also allow "| [1.0.35](...)" form
            if f"[{bare_version}]" not in line:
                continue

        new_line = line
        for module, version in module_versions.items():
            # The README version table sometimes labels a module slightly
            # differently from its doc filename (e.g. doc "MapplsUIWidgets" is
            # listed as "MapplsUIWidget"). Try the exact name first, then a few
            # tolerant singular/plural variants.
            label_variants = [module]
            if module.endswith("s"):
                label_variants.append(module[:-1])   # MapplsUIWidgets -> ...Widget
            else:
                label_variants.append(module + "s")
            for label in label_variants:
                pattern = re.compile(
                    rf"({re.escape(label)}\s*-\s*)\d+(?:\.\d+){{1,3}}"
                )
                if pattern.search(new_line):
                    new_line = pattern.sub(rf"\g<1>{version}", new_line)
                    break
        if new_line != line:
            lines[i] = new_line
            changed = True

    if changed and not dry_run:
        readme_path.write_text("".join(lines), encoding="utf-8")
    return changed


# --------------------------------------------------------------------------- #
# New-doc-version creation
# --------------------------------------------------------------------------- #

def find_doc_history_row(lines: list[str], bare_version: str) -> int | None:
    """Index of the Documentation History row whose label is ``bare_version``."""
    for i, line in enumerate(lines):
        if line.lstrip().startswith("|") and f"[{bare_version}]" in line:
            return i
    return None


# Matches a Documentation History data row and captures its version label,
# e.g. "| [1.0.35](...) | - [MapplsAPICore - 1.0.18](...) ... |".
DOC_HISTORY_ROW_RE = re.compile(r"^\s*\|\s*\[(\d+(?:\.\d+){1,3})\]")


def _newest_doc_history_row(lines: list[str]) -> tuple[int, str] | None:
    """Return ``(index, version)`` of the highest-version Documentation History
    row, or ``None`` if the table has no version rows."""
    indexed: list[tuple[int, str]] = []
    for i, line in enumerate(lines):
        m = DOC_HISTORY_ROW_RE.match(line)
        if m:
            indexed.append((i, m.group(1)))
    if not indexed:
        return None
    return max(indexed, key=lambda t: version_key(t[1]))


def drop_oldest_doc_history_row(lines: list[str]) -> str | None:
    """Remove the oldest version row from a Documentation History table.

    Mutates ``lines`` in place. Returns the version label that was dropped, or
    ``None`` if fewer than two version rows are present (nothing to trim).
    """
    indexed: list[tuple[int, str]] = []
    for i, line in enumerate(lines):
        m = DOC_HISTORY_ROW_RE.match(line)
        if m:
            indexed.append((i, m.group(1)))

    # Only trim when more than one version row exists, so we never empty the
    # table.
    if len(indexed) < 2:
        return None

    oldest_idx, oldest_ver = min(indexed, key=lambda t: version_key(t[1]))
    del lines[oldest_idx]
    return oldest_ver


def create_new_doc_version(old_dir: Path, new_version: str,
                           dry_run: bool) -> Path:
    """Copy ``old_dir`` to a new ``docs/<new_version>`` folder and wire up the
    Documentation History tables in the root README and the new folder's README.

    Returns the path to the new docs folder (which may not yet exist on disk in
    dry-run mode).
    """
    old_version = old_dir.name            # e.g. "v1.0.35"
    old_bare = old_version.lstrip("v")
    new_bare = new_version.lstrip("v")
    new_dir = DOCS_DIR / new_version

    if new_dir.exists():
        sys.exit(f"error: docs folder already exists: {new_dir}")

    log(f"Creating new doc version {new_version} (copied from {old_version})")

    # 1. Copy the folder.
    if dry_run:
        log(f"  WOULD copy {old_dir.relative_to(REPO_ROOT)} "
            f"-> docs/{new_version}")
    else:
        shutil.copytree(old_dir, new_dir)
        log(f"  copied -> docs/{new_version}")

    # 2. Root README: prepend a new current-version row pointing at the new
    #    folder, cloned from the (previous) current row.
    root_readme = REPO_ROOT / "README.md"
    _prepend_root_readme_row(root_readme, old_bare, new_bare, dry_run)

    # 3. New folder's README: the former current row used bare paths; demote it
    #    to a "../<old_version>/..." history row, then prepend a fresh
    #    bare-path row for the new version.
    new_readme = new_dir / "README.md"
    _rewrite_new_folder_readme(
        new_readme, old_version, old_bare, new_bare, dry_run
    )

    return new_dir


def _prepend_root_readme_row(root_readme: Path, old_bare: str, new_bare: str,
                             dry_run: bool) -> None:
    """Add a new top data row to the root README's Documentation History.

    The root README references docs with ``./docs/vX.Y.Z/...`` paths, so cloning
    the previous current row and swapping the version folder is enough.
    """
    if not root_readme.exists():
        return
    text = root_readme.read_text(encoding="utf-8")
    lines = text.splitlines(keepends=True)

    # Prefer cloning the exact previous-version row. If the chain has a gap
    # (that row isn't present), fall back to the NEWEST version row in the
    # table so the root README still gets updated robustly.
    idx = find_doc_history_row(lines, old_bare)
    template_bare = old_bare
    if idx is None:
        newest = _newest_doc_history_row(lines)
        if newest is None:
            log(f"  ! no Documentation History rows found in {root_readme.name}; "
                f"skipping root README")
            return
        idx, template_bare = newest
        log(f"  (note: no {old_bare} row in README.md; cloning newest row "
            f"{template_bare} instead)")

    old_row = lines[idx]
    new_row = old_row.replace(f"v{template_bare}", f"v{new_bare}")
    new_row = new_row.replace(f"[{template_bare}]", f"[{new_bare}]")
    if dry_run:
        # Preview which oldest row would be dropped (don't mutate real lines).
        preview = list(lines)
        preview.insert(idx, new_row)
        dropped = drop_oldest_doc_history_row(preview)
        log(f"  WOULD prepend row for {new_bare} to README.md"
            + (f" and drop oldest row {dropped}" if dropped else ""))
    else:
        lines.insert(idx, new_row)
        dropped = drop_oldest_doc_history_row(lines)
        root_readme.write_text("".join(lines), encoding="utf-8")
        log(f"  added {new_bare} row to README.md"
            + (f", dropped oldest row {dropped}" if dropped else ""))


def _rewrite_new_folder_readme(new_readme: Path, old_version: str,
                               old_bare: str, new_bare: str,
                               dry_run: bool) -> None:
    """Fix the Documentation History table inside the new folder's README.

    Inside a versioned folder, the CURRENT version row uses bare paths
    (``README.md``, ``MapplsMap.md``) while every older row uses
    ``../vX.Y.Z/...`` paths. When we promote ``new_bare`` to current we must:
      * convert the previously-current row (``old_bare``, bare paths) into a
        ``../<old_version>/...`` history row, and
      * insert a new current row for ``new_bare`` using bare paths.
    """
    if not new_readme.exists() and not dry_run:
        log(f"  ! {new_readme} missing; skipping new-folder README")
        return
    if dry_run and not new_readme.exists():
        # Folder wasn't copied in dry-run; derive from the source instead.
        new_readme = DOCS_DIR / old_version / "README.md"

    text = new_readme.read_text(encoding="utf-8")
    lines = text.splitlines(keepends=True)
    idx = find_doc_history_row(lines, old_bare)
    if idx is None:
        log(f"  ! could not find row for {old_bare} in docs/{new_bare}/README.md")
        return

    current_row = lines[idx]

    # Build the new CURRENT row (bare paths) by cloning the current row and
    # bumping only the version label.
    new_current_row = current_row.replace(f"[{old_bare}]", f"[{new_bare}]")

    # Demote the old current row to a history row: bare paths -> ../vOLD/ paths.
    # Links look like "(README.md)", "(MapplsMap.md#...)", "(RasterCatalouge.md)".
    def _relativise(match: re.Match) -> str:
        inner = match.group(1)
        return f"](../{old_version}/{inner})"

    demoted_row = re.sub(r"\]\((?!\.\./|https?:)([^)]+)\)", _relativise,
                         current_row)

    if dry_run:
        preview = list(lines)
        preview[idx] = demoted_row
        preview.insert(idx, new_current_row)
        dropped = drop_oldest_doc_history_row(preview)
        log(f"  WOULD set docs/{new_bare}/README.md current row to {new_bare}, "
            f"demote {old_bare} to history"
            + (f", drop oldest row {dropped}" if dropped else ""))
        return

    lines[idx] = demoted_row
    lines.insert(idx, new_current_row)
    dropped = drop_oldest_doc_history_row(lines)
    new_readme.write_text("".join(lines), encoding="utf-8")
    log(f"  rewrote docs/{new_bare}/README.md history table"
        + (f", dropped oldest row {dropped}" if dropped else ""))


def _dedupe_leading_title(text: str) -> str:
    """Collapse an immediately-repeated leading '# ...' title line.

    Some upstream CHANGELOG files accidentally repeat their title line twice;
    keep just the first.
    """
    lines = text.splitlines()
    if len(lines) >= 2 and lines[0].startswith("# ") and lines[0] == lines[1]:
        del lines[1]
    return "\n".join(lines)


def _changelog_top_version(path: Path) -> str | None:
    """Return the newest version in a local CHANGELOG file, or None."""
    if not path.exists():
        return None
    for line in path.read_text(encoding="utf-8").splitlines():
        m = re.match(r"^##\s+(\d+(?:\.\d+){1,3})\s*-", line)
        if m:
            return m.group(1)
    return None


def update_module_changelog(docs_dir: Path, module_name: str, repo_url: str,
                            version: str, default_branch: str | None,
                            remote_readme: str | None, no_fetch: bool,
                            dry_run: bool) -> str:
    """Refresh ``docs/<version>/CHANGELOG/<Module>.md`` from the distribution repo.

    Prefers a native CHANGELOG file in the repo; otherwise derives one from the
    README's Version History table (reusing an already-fetched README when
    available). Returns a short status label describing what was done.
    """
    changelog_dir = docs_dir / "CHANGELOG"
    target = changelog_dir / f"{module_name}.md"

    if no_fetch:
        return "changelog: skipped (--no-fetch)"

    # 1. Prefer the repo's own CHANGELOG file.
    content = fetch_remote_changelog(repo_url, version, default_branch)
    source = "native CHANGELOG"

    # 2. Otherwise derive from the README version-history table.
    if not content:
        readme = remote_readme
        if readme is None:
            readme = fetch_remote_readme(repo_url, version, default_branch)
        if readme:
            content = derive_changelog_from_readme(readme, module_name)
            source = "derived from README version history"

    if not content:
        return "changelog: no source available (left unchanged)"

    content = _dedupe_leading_title(content)
    if not content.endswith("\n"):
        content += "\n"

    if dry_run:
        return f"changelog: WOULD write {target.name} ({source})"

    changelog_dir.mkdir(parents=True, exist_ok=True)
    target.write_text(content, encoding="utf-8")
    return f"changelog: wrote {target.name} ({source})"


def prompt_mode(current_version: str, suggested_new: str) -> tuple[bool, str | None]:
    """Interactively ask whether to update current docs or create a new version.

    Returns ``(create_new, new_version_or_None)``.
    """
    log("How should the docs be updated?")
    log(f"  [1] Update the CURRENT doc version in place ({current_version})")
    log(f"  [2] Create a NEW doc version (suggested: {suggested_new})")
    while True:
        try:
            choice = input("Choose 1 or 2 [1]: ").strip()
        except EOFError:
            # Non-interactive stdin: default to updating current in place.
            log("(no input available; defaulting to update current)")
            return (False, None)
        if choice in ("", "1"):
            return (False, None)
        if choice == "2":
            entered = input(
                f"New version [{suggested_new}]: "
            ).strip()
            new_version = normalise_version_arg(entered) if entered else suggested_new
            return (True, new_version)
        log("Please enter 1 or 2.")


# --------------------------------------------------------------------------- #
# Main
# --------------------------------------------------------------------------- #

def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--dry-run", action="store_true",
                        help="Preview changes without writing any files.")
    parser.add_argument("--docs-version", default=None,
                        help="Operate on a specific docs folder, e.g. v1.0.35 "
                             "(defaults to the newest one).")
    parser.add_argument("--only", nargs="*", default=None,
                        help="Limit to specific module doc names, e.g. "
                             "MapplsMap MapplsAPIKit.")
    parser.add_argument("--date", default=None,
                        help="Date to stamp on new version-history rows "
                             "(default: today, formatted as 'DD Mon YYYY').")
    parser.add_argument("--note", default="- Improvements and Bug Fixes.",
                        help="Fallback description for new version-history rows "
                             "when the distribution repo has no documentation.")
    parser.add_argument("--no-fetch", action="store_true",
                        help="Do not fetch documentation from the distribution "
                             "repos; always use --date and --note instead.")
    parser.add_argument("--row-only", action="store_true",
                        help="Only splice the new version-history row into the "
                             "existing doc instead of replacing the whole module "
                             "doc with the distribution repo's full README.")

    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--update-current", action="store_true",
                      help="Update the current doc version in place "
                           "(skip the prompt).")
    mode.add_argument("--new-version", nargs="?", const="__auto__", default=None,
                      metavar="VERSION",
                      help="Create a new doc version folder. Optionally pass a "
                           "version like v1.0.36; omit it to auto-bump the "
                           "patch number. Skips the prompt.")
    parser.add_argument("-y", "--yes", action="store_true",
                        help="Assume defaults for any prompt "
                             "(update current in place unless --new-version).")
    args = parser.parse_args()

    source_dir = find_latest_docs_dir(args.docs_version)
    source_version = source_dir.name
    suggested_new = bump_patch(source_version)
    date_str = args.date or _dt.date.today().strftime("%d %b %Y")

    # Decide the mode: create a new doc version, or update current in place.
    create_new = False
    new_version: str | None = None
    if args.new_version is not None:
        create_new = True
        new_version = (suggested_new if args.new_version == "__auto__"
                       else normalise_version_arg(args.new_version))
    elif args.update_current or args.yes:
        create_new = False
    else:
        create_new, new_version = prompt_mode(source_version, suggested_new)
        if create_new and new_version is None:
            new_version = suggested_new

    log("")
    log(f"Repo root       : {REPO_ROOT}")
    log(f"Source docs     : {source_version}")
    if create_new:
        log(f"Target          : NEW doc version {new_version}")
    else:
        log(f"Target          : update current ({source_version}) in place")
    log(f"Mode            : {'DRY-RUN (no files written)' if args.dry_run else 'APPLY'}")
    log("")

    # When creating a new version, clone the folder and wire up the README
    # tables first; subsequent module/version updates then run against it.
    if create_new:
        new_dir = create_new_doc_version(source_dir, new_version, args.dry_run)
        if args.dry_run:
            # In dry-run the new folder doesn't exist, so analyse the source
            # folder but report against the new version label.
            docs_dir = source_dir
        else:
            docs_dir = new_dir
        docs_version = new_version
        log("")
    else:
        docs_dir = source_dir
        docs_version = source_version

    modules = collect_modules(docs_dir, args.only)
    if not modules:
        log("No SPM-distributed modules discovered. Nothing to do.")
        return 0

    log(f"Discovered {len(modules)} SPM-distributed module doc(s). "
        f"Querying latest released versions...\n")

    latest_versions: dict[str, str] = {}

    for mod in modules:
        log(f"- {mod.name}")
        log(f"    repo    : {mod.repo_url}")
        log(f"    doc ver : {mod.current_doc_version or '(none found)'}")
        mod.latest_remote = latest_remote_version(mod.repo_url)
        log(f"    latest  : {mod.latest_remote or '(unavailable)'}")

        if mod.latest_remote is None:
            log("    -> skipped (could not determine latest version)\n")
            continue

        latest_versions[mod.name] = mod.latest_remote

        if not is_newer(mod.latest_remote, mod.current_doc_version):
            # The module doc is current, but its CHANGELOG file may still be
            # behind (changelogs and the main doc are tracked separately).
            # Refresh the changelog when it lags the latest released version.
            cl_top = _changelog_top_version(
                docs_dir / "CHANGELOG" / f"{mod.name}.md"
            )
            if not args.no_fetch and is_newer(mod.latest_remote, cl_top):
                default_branch = remote_default_branch(mod.repo_url)
                cl_status = update_module_changelog(
                    docs_dir, mod.name, mod.repo_url, mod.latest_remote,
                    default_branch, None, args.no_fetch, args.dry_run,
                )
                log(f"    -> up to date (doc); {cl_status}\n")
            else:
                log("    -> up to date\n")
            continue

        # Fetch the full documentation for this version from the distribution
        # repo. We prefer to replace the entire module doc with the repo's
        # README so ALL content (new API sections, changelog, etc.) is copied.
        remote_readme: str | None = None
        default_branch: str | None = None
        if not args.no_fetch:
            default_branch = remote_default_branch(mod.repo_url)
            remote_readme = fetch_remote_readme(
                mod.repo_url, mod.latest_remote, default_branch
            )

        # Decision tree:
        #   * full README available and not --row-only  -> replace whole doc
        #   * otherwise                                  -> splice a single row
        if remote_readme and not args.row_only:
            mod.updated = True
            size_kb = len(remote_readme) / 1024
            log("    doc src : full README from distribution repo "
                f"({size_kb:.1f} KB)")
            if args.dry_run:
                log(f"    -> WOULD replace {mod.path.name} with full remote "
                    f"README for {mod.latest_remote}\n")
            else:
                # Normalise to a trailing newline for a clean file.
                content = remote_readme if remote_readme.endswith("\n") \
                    else remote_readme + "\n"
                mod.path.write_text(content, encoding="utf-8")
                log(f"    -> replaced {mod.path.name} with full remote README "
                    f"for {mod.latest_remote}")
            cl_status = update_module_changelog(
                docs_dir, mod.name, mod.repo_url, mod.latest_remote,
                default_branch, remote_readme, args.no_fetch, args.dry_run,
            )
            log(f"    -> {cl_status}\n")
            continue

        # Row-splice path (either --row-only, or no remote README available).
        row_date = date_str
        row_desc = args.note
        source_label = "generic note (no remote doc)"
        if remote_readme:
            found = extract_history_row(remote_readme, mod.latest_remote)
            if found:
                row_date, row_desc = found
                source_label = ("row from distribution repo README"
                                if args.row_only
                                else "row from distribution repo README")
            else:
                source_label = ("remote README found but no row for "
                                f"{mod.latest_remote}; using generic note")
        elif not args.no_fetch:
            source_label = "no remote README; using generic note"

        text = mod.path.read_text(encoding="utf-8")
        new_text = insert_version_history_row(
            text, mod.latest_remote, row_date, row_desc
        )
        if new_text is None:
            log("    -> could not find Version History table to update\n")
            continue
        mod.updated = True
        preview_desc = (row_desc if len(row_desc) <= 80
                        else row_desc[:77] + "...")
        log(f"    doc src : {source_label}")
        if args.dry_run:
            log(f"    -> WOULD add row: | `{mod.latest_remote}` | "
                f"{row_date} | {preview_desc}|")
        else:
            mod.path.write_text(new_text, encoding="utf-8")
            log(f"    -> added row: | `{mod.latest_remote}` | {row_date} | "
                f"{preview_desc}|")
        cl_status = update_module_changelog(
            docs_dir, mod.name, mod.repo_url, mod.latest_remote,
            default_branch, remote_readme, args.no_fetch, args.dry_run,
        )
        log(f"    -> {cl_status}\n")

    # Update README version tables.
    log("Updating Documentation History tables in README files...")
    readmes = [REPO_ROOT / "README.md", docs_dir / "README.md"]
    for readme in readmes:
        if not readme.exists():
            continue
        changed = update_readme_versions(
            readme, docs_version, latest_versions, args.dry_run
        )
        status = ("would update" if args.dry_run else "updated") if changed else "no change"
        log(f"  {readme.relative_to(REPO_ROOT)}: {status}")

    log("\nDone.")
    if args.dry_run:
        log("This was a dry run. Re-run without --dry-run to apply the changes.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
