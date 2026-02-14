---
description: Rules for Flutter package development on pub.dev. Apply when working on package APIs, versioning, or publishing.
---

# Package Development Rules

These rules apply specifically to Flutter/Dart **package** development (libraries
published to pub.dev), as opposed to app development.

## API Design Principles

- **User-first**: Design APIs from the consumer's perspective. The API should
  be intuitive and hard to misuse.
- **Minimal surface area**: Only expose what users need. Keep implementation
  details private with `_` prefix or `src/` directory.
- **Documentation is mandatory**: Every public class, method, constructor, and
  top-level function must have `///` dartdoc comments with examples.
- **Consistency**: Follow naming patterns established in the existing API. New
  additions should feel natural alongside existing ones.

## Public API Structure

```
lib/
├── multi_dropdown.dart          # Public barrel file (only exports)
└── src/                         # Private implementation
    ├── models/                  # Data classes, enums
    ├── widgets/                 # Widget implementations
    └── utils/                   # Internal helpers
```

- **Barrel file**: `lib/multi_dropdown.dart` should only contain `export`
  statements. Never put implementation code here.
- **src/ is private**: Nothing in `lib/src/` should be imported directly by
  consumers. Everything flows through the barrel file.
- **Hide internals**: Use `show`/`hide` in exports to control the public API
  surface precisely.

## Versioning (Semantic Versioning)

Follow [pub.dev versioning](https://dart.dev/tools/pub/versioning):

- **MAJOR** (x.0.0): Breaking changes to the public API
- **MINOR** (0.x.0): New features, backward-compatible
- **PATCH** (0.0.x): Bug fixes, backward-compatible

### Breaking Change Detection

Before any release, check for breaking changes:

- Removed or renamed public classes, methods, or properties
- Changed method signatures (added required parameters, changed types)
- Changed default behavior that consumers may rely on
- Removed or changed enum values

> [!CAUTION]
> Breaking changes require a MAJOR version bump and a migration guide in the
> CHANGELOG.

## CHANGELOG Conventions

Follow [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
## [3.1.0] - 2025-01-15

### Added

- New `onSearchChanged` callback for search filtering

### Fixed

- Dropdown not closing on outside tap (#42)

### Changed

- Improved animation performance for large lists
```

Categories: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`.

## Example App

- The `example/` directory must always contain a working, runnable example.
- The example should demonstrate **all major features** of the package.
- Keep the example up to date with any API changes.
- The example must compile and run without errors.

## Pub.dev Score Optimization

Aim for maximum pub.dev scores:

1. **Pub Points**:
   - Provide a valid `pubspec.yaml` with description, homepage, and
     screenshots.
   - Ensure `dart analyze` passes with zero issues.
   - Ensure `dart format` reports no changes needed.
   - Support multiple platforms (iOS, Android, Web, macOS, Windows, Linux).
   - Maintain `dartdoc` comments on all public APIs.

2. **Popularity & Likes**: Maintain a high-quality README with badges, GIFs,
   and clear usage instructions.

## Backward Compatibility

- **Deprecate before removing**: Use `@Deprecated('Use newMethod instead')`
  for at least one minor version before removing.
- **Default parameter values**: When adding new parameters, always provide
  sensible defaults to avoid breaking existing usage.
- **Test with minimum SDK**: Respect the SDK constraint in `pubspec.yaml`.

## Dependencies

- **Minimize dependencies**: A package should have as few dependencies as
  possible. Only `flutter` SDK should be a hard dependency unless absolutely
  necessary.
- **Dev dependencies only**: Testing and analysis packages go in
  `dev_dependencies`.
- **No transitive exposure**: Don't expose types from dependencies in your
  public API unless the dependency is re-exported intentionally.
