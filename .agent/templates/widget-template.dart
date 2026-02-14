// Template: New Widget for multi_dropdown package
//
// Usage: Copy this template when creating a new widget in lib/src/.
// Replace all placeholders (WidgetName, description, properties).
//
// Checklist:
//   [ ] Rename file to snake_case matching the widget name
//   [ ] Add export to lib/multi_dropdown.dart
//   [ ] Add widget tests in test/
//   [ ] Add dartdoc with examples
//   [ ] Update example app if user-facing

import 'package:flutter/material.dart';

/// A brief, single-sentence description of what this widget does.
///
/// Longer description with usage context and examples:
///
/// ```dart
/// WidgetName(
///   property: value,
///   child: Text('Example'),
/// )
/// ```
class WidgetName extends StatelessWidget {
  /// Creates a [WidgetName].
  ///
  /// The [child] parameter must not be null.
  const WidgetName({
    required this.child,
    this.enabled = true,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Whether this widget is interactive.
  ///
  /// Defaults to `true`.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: child,
    );
  }
}
