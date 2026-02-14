---
description: Code quality enforcement — linting, formatting, and static analysis standards.
alwaysApply: true
---

# Code Quality Standards

## Analysis & Linting

This project uses [`very_good_analysis`](https://pub.dev/packages/very_good_analysis)
for strict lint rules. The `analysis_options.yaml` at the project root is the
source of truth.

### Before Every Change

// turbo

```bash
# Format all Dart files
dart format .
```

// turbo

```bash
# Run static analysis
dart analyze
```

// turbo

```bash
# Auto-fix common issues
dart fix --apply
```

### Zero-Warning Policy

- `dart analyze` must report **zero** issues (errors, warnings, or infos).
- If the analyzer flags something, fix it — do not suppress with
  `// ignore:` unless there is a documented, justified reason.
- If a lint rule is genuinely inappropriate for a specific case, disable it
  at the narrowest scope possible with a comment explaining why.

## Formatting

- Use `dart format` with default settings (no custom line length).
- Format before every commit — never commit unformatted code.
- Exception: the project allows `lines_longer_than_80_chars: false` as
  configured in `analysis_options.yaml`.

## Import Ordering

Follow this order, separated by blank lines:

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:math';

// 2. Flutter SDK
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Third-party packages
import 'package:some_package/some_package.dart';

// 4. Local package imports
import 'package:multi_dropdown/src/models/dropdown_item.dart';

// 5. Relative imports (within same feature)
import 'dropdown_controller.dart';
```

## File Organization

- One primary public class per file.
- File name matches the primary class: `multi_dropdown.dart` →
  `MultiDropdown`.
- Group related private helpers in the same file as the public class.
- Keep files focused — if a file exceeds ~300 lines, consider splitting.

## Naming Conventions

| Element     | Convention         | Example                    |
| ----------- | ------------------ | -------------------------- |
| Classes     | `PascalCase`       | `DropdownController`       |
| Files       | `snake_case`       | `dropdown_controller.dart` |
| Variables   | `camelCase`        | `selectedItems`            |
| Constants   | `camelCase`        | `defaultPadding`           |
| Enums       | `camelCase` values | `WrapBehavior.wrap`        |
| Private     | `_` prefix         | `_internalState`           |
| Type params | Single uppercase   | `DropdownItem<T>`          |

## Code Complexity

- Functions should have a single responsibility.
- Avoid deep nesting (> 3 levels) — extract to helper functions or widgets.
- Prefer early returns to reduce indentation.
- Maximum cyclomatic complexity target: 10 per function.

## Testing Requirements

// turbo

```bash
# Run all tests
flutter test
```

- Every bug fix must include a regression test.
- Every new public API must include at least one unit/widget test.
- Tests must pass before any commit.
