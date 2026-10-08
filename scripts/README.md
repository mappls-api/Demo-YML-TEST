# SDK docs updater

`update_sdk_docs.py` keeps the Mappls iOS SDK documentation in sync with the
latest module versions published on **Swift Package Manager** — the
distribution repos under [github.com/MapmyIndia](https://github.com/MapmyIndia).

## How it works

1. Finds the newest `docs/vX.Y.Z` folder (or the one you pass with
   `--docs-version`).
2. For each module `.md` in that folder, reads the SPM distribution repo URL
   from its "Add Package Dependencies" install block.
3. Runs `git ls-remote --tags` against each repo to find the highest released
   semantic-version tag (this is the "latest SDK released on SPM").
4. If that version is newer than the local doc, the local module doc is
   **replaced with the distribution repo's full README** (fetched at the
   matching version tag), so **all** content is copied — new API sections, the
   real changelog, everything. If a repo exposes no README (some plugins ship
   only `Package.swift`), or if you pass `--row-only`, the script instead
   splices a single version-history row (real date/description when a README
   exists, otherwise the `--date` / `--note` fallback).
5. The matching **`CHANGELOG/<Module>.md`** file is a verbatim copy of the
   distribution repo's `CHANGELOG.md` (at the released version tag, falling
   back to the default branch). If the repo has no CHANGELOG file, nothing is
   done: the local changelog file is left exactly as it is.
6. Refreshes the module version numbers in the current-version row of the
   **Documentation History** table in both `README.md` and
   `docs/vX.Y.Z/README.md`.

The script is idempotent: running it again when nothing new has shipped makes
no changes.

## Update current version, or create a new one?

When you run the script it first asks how to apply the update:

```
How should the docs be updated?
  [1] Update the CURRENT doc version in place (v1.0.35)
  [2] Create a NEW doc version (suggested: v1.0.36)
Choose 1 or 2 [1]:
```

- **Option 1 (update current)** edits the existing `docs/vX.Y.Z` folder in
  place — handy for correcting or topping up the latest published docs.
