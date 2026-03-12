import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Demonstrates the Select All / Deselect All toggle feature.
class SelectAllExample extends StatefulWidget {
  const SelectAllExample({super.key});

  @override
  State<SelectAllExample> createState() => _SelectAllExampleState();
}

class _SelectAllExampleState extends State<SelectAllExample> {
  final _items = [
    DropdownItem(label: 'Monday', value: 'mon'),
    DropdownItem(label: 'Tuesday', value: 'tue'),
    DropdownItem(label: 'Wednesday', value: 'wed'),
    DropdownItem(label: 'Thursday', value: 'thu'),
    DropdownItem(label: 'Friday', value: 'fri'),
    DropdownItem(label: 'Saturday', value: 'sat'),
    DropdownItem(label: 'Sunday', value: 'sun'),
  ];

  List<String> _selected = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Working Days')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer.withAlpha(120),
                  colorScheme.secondaryContainer.withAlpha(80),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.check_box_rounded, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Use the "Select All" toggle at the top of the list '
                    'to quickly pick or clear all days.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          MultiDropdown<String>(
            items: _items,
            showSelectAll: true,
            dropdownDecoration: const DropdownDecoration(
              selectAllText: 'Select all days',
              deselectAllText: 'Clear all days',
            ),
            fieldDecoration: FieldDecoration(
              hintText: 'Select working days',
              prefixIcon: const Icon(Icons.calendar_today_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            onSelectionChange: (values) {
              setState(() => _selected = values);
            },
          ),
          const SizedBox(height: 24),
          if (_selected.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withAlpha(100),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Text(
                '${_selected.length} day(s): ${_selected.join(', ')}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
