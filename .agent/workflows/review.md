---
description: Run pre-commit code review checks on staged changes.
---

# Workflow: Code Review

Run these checks before committing any changes. This is the quality gate.

## Scope

- Review only the current staged or modified changes.
- Use `git diff` or `git diff --cached` as the source of truth.

## Checks

### 1. Static Analysis

// turbo

```bash
dart analyze
```

**BLOCK** if any issues are reported.

### 2. Formatting

// turbo

```bash
dart format --set-exit-if-changed .
```

**BLOCK** if any files need formatting.

### 3. Tests

// turbo

```bash
flutter test
```

**BLOCK** if any tests fail.

### 4. Code Review Checklist

Review the diff against these criteria:

#### Dart/Flutter Quality

- [ ] Follows null safety best practices (no unnecessary `!`)
- [ ] Uses `const` constructors where possible
- [ ] No expensive operations in `build()` methods
- [ ] Async code has proper error handling
- [ ] No `print()` statements (use `dart:developer` logging)

#### Package API

- [ ] New public APIs have `///` dartdoc comments
- [ ] No accidental public API changes
- [ ] New parameters have default values (backward compatible)
- [ ] No internal types exposed in public API

#### Testing

- [ ] New features have corresponding tests
- [ ] Bug fixes have regression tests
- [ ] Tests follow Arrange-Act-Assert pattern

#### Documentation

- [ ] CHANGELOG.md updated for user-visible changes
- [ ] README.md updated if needed
- [ ] Example app updated if API changed

#### General

- [ ] No hardcoded values that should be configurable
- [ ] No unused imports or dead code
- [ ] Import ordering follows convention
- [ ] File names follow `snake_case` convention

## Verdicts

- **APPROVE**: All checks pass, code quality is good.
- **BLOCK**: Issues found that must be fixed before committing.

## Output

```
VERDICT: APPROVE | BLOCK

CHECKS:
  Analysis:  ✅ | ❌
  Formatting: ✅ | ❌
  Tests:      ✅ | ❌
  Review:     ✅ | ❌

FINDINGS:
- [Category] Description of finding...

REQUIRED_FIXES (if BLOCK):
- Specific fix needed...
```
