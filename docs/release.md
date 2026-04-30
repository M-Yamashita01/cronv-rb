# Release Flow

cronv-rb uses [tagpr](https://github.com/Songmu/tagpr) for automated release management.

## How it works

1. Merge feature/fix PRs into `main` as usual
2. tagpr automatically creates (or updates) a **release PR** that bundles all unreleased changes
3. Review the release PR — adjust the version in `lib/cronv_rb/version.rb` if needed
4. Merge the release PR
5. tagpr automatically tags the merge commit and creates a GitHub Release

```
feature PR ──merge──> main ──push──> tagpr creates release PR
                                            │
                                      merge release PR
                                            │
                                      tagpr tags + GitHub Release created
```

## Version bumping

tagpr determines the next version based on labels:

| Label on release PR | Version bump | Example |
|---|---|---|
| (none) | patch | v0.1.0 → v0.1.1 |
| `tagpr:minor` | minor | v0.1.0 → v0.2.0 |
| `tagpr:major` | major | v0.1.0 → v1.0.0 |

Labels on merged PRs (`minor`, `major`) are also propagated to the release PR automatically.

tagpr keeps `lib/cronv_rb/version.rb` in sync with the git tag.

## Configuration

tagpr is configured via `.tagpr` (gitconfig format) in the repository root. See `.tagpr` for the current settings.

## Prerequisites

To enable tagpr, the following repository setting is required:

**Settings > Actions > General > Workflow permissions**
- Check "Allow GitHub Actions to create and approve pull requests"
