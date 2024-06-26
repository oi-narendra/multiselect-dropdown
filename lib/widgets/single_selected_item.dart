import 'package:flutter/material.dart';

/// [SingleSelectedItem] is a selected item builder.
/// It is used to build the selected item.
class SingleSelectedItem extends StatelessWidget {
  /// [label] is the selected item label.
  final String label;

  final TextStyle? style;

  const SingleSelectedItem({
    required this.label,
    this.style,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        label,
        style: style ??
            TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
      ),
    );
  }
}