- **Option 2 (create new)** copies the current folder to a new
  `docs/vNEW` folder (patch auto-bumped, e.g. `v1.0.36`), adds it as the newest
  row of the Documentation History tables (promoting the previous version to a
  history row with corrected relative links), and then applies the SPM version
  updates there. The previous folder is left untouched.
  The Documentation History tables are kept to a rolling window: each time a new
  version row is added, the **oldest** version row is dropped (from both the
  root `README.md` and the new folder's `README.md`), so the table doesn't grow
  without bound. Older versions remain available via the folders and
  `Version-History.md`.

Skip the prompt with flags:

```bash
python3 scripts/update_sdk_docs.py --update-current      # option 1
python3 scripts/update_sdk_docs.py --new-version         # option 2, auto-bump patch
python3 scripts/update_sdk_docs.py --new-version v1.0.40  # option 2, explicit version
python3 scripts/update_sdk_docs.py --yes                 # non-interactive, keep defaults (option 1)
```

## Requirements

- Python 3.9+
- A working `git` CLI with network access to github.com

## Usage

```bash
# Preview what would change (recommended first step)
python3 scripts/update_sdk_docs.py --dry-run

# Run interactively (prompts: update current vs. create a new version)
python3 scripts/update_sdk_docs.py

# Target a specific docs folder
python3 scripts/update_sdk_docs.py --docs-version v1.0.35

# Only check specific modules
python3 scripts/update_sdk_docs.py --only MapplsMap MapplsAPIKit

# Customise the date / release note stamped on new rows
python3 scripts/update_sdk_docs.py --date "07 Oct 2026" --note "- Added new features."
```

## Where the documentation comes from

Each module doc points at a distribution repo under
[github.com/MapmyIndia](https://github.com/MapmyIndia) or
[github.com/mappls-api](https://github.com/mappls-api) (e.g.
`mappls-api-kit-distribution`). Those repos host the authoritative module
README — the complete documentation with the real Version History, API
reference, and code samples. When a newer version is found, the script fetches
that repo's README (trying the version tag, then the default branch, and the
`README.md` / `Readme.md` casings) and **replaces the whole local module doc
with it**.

```bash
# Default: copy the full documentation from the distribution repos
python3 scripts/update_sdk_docs.py

# Only add a version-history row, don't replace the whole doc
python3 scripts/update_sdk_docs.py --row-only

# Skip all network fetches; stamp --date / --note instead
python3 scripts/update_sdk_docs.py --no-fetch --note "- Bug fixes."
```

Note: because the full README is copied, a module doc may legitimately start
pointing at a newer distribution channel (the repo's README can reference its
own successor repo). In that case a follow-up run converges on the newest
version — run the script again until it reports everything up to date.

## Notes

- Only modules that expose an SPM distribution URL in their doc are updated.
  Modules not yet on SPM (e.g. some plugins) are skipped automatically.
- When a distribution repo has no README (ships only `Package.swift`), the
  script falls back to adding a single version-history row with a generic note
  (`- Improvements and Bug Fixes.`). Pass `--note` to customise it.
- Full-doc replacement overwrites the local module doc entirely. The source
  `docs/vX.Y.Z` folder you create a new version from is never modified; only
  the target (current or new) folder is written.
- Only the current docs-version row of the README tables is edited; historical
  rows are left untouched.

---

# Release tagging: `release_from_changelog.py`

Builds a release note from a docs version's `CHANGELOG/` folder and creates a
git tag for that release (optionally pushing it and publishing a GitHub
release).

## How it works

1. Resolves the docs version to release (newest `docs/vX.Y.Z` by default, or
   `--version vX.Y.Z`).
2. Reads every `docs/vX.Y.Z/CHANGELOG/*.md` and extracts each module's latest
   entry (the first `## <ver> - <date>` block with its `### Added/Fixed/Changed`
   details).
3. Aggregates them into a single release note: a module→version summary plus a
   per-module changelog section.
4. Writes the note to `docs/vX.Y.Z/RELEASE_NOTES.md` (override with `--out`).
5. Creates an annotated git tag (name defaults to the bare version, e.g.
   `1.0.36`, matching the repo's existing tags) whose message is the note.
6. Optionally `--push` the tag and/or create a GitHub release with `--gh-release`
   (uses the `gh` CLI).

## Requirements

- Python 3.9+
- `git` CLI
- `gh` CLI (only for `--gh-release`)

## Usage

```bash
# Preview the note + exact git/gh commands, change nothing
python3 scripts/release_from_changelog.py --dry-run

# Create the annotated tag locally (newest docs version)
python3 scripts/release_from_changelog.py

# A specific version, pushed to origin
python3 scripts/release_from_changelog.py --version v1.0.36 --push

# Create the tag and a GitHub release, and push
python3 scripts/release_from_changelog.py --gh-release --push

# Custom tag name
python3 scripts/release_from_changelog.py --tag v1.0.36
```

## Notes

- The tag is created with `git tag --cleanup=verbatim` so the markdown note
  (including `#` headings) is preserved verbatim in the tag message.
- If the working tree has uncommitted changes, the script stops with a warning
  (the tag would point at HEAD, not your uncommitted work). Commit first, or
  pass `--allow-dirty` to proceed anyway.
- The script refuses to overwrite an existing tag; delete it or choose another
  name with `--tag`.
- `--push` and `--gh-release` reach the network and publish — run `--dry-run`
  first to review.

---

# Full release: `create_release.py`

Orchestrates the whole release end to end: build the note, commit the docs,
tag, push, and publish a GitHub release.

## Steps it runs

1. Resolve the version (newest `docs/vX.Y.Z` or `--version`).
2. Build the release note and write `docs/vX.Y.Z/RELEASE_NOTES.md`
   (reuses `release_from_changelog.py`).
3. `git add` the version's docs (+ `README.md`, `Version-History.md`) and commit.
4. Create the annotated tag (`--cleanup=verbatim`, so markdown headings survive).
5. Push the branch and the tag to the remote.
6. Create a GitHub release with `gh`, using the note as the body.

## Safety

**Dry-run by default.** Pushing and publishing are hard to reverse and affect a
shared remote, so the script only *prints* the git/gh commands unless you pass
`--confirm`. It also pre-checks that the tag doesn't already exist (locally or
on the remote) and that `gh` is available.

## Requirements

- Python 3.9+, `git` CLI
- `gh` CLI authenticated with push access (unless `--no-gh-release`)

## Usage

```bash
# Preview everything, change nothing (recommended first)
python3 scripts/create_release.py

# Do it for real: commit, tag, push, GitHub release
python3 scripts/create_release.py --confirm

# A specific version
python3 scripts/create_release.py --version v1.0.36 --confirm

# Commit and tag locally only, no push / no release
python3 scripts/create_release.py --confirm --local --no-gh-release

# Tag an already-committed HEAD (don't make a new commit)
python3 scripts/create_release.py --confirm --no-commit

# Push the tag but skip the GitHub release
python3 scripts/create_release.py --confirm --no-gh-release
```

## Flags

- `--version` — docs version to release (default: newest).
- `--tag` — tag name (default: bare version, e.g. `1.0.36`).
- `--title` — GitHub release name (default: `Mappls iOS SDK <version>`; the CI
  pipeline passes `<doc version> auth-legacy`, e.g. `v1.0.36 auth-legacy`).
- `--branch` / `--remote` — target branch / remote (defaults: current branch, `origin`).
- `--message` — commit message (default: `docs: release <tag>`).
- `--confirm` — actually execute (otherwise dry-run).
- `--local` — commit + tag, no push.
- `--no-commit` — tag HEAD as-is, no new commit.
- `--no-gh-release` — skip the GitHub release.
- `--release-only` — don't commit, tag, or push; only (re)publish the GitHub
  release for an existing tag, rebuilding its notes from the changed SDKs'
  changelogs. (Creates the release if missing, edits it if it already exists.)

---


# CI pipeline: `.github/workflows/release-docs.yml`

A GitHub Actions workflow that runs the scripts above as three jobs, one after
another. Each job only starts if the previous one succeeded.

| Job | What it does |
|---|---|
| **1. Update documents** | `update_sdk_docs.py --skip-changelogs`: refreshes module docs and the Documentation History tables, then commits and pushes. |
| **2. Update changelogs** | `update_sdk_docs.py --changelogs-only`: copies each distribution repo's `CHANGELOG.md` verbatim into `CHANGELOG/<Module>.md` in the newest docs folder (repos without one are skipped), then commits and pushes. |
| **3. Create tag + release** | `create_release.py`: builds `RELEASE_NOTES.md` from the changed SDKs' changelogs, then **always publishes a GitHub release**. If the tag is new it also creates and pushes the tag (e.g. `1.0.36`); if the tag already exists it skips tagging and just (re)publishes the release for it (`--release-only`). |

Each job checks out the latest `auth-legacy`, so it sees the previous job's commit.

The release name is `<doc version> auth-legacy` (e.g. `v1.0.36 auth-legacy`),
and its body lists only the SDKs that changed since the previous doc version,
with their changelog entries.

## Triggers

Manual only, and only on the **`auth-legacy`** branch: pushes and schedules
don't start it. Run it from Actions → "Release SDK Docs" → **Run workflow** and
pick `auth-legacy` under "Use workflow from". Started from any other branch,
all three jobs are skipped. Commits, tags, and releases go to `auth-legacy`
only. Inputs:
  - **mode**:
    - `auto` (default): if any SDK has a newer SPM release than the current
      docs, create a new `docs/vX.Y.Z` folder (patch bump, e.g. `v1.0.35` →
      `v1.0.36`). Otherwise refresh the current folder in place.
    - `update-current`: always refresh the current folder in place.
    - `new-version`: always create a new folder.
  - **new_version**: explicit version for `new-version`, e.g. `v1.0.37`;
    blank = auto-bump the patch.
  - **dry_run**: preview only (default **false**, so a run commits, tags, and
    pushes for real; tick it to preview).

The tag name comes from the newest docs folder (e.g. `1.0.36`). A new folder
gets a new tag plus a fresh release. When nothing new has shipped, no folder is
created, so job 3 keeps the existing tag and refreshes that version's release
from the latest changelogs.

Locally, the same behaviour is `python3 scripts/update_sdk_docs.py --auto`.
