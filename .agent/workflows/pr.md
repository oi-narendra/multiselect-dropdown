---
description: Create a Pull Request for the current branch.
---

# Workflow: Create Pull Request

## Pre-PR Checks

1. **Run the review workflow first**

   Follow all steps in `/review` to ensure quality gates pass.

2. **Ensure branch is up to date**

   // turbo

   ```bash
   git fetch origin main
   ```

   ```bash
   git rebase origin/main
   ```

   Resolve any conflicts if they arise.

## Create the PR

1. **Determine PR metadata**

   From the branch name and commits, determine:
   - **Title**: `<type>(<scope>): <description>` (conventional commit style)
   - **Issue link**: Extract from commit footers (`Fixes #N`)
   - **Type of change**: Bug fix / Feature / Breaking / Docs / Refactor

2. **Open PR**

   ```bash
   gh pr create --title "<title>" --body-file .github/PULL_REQUEST_TEMPLATE.md --web
   ```

   Or if you want to fill it programmatically:

   ```bash
   gh pr create \
     --title "<type>(<scope>): <description>" \
     --body "## Description

   <summary of changes>

   ## Related Issue

   Fixes #<issue_number>

   ## Type of Change

   - [x] <type>

   ## Checklist

   - [x] dart analyze passes
   - [x] dart format clean
   - [x] flutter test passes
   - [x] CHANGELOG.md updated
   - [x] dartdoc added for new public APIs"
   ```

3. **Add labels**

   ```bash
   gh pr edit <PR_NUMBER> --add-label "<label>"
   ```

   Common labels: `bug`, `enhancement`, `breaking-change`, `documentation`

## Post-PR

- Share the PR link with the user.
- If CI is configured, monitor the checks.

## Output

Summarize:

- PR number and URL
- What the PR contains
- Which issue(s) it addresses
