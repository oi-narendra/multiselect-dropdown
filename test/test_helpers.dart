import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Wraps a widget in a MaterialApp + Scaffold for testing.
Widget buildTestApp(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    ),
  );
}

/// Creates a list of basic dropdown items for testing.
List<DropdownItem<int>> createItems([int count = 5]) {
  return List.generate(
    count,
    (i) => DropdownItem(label: 'Item ${i + 1}', value: i + 1),
  );
}
