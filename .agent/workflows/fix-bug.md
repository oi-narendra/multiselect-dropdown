---
description: Fix a bug in the Flutter package.
---

# Workflow: Fix Bug

Follow this workflow when fixing a reported bug.

## Phase 1: Reproduce

1. **Understand the bug report**
   - What is the expected behavior?
   - What is the actual behavior?
   - What are the reproduction steps?
   - Which version is affected?

2. **Reproduce the bug**
   - Try to reproduce in the `example/` app or a widget test.
   - If you can't reproduce, ask for more details.

3. **Root cause analysis**
   - Trace through the code to identify exactly where the bug occurs.
   - Understand WHY it happens, not just WHERE.

## Phase 2: Fix

1. **Write a failing test first**
   - Create a test that captures the exact bug behavior.
   - Verify the test fails before applying the fix.

   // turbo

   ```bash
   flutter test
   ```

2. **Apply the minimal fix**
   - Fix the root cause, not symptoms.
   - Make the smallest change possible.
   - Avoid unrelated refactors in the same change.

3. **Verify the fix**

   // turbo

   ```bash
   flutter test
   ```

   The previously failing test must now pass, and no existing tests should
   break.

## Phase 3: Validate

1. **Check for regressions**

   // turbo

   ```bash
   dart analyze
   ```

   // turbo

   ```bash
   flutter test
   ```

2. **Verify in example app**
   - If the bug was UI-visible, verify the fix in `example/`.

## Phase 4: Document

1. **Update CHANGELOG.md**

   ```markdown
   ### Fixed

   - Description of what was fixed (#issue_number if applicable)
   ```

2. **Add inline comments** if the bug had a non-obvious cause that future
   developers should understand.

## Output

Summarize:

- Root cause of the bug
- The fix applied
- Regression test added
- Files modified
- CHANGELOG entry added
