---
description: Implement a new feature in the Flutter package.
---

# Workflow: Implement Feature

Follow this phased workflow when implementing a new feature.

## Phase 1: Understand & Design

1. **Clarify requirements**
   - If the requirement is ambiguous, ask clarifying questions.
   - Identify which widgets, models, or utilities are affected.
   - Determine if this impacts the public API surface.

2. **Check existing patterns**
   - Review how similar features are already implemented in the codebase.
   - Follow established patterns — don't invent new conventions.

3. **API impact assessment**
   - Does this add new public classes, methods, or parameters?
   - Does this change or deprecate existing API?
   - If breaking changes: require a MAJOR version bump plan.
   - New parameters must have sensible defaults to preserve backward
     compatibility.

4. **Plan the file changes**
   - List all files that need to be created or modified.
   - Identify any new dependencies needed (prefer none for a package).

## Phase 2: Implement

1. **Write the code**
   - Follow all rules in `.agent/rules/flutter.md` and
     `.agent/rules/code-quality.md`.
   - Make minimal, surgical changes — avoid unrelated refactors.
   - Add `///` dartdoc comments to all new public APIs.
   - Use `const` constructors wherever possible.

2. **Update the example app**
   - If the feature is user-visible, add or update the example in
     `example/lib/main.dart` to demonstrate it.

3. **Incremental verification** (after EVERY file change)

   // turbo

   ```bash
   dart analyze
   ```

   // turbo

   ```bash
   flutter test
   ```

   If either fails, fix immediately before proceeding.

## Phase 3: Test

1. **Write tests**
   - Unit tests for any new logic (models, controllers, utilities).
   - Widget tests for any new or changed widgets.
   - Follow Arrange-Act-Assert pattern.
   - Cover: happy path, edge cases, error conditions.

2. **Run full test suite**

   // turbo

   ```bash
   flutter test
   ```

## Phase 4: Document

1. **Code documentation**
   - [ ] All new public APIs have `///` dartdoc comments
   - [ ] Complex logic has inline comments explaining _why_
   - [ ] Examples in dartdoc where helpful

2. **Update CHANGELOG.md**
   - Add entry under `## [Unreleased]` with appropriate category
     (`Added`, `Changed`, `Fixed`, etc.)

3. **Update README.md** (if feature is significant)
   - Add usage examples
   - Update feature list

## Phase 5: Final Check

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

All three must pass with zero issues.

## Output

Summarize:

- What was implemented
- Files created/modified
- Tests added
- Any API surface changes
- CHANGELOG entry added
