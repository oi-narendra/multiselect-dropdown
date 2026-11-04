# Use standalone Material types in version 4

Status: Accepted for the proposed 4.0.0 release

Date: 2026-11-04

## Context

Issue #226 passes a `material_ui.OutlineInputBorder` into a package using
Flutter's legacy Material library. These libraries define distinct Dart types.
The initial #227 patch accepts `Object?` and casts it to `dynamic` when building
`InputDecoration`. A widget regression test reproduces the resulting runtime
type error. A compatibility bridge does not convert these border objects.

## Decision

Use `material_ui` throughout the package, tests, and example application.
Retain `InputBorder?` for search decorations and remove the dynamic casts.
Require Flutter 3.47/Dart 3.13 and material_ui ^1.4.0, the first material_ui
release targeting that SDK baseline.

## Consequences

This is a major version change because the public Material types have changed.
Consumers must migrate their imports and Material app/theme together. Existing
legacy apps can remain on 3.x. Migrating only the search field would leave
other decorations and inherited Material themes split between libraries;
loosening types would merely postpone errors until runtime.

Regression coverage exercises real standalone borders, focus, search, and
selection in both overlay and bottom-sheet modes. The existing suite runs
under a standalone Material app as well.
