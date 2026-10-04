# Release Flow

## Overview

This project uses an automated release flow driven by [release-please](https://github.com/googleapis/release-please)
and Conventional Commits. There is no manual tagging.

The pipeline is:

```
Conventional Commits merged to main
   |
   v
release-please keeps a Release PR up to date (version bump + CHANGELOG)
   |
   v  (the Release PR is merged: see "How the Release PR is merged" below)
release-please creates the tag and the GitHub Release
   |
   v
the publish job builds the gem and pushes it to RubyGems (Trusted Publishing)
```

## How the Release PR is merged

Patch releases ship automatically; larger releases need a human.

- Patch bump (`x.y.Z`): the `auto-merge-patch` job runs weekly (Mondays 00:00 UTC
  / 09:00 JST) and merges the open Release PR automatically when it is a patch-only
  bump. This ships accumulated `fix:` / `fix(deps):` changes without manual action.
  You can also trigger it on demand from the Actions tab (Run workflow).
- Minor bump (`x.Y.0`, from `feat:`) or major bump: the Release PR is left open for
  a human to review and merge, since these are larger changes.

## Conventional Commits

release-please derives the next version from commit messages, so the prefix matters:

| Prefix | Effect on version (while in 0.x) |
|--------|----------------------------------|
| `feat:` | MINOR bump (new feature); shown in release notes |
| `fix:` | PATCH bump (bug fix); shown in release notes |
| `fix(deps):` | PATCH bump (dependency update, used by Renovate); shown in release notes |
| `perf:` | PATCH bump (performance improvement); shown in release notes |
| `feat!:` / `BREAKING CHANGE:` | MINOR bump (breaking changes stay MINOR until 1.0.0) |
| `docs:`, `refactor:`, `chore:` | No version bump; hidden from release notes |

Note on how release-please decides the bump: internally, only `feat` and
breaking changes map to MINOR/MAJOR; every other releasable type maps to PATCH.
To keep `docs:` / `refactor:` / `chore:` from cutting a pointless release, they
are marked hidden in `release-please-config.json`, which also removes them from
the release notes. There is no release-please setting that both shows a type in
the notes and skips the version bump; that is why these types are hidden entirely.

If nothing since the last release bumps the version, no Release PR is created,
so weeks with only `docs:` / `refactor:` / `chore:` changes produce no release.

## Releasing

### 1. Merge feature/fix PRs to main as usual

Each PR should use a Conventional Commit title. When such commits land on `main`,
the `Release Please` workflow opens or updates a single Release PR titled
`chore(main): release x.y.z`.

### 2. The Release PR is merged

- Patch-only Release PRs are merged automatically on the weekly schedule (see
  "How the Release PR is merged" above). No action is needed.
- Minor/major Release PRs wait for a human. Open the PR, check the proposed
  version and the generated `CHANGELOG.md` entry, then merge when ready.

### 3. Merging the Release PR triggers the release

Whichever way it is merged, it:

1. Updates `CHANGELOG.md`, `lib/cronv_rb/version.rb`, and
   `.release-please-manifest.json` on `main`
2. Creates the git tag (e.g. `v0.1.1`)
3. Creates the GitHub Release with the changelog as its body

### 4. The gem is published automatically

The `publish` job in the same workflow runs only when a release was created. It
builds the gem and pushes it to [RubyGems](https://rubygems.org/gems/cronv-rb)
using Trusted Publishing (OIDC), so no API key is stored in the repository.

### 5. Verify the release

- Check the [Releases page](https://github.com/M-Yamashita01/cronv-rb/releases)
- Confirm the new version is live on [RubyGems](https://rubygems.org/gems/cronv-rb)
- Confirm the changelog reads correctly

## Release Infrastructure

| File | Purpose |
|------|---------|
| `.github/workflows/release-please.yml` | Maintains the Release PR on push to `main`; auto-merges patch-only Release PRs weekly; publishes the gem when a release is created |
| `release-please-config.json` | release-please settings (release type, version bump rules, changelog sections) |
| `.release-please-manifest.json` | Tracks the current released version |
| `lib/cronv_rb/version.rb` | The `CronvRb::VERSION` constant; the source of truth for the version, updated by release-please |

## RubyGems Trusted Publishing

Publishing uses RubyGems Trusted Publishing (OIDC) instead of a stored API key.
A one-time setup is required on RubyGems.org (Profile > Trusted Publishers):

- Repository: `M-Yamashita01/cronv-rb`
- Workflow filename: `release-please.yml`
- Gem name: `cronv-rb`

Because the gem is not yet registered, create it as a pending trusted publisher
so the first OIDC push both creates the gem and registers ownership.

## Renovate

Renovate is configured to use `fix(deps):` commit messages (see `renovate.json`),
so dependency updates become PATCH-level entries in the Release PR. This lets a
weekly dependency refresh ship as a single patch release when the Release PR is
merged.

## Fixing a Bad Release

Prefer rolling forward: fix the issue on `main` and let the next Release PR ship a
new patch version (e.g. `v0.1.2`).

If a release must be pulled:

1. Delete the release from the GitHub Releases page
2. Delete the tag: `git push origin :refs/tags/v0.1.1`
3. Yank the gem from RubyGems if it was published: `gem yank cronv-rb -v 0.1.1`
4. Fix the issue on `main` and ship a new patch via the normal flow
