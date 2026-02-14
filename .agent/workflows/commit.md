---
description: Commit changes using conventional commit format.
---

# Workflow: Commit Changes

## Steps

1. **Review staged changes**

   ```bash
   git diff --staged
   ```

2. **Generate a conventional commit message**

   Format: `<type>(<scope>): <subject>`

   ### Types

   | Type       | When to use                               |
   | ---------- | ----------------------------------------- |
   | `feat`     | New feature or public API addition        |
   | `fix`      | Bug fix                                   |
   | `docs`     | Documentation only changes                |
   | `style`    | Formatting, no code change                |
   | `refactor` | No feature or fix, internal restructuring |
   | `perf`     | Performance improvement                   |
   | `test`     | Adding or updating tests                  |
   | `chore`    | Build, CI, or tooling changes             |

   ### Scopes (for this package)

   | Scope        | What it covers                   |
   | ------------ | -------------------------------- |
   | `dropdown`   | Core MultiDropdown widget        |
   | `controller` | DropdownController logic         |
   | `models`     | Data models (DropdownItem, etc.) |
   | `search`     | Search/filter functionality      |
   | `style`      | Decoration, theming, styling     |
   | `example`    | Example app changes              |
   | `docs`       | README, CHANGELOG, dartdoc       |
   | `ci`         | GitHub Actions, CI/CD            |

   ### Rules
   - Use present tense imperative: "add feature" not "added feature".
   - Subject line ≤ 72 characters.
   - No period at the end of the subject line.
   - Include body for complex changes (separated by blank line).

3. **Commit**

   ```bash
   git add -A
   git commit -m "<type>(<scope>): <subject>"
   ```

   Examples:
   - `feat(dropdown): add onSearchChanged callback`
   - `fix(controller): prevent duplicate selections`
   - `docs(readme): update installation instructions`
   - `refactor(dropdown): extract overlay into private widget`
   - `test(controller): add tests for clear method`

4. **Breaking changes**

   For breaking changes, add `!` after the scope and include a
   `BREAKING CHANGE:` footer:

   ```
   feat(dropdown)!: rename selectedItems to selections

   BREAKING CHANGE: `selectedItems` property has been renamed to
   `selections` for clarity.
   ```
