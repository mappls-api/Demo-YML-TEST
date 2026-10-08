#!/usr/bin/env python3
"""
create_release.py

End-to-end release creation for the Mappls iOS SDK docs repo:

  1. Resolve the SDK docs version (newest ``docs/vX.Y.Z`` or ``--version``).
  2. Build the release note from that version's CHANGELOG folder and write
     ``docs/vX.Y.Z/RELEASE_NOTES.md`` (reuses ``release_from_changelog``).
  3. Stage and commit the docs for that version.
  4. Create an annotated git tag whose message is the release note.
  5. Push the branch and the tag to the remote.
  6. Create a GitHub release with the ``gh`` CLI, using the note as the body.

Safety
------
Pushing and publishing a GitHub release are hard to reverse and affect a shared
remote, so this script is **dry-run by default**: it prints every git/gh
command it would run and changes nothing. Pass ``--confirm`` to actually commit,
push, and publish.

Usage
-----
    python3 scripts/create_release.py                      # dry-run preview
    python3 scripts/create_release.py --confirm            # do it for real
    python3 scripts/create_release.py --version v1.0.36 --confirm
    python3 scripts/create_release.py --confirm --no-gh-release   # skip GitHub release
    python3 scripts/create_release.py --confirm --local          # commit+tag only, no push

Requires: Python 3.9+, a ``git`` CLI, and (unless ``--no-gh-release``) the
GitHub ``gh`` CLI, authenticated with push access to the remote.
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

# Reuse the note-building logic from the sibling script.
sys.path.insert(0, str(Path(__file__).resolve().parent))
import release_from_changelog as rfc  # noqa: E402

REPO_ROOT = rfc.REPO_ROOT


def log(msg: str = "") -> None:
    print(msg, flush=True)


# --------------------------------------------------------------------------- #
# Command execution
# --------------------------------------------------------------------------- #

def run(cmd: list[str], confirm: bool, *, capture: bool = False,
        check: bool = True) -> subprocess.CompletedProcess | None:
    """Run a git/gh command, or just print it when not confirmed."""
    printable = " ".join(cmd)
    if not confirm:
        log(f"    DRY-RUN $ {printable}")
        return None
    log(f"    $ {printable}")
    result = subprocess.run(
        cmd, text=True,
        capture_output=capture,
    )
    if check and result.returncode != 0:
        if capture and result.stderr:
            log(result.stderr.rstrip())
        sys.exit(f"error: command failed ({result.returncode}): {printable}")
    return result


def git_out(cmd: list[str]) -> str:
    """Run a read-only git command and return stdout (always executes)."""
    return subprocess.run(
        ["git", *cmd], text=True, capture_output=True
    ).stdout.strip()


def _gh_release_exists(tag: str) -> bool:
    """True if a GitHub release already exists for ``tag`` (via the gh CLI)."""
    r = subprocess.run(["gh", "release", "view", tag],
                       capture_output=True, text=True)
    return r.returncode == 0


# --------------------------------------------------------------------------- #
# Pre-flight checks
# --------------------------------------------------------------------------- #

def preflight(tag: str, no_gh: bool, release_only: bool) -> None:
    # Must be inside a git repo.
    if git_out(["rev-parse", "--is-inside-work-tree"]) != "true":
        sys.exit("error: not inside a git working tree.")

    # In --release-only mode the tag is expected to already exist (we're just
    # (re)publishing the release for it), so skip the "must not exist" checks.
    if not release_only:
        # Tag must not already exist locally.
        if git_out(["tag", "--list", tag]):
            sys.exit(f"error: tag '{tag}' already exists locally. "
                     f"Choose another with --tag or delete it first.")

        # Tag must not already exist on the remote.
        remote_tags = git_out(["ls-remote", "--tags", "origin", tag])
        if remote_tags:
            sys.exit(f"error: tag '{tag}' already exists on the remote.")

    # gh must be available/authenticated if we intend to publish.
    if not no_gh:
        which = subprocess.run(["which", "gh"], capture_output=True, text=True)
        if which.returncode != 0:
            sys.exit("error: 'gh' CLI not found. Install it, or pass "
                     "--no-gh-release to skip the GitHub release step.")


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
    parser.add_argument("--title", default=None,
                        help="GitHub release name (default: "
                             "'Mappls iOS SDK <version>').")
    parser.add_argument("--tag", default=None,
                        help="Tag name (defaults to the bare version, e.g. "
                             "1.0.36, matching existing repo tags).")
    parser.add_argument("--remote", default="origin",
                        help="Remote to push to (default: origin).")
    parser.add_argument("--branch", default=None,
                        help="Branch to commit/push (default: current branch).")
    parser.add_argument("--message", default=None,
                        help="Commit message (default: 'docs: release <tag>').")
    parser.add_argument("--confirm", action="store_true",
                        help="Actually commit, push, and publish. Without this "
                             "the script only previews (dry-run).")
    parser.add_argument("--local", action="store_true",
                        help="Commit and tag locally but do NOT push.")
    parser.add_argument("--no-commit", action="store_true",
                        help="Do not create a commit; tag the current HEAD "
                             "as-is (assumes docs are already committed).")
    parser.add_argument("--no-gh-release", action="store_true",
                        help="Skip creating the GitHub release.")
    parser.add_argument("--release-only", action="store_true",
                        help="Only (re)publish the GitHub release for an "
                             "already-existing tag: no commit, no new tag, no "
                             "push. The release notes are rebuilt from the "
                             "changed SDKs' changelogs.")
    args = parser.parse_args()

    if args.release_only:
        # Release-only implies: don't commit, don't make a tag, don't push.
        args.no_commit = True

    confirm = args.confirm
    docs_dir = rfc.find_docs_dir(args.version)
    docs_version = docs_dir.name                 # e.g. "v1.0.36"
    bare = docs_version.lstrip("v")
    tag = args.tag or bare
    branch = args.branch or git_out(["rev-parse", "--abbrev-ref", "HEAD"])
    commit_msg = args.message or f"docs: release {tag}"
    notes_path = docs_dir / "RELEASE_NOTES.md"
    push = confirm and not args.local

    log(f"Repo root     : {REPO_ROOT}")
    log(f"Docs version  : {docs_version}")
    log(f"Tag           : {tag}")
    log(f"Branch        : {branch}")
    log(f"Remote        : {args.remote}")
    log(f"GitHub release: {'no' if args.no_gh_release else 'yes'}")
    log(f"Mode          : {'EXECUTE' if confirm else 'DRY-RUN (nothing will change)'}")
    log("")

    preflight(tag, args.no_gh_release, args.release_only)

    # 1. Build and write the release note.
    note, module_versions = rfc.build_release_note(docs_dir, docs_version)
    log(f"Assembled release note from {len(module_versions)} module changelog(s).")
    if confirm:
        notes_path.write_text(note, encoding="utf-8")
        log(f"  wrote {notes_path.relative_to(REPO_ROOT)}")
    else:
        log(f"  DRY-RUN would write {notes_path.relative_to(REPO_ROOT)}")
    log("")
    log("----- RELEASE NOTE PREVIEW -----")
    log(note.rstrip())
    log("--------------------------------")
    log("")

    # 2. Commit the docs for this version.
    if not args.no_commit:
        log("Committing docs...")
        paths_to_stage = [
            str(docs_dir.relative_to(REPO_ROOT)),
            "README.md",
            "Version-History.md",
        ]
        # Only stage paths that actually exist.
        existing = [p for p in paths_to_stage if (REPO_ROOT / p).exists()]
        run(["git", "add", *existing], confirm)
        # Commit (allow a no-op to be reported rather than fail the run).
        if confirm:
            staged = git_out(["diff", "--cached", "--name-only"])
            if staged:
                run(["git", "commit", "-m", commit_msg], confirm)
                log(f"  committed: {commit_msg}")
            else:
                log("  nothing staged to commit (docs already committed).")
        else:
            run(["git", "commit", "-m", commit_msg], confirm)
        log("")

    # 3. Create the annotated tag (verbatim so markdown '#' headings survive).
    if args.release_only:
        log("Skipping tag creation (--release-only; tag already exists).\n")
    else:
        log("Creating annotated tag...")
        run(["git", "tag", "-a", tag, "--cleanup=verbatim", "-F",
             str(notes_path)], confirm)
        log("")

    # 4. Push branch + tag.
    if args.release_only:
        log("Skipping push (--release-only).\n")
    elif push:
        log("Pushing branch and tag...")
        run(["git", "push", args.remote, branch], confirm)
        run(["git", "push", args.remote, tag], confirm)
        log("")
    elif args.local:
        log("Skipping push (--local).\n")
    else:
        log("Skipping push (dry-run; use --confirm to push).\n")

    # 5. GitHub release. Create it, or update it if it already exists so the
    #    notes reflect the latest changed-SDK changelog.
    if not args.no_gh_release:
        title = args.title or f"Mappls iOS SDK {bare}"
        # The tag must exist on the remote for a release. That's true when we
        # just pushed it, or in --release-only mode (the tag is pre-existing).
        tag_on_remote = push or args.release_only
        # A brand-new tag can't have a release yet, so only look for an
        # existing release (and fall back to editing it) in --release-only.
        update_existing = (args.release_only and confirm
                           and _gh_release_exists(tag))
        if update_existing:
            log("Updating existing GitHub release...")
            gh_cmd = ["gh", "release", "edit", tag,
                      "--title", title,
                      "--notes-file", str(notes_path),
                      "--target", branch]
        else:
            log("Creating GitHub release...")
            gh_cmd = ["gh", "release", "create", tag,
                      "--title", title,
                      "--notes-file", str(notes_path),
                      "--target", branch]
        if tag_on_remote:
            run(gh_cmd, confirm)
        else:
            # Can't publish a release for an unpushed tag.
            log("    (skipped: needs the tag pushed first)"
                if not confirm else "")
            run(gh_cmd, confirm=False)
        log("")

    log("Done.")
    if not confirm:
        log("This was a DRY RUN. Re-run with --confirm to commit, push, and "
            "publish the release.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
