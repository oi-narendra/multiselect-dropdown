---
description: Pick a GitHub issue to work on and start implementation.
---

# Workflow: Pick Issue

Work on a GitHub issue from the repository.

## Step 1: List Open Issues

// turbo

```bash
gh issue list --state open --limit 20
```

If the user specifies a label filter:

```bash
gh issue list --state open --label "bug" --limit 20
```

Present the issues to the user and let them pick one.

## Step 2: Read the Issue

```bash
gh issue view <ISSUE_NUMBER>
```

Understand:

- **What** is being requested or reported?
- **Is it a bug, feature, or something else?**
- Is there enough information to proceed?

If the issue is unclear, ask the user for clarification or comment on the
issue asking the reporter for more details.

## Step 3: Create a Branch

```bash
git checkout -b <type>/<issue-number>-<short-description>
```

Branch naming convention:
| Type | Prefix | Example |
|------|--------|---------|
| Bug fix | `fix/` | `fix/42-dropdown-not-closing` |
| Feature | `feat/` | `feat/55-search-callback` |
| Refactor | `refactor/` | `refactor/60-extract-overlay` |
| Docs | `docs/` | `docs/38-update-readme` |

## Step 4: Implement

Delegate to the appropriate workflow:

- **Bug**: Follow `/fix-bug` workflow
- **Feature**: Follow `/implement` workflow
- **Refactor**: Follow `/refactor` workflow
- **Docs**: Make documentation changes directly

## Step 5: Link the Issue

When committing, reference the issue:

```
fix(dropdown): close on outside tap

Fixes #42
```

The `Fixes #N` / `Closes #N` footer will auto-close the issue when merged.

## Output

Summarize:

- Issue number and title
- Branch created
- Changes made
- Whether the issue can be closed
