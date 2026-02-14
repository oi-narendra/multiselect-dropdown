---
description: Refactor code in the Flutter package without changing behavior.
---

# Workflow: Refactor

Follow this workflow when restructuring code without changing its external
behavior.

## Phase 1: Plan

1. **Identify the motivation**
   - Why refactor? (readability, performance, maintainability, testability)
   - What specifically needs improvement?

2. **Scope the refactor**
   - List all files and classes affected.
   - Identify any public API changes (these turn the refactor into a
     feature/breaking change — proceed with caution).
   - If the refactor touches public API, it MUST follow the deprecation
     rules in `.agent/rules/package-dev.md`.

3. **Ensure baseline coverage**
   - Run existing tests to establish a green baseline.

   // turbo

   ```bash
   flutter test
   ```

   - If coverage is insufficient for the area being refactored, write
     characterization tests FIRST to pin existing behavior.

## Phase 2: Execute

1. **Make incremental changes**
   - Refactor in small, verifiable steps.
   - After EACH step:

   // turbo

   ```bash
   flutter test
   ```

   - If tests fail, revert the last step and try a different approach.

2. **Maintain behavior**
   - The refactor must NOT change any observable behavior.
   - No new features, no bug fixes — those are separate workflows.

## Phase 3: Verify

// turbo

```bash
dart format .
```

// turbo

```bash
dart analyze
```

// turbo

```bash
flutter test
```

All must pass with zero issues and no behavioral changes.

## Phase 4: Document

1. **Update CHANGELOG.md** (only if significant restructuring)

   ```markdown
   ### Changed

   - Refactored internal dropdown rendering for maintainability
   ```

2. **Update inline comments** if code structure changed significantly.

## Output

Summarize:

- What was refactored and why
- Files modified
- Confirmation that all tests still pass
- Any public API impact (ideally none)
