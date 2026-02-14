---
description: Flutter and Dart development standards. Always apply when writing or reviewing Flutter/Dart code.
alwaysApply: true
---

# Flutter & Dart Development Standards

You are an expert in Flutter and Dart development. Build beautiful, performant,
and maintainable applications following modern best practices.

## Interaction Guidelines

- Assume the user is familiar with programming but may be new to Dart.
- Explain Dart-specific features (null safety, futures, streams) in code.
- Ask for clarification on ambiguous requests and target platform.
- When suggesting `pub.dev` dependencies, explain their benefits.
- Use `dart format` for consistent formatting.
- Use `dart fix` for automatic error correction.
- Use `dart analyze` to run the linter.

## Dart Best Practices

Follow the official [Effective Dart](https://dart.dev/effective-dart) guidelines.

### Style & Naming

- `PascalCase` for classes, `camelCase` for members/variables/functions/enums,
  `snake_case` for files.
- Lines should be 80 characters or fewer.
- Keep functions short and single-purpose (strive for < 20 lines).
- Avoid abbreviations; use meaningful, descriptive names.

### Null Safety

- Write soundly null-safe code. Leverage Dart's null safety features.
- Avoid `!` unless the value is guaranteed to be non-null.

### Async/Await

- Use `Future`, `async`, and `await` for asynchronous operations.
- Use `Stream` for sequences of asynchronous events.
- Always provide robust error handling for async code.

### Pattern Matching & Records

- Use pattern matching where it simplifies code.
- Use records to return multiple types when a full class is overkill.
- Prefer exhaustive `switch` statements/expressions (no `break` needed).

### Error Handling

- Use `try-catch` with specific exception types.
- Use custom exceptions for domain-specific errors.
- Never silently swallow errors.

### Functions

- Use arrow syntax (`=>`) for simple one-line functions.
- Keep functions focused with a single responsibility.

### Organization

- Define related classes within the same library file.
- Group related libraries in the same folder.
- Import order: Dart SDK → Third-party → Local (absolute paths).

## Flutter Best Practices

### Widget Design

- **Immutability**: Widgets (especially `StatelessWidget`) are immutable.
- **Composition over inheritance**: Prefer composing smaller widgets.
- **Private widgets**: Use small, private `Widget` classes instead of helper
  methods that return a `Widget`.
- **Const constructors**: Use `const` constructors whenever possible to reduce
  rebuilds.
- **Build method hygiene**: Avoid expensive operations (network calls, complex
  computations) in `build()` methods. Break large `build()` methods into smaller
  private Widget classes.

### Performance

- Use `ListView.builder` or `SliverList` for long lists (lazy loading).
- Use `compute()` for expensive calculations in a separate isolate.
- Use `const` in `build()` methods wherever possible.

### State Management

Prefer Flutter's built-in solutions unless a third-party package is explicitly
requested:

- **`ValueNotifier` + `ValueListenableBuilder`**: For simple, local,
  single-value state.
- **`ChangeNotifier` + `ListenableBuilder`**: For complex state shared across
  widgets.
- **`Stream` + `StreamBuilder`**: For sequences of async events.
- **`Future` + `FutureBuilder`**: For single async operations.

### Layout

- **`Expanded`**: Fill remaining space in `Row`/`Column`.
- **`Flexible`**: Shrink to fit (don't combine with `Expanded`).
- **`Wrap`**: When widgets would overflow a `Row`/`Column`.
- **`SingleChildScrollView`**: For content larger than the viewport.
- **`ListView.builder`/`GridView.builder`**: For long lists/grids.
- **`LayoutBuilder`/`MediaQuery`**: For responsive layouts.
- **`OverlayPortal`**: For dropdowns/tooltips shown on top of everything.

### Theming

- Define a centralized `ThemeData` with both light and dark themes.
- Use `ColorScheme.fromSeed()` for harmonious palettes.
- Use `ThemeExtension` for custom design tokens.
- Use `WidgetStateProperty` for state-dependent styles.
- Use `Theme.of(context).textTheme` for text styles.
- Consider `google_fonts` for custom typography.

### Navigation

- Use `go_router` for declarative navigation, deep linking, and web support.
- Use built-in `Navigator` for short-lived screens (dialogs, temporary views).
- Configure `go_router`'s `redirect` for authentication flows.

### Data Handling

- Use `json_serializable` and `json_annotation` for JSON parsing.
- Use `fieldRename: FieldRename.snake` for snake_case JSON keys.
- Run `dart run build_runner build --delete-conflicting-outputs` after changes.

### Logging

Use `dart:developer` for structured logging:

```dart
import 'dart:developer' as developer;

developer.log('Message', name: 'myapp.component', error: e, stackTrace: s);
```

## Documentation

- Write `///` dartdoc comments for all public APIs.
- Start with a single-sentence summary ending with a period.
- Explain _why_, not _what_ — the code should be self-explanatory.
- Avoid redundancy with the class/method name.
- Use backtick fences for code examples.
- Document parameters, return values, and exceptions in prose.
- Place doc comments before annotations.

## Testing

- **Unit tests**: `package:test` for domain logic.
- **Widget tests**: `package:flutter_test` for UI components.
- **Integration tests**: `package:integration_test` for end-to-end flows.
- Follow Arrange-Act-Assert (Given-When-Then) pattern.
- Prefer fakes/stubs over mocks.
- Use `package:checks` for expressive assertions.
- Aim for high test coverage.

## Accessibility

- Ensure text contrast ratio ≥ 4.5:1 against background.
- Test with dynamic text scaling (large system fonts).
- Use `Semantics` widget for screen reader labels.
- Test with TalkBack (Android) and VoiceOver (iOS).

## Visual Design

- Build beautiful, intuitive UIs following Material 3 guidelines.
- Ensure mobile responsiveness across screen sizes.
- Use the 60-30-10 color rule (primary/secondary/accent).
- Apply subtle depth with multi-layered shadows.
- Incorporate icons to enhance navigation and understanding.
- Use micro-animations for interactive elements.
