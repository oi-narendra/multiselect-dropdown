import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Demonstrates custom search filter functionality.
///
/// Uses a multi-field search that matches against both the label and value.
class CustomSearchExample extends StatefulWidget {
  const CustomSearchExample({super.key});

  @override
  State<CustomSearchExample> createState() => _CustomSearchExampleState();
}

class _CustomSearchExampleState extends State<CustomSearchExample> {
  final _items = [
    DropdownItem(label: 'Alice Johnson', value: 'alice@example.com'),
    DropdownItem(label: 'Bob Smith', value: 'bob@example.com'),
    DropdownItem(label: 'Carol Williams', value: 'carol@example.com'),
    DropdownItem(label: 'David Brown', value: 'david@example.com'),
    DropdownItem(label: 'Eve Davis', value: 'eve@example.com'),
    DropdownItem(label: 'Frank Miller', value: 'frank@example.com'),
    DropdownItem(label: 'Grace Wilson', value: 'grace@example.com'),
    DropdownItem(label: 'Henry Moore', value: 'henry@example.com'),
  ];

  List<String> _selected = [];

  /// Custom filter: matches name OR email address.
  List<DropdownItem<String>> _multiFieldFilter(
    String query,
    List<DropdownItem<String>> items,
  ) {
    final q = query.toLowerCase();
    return items.where((item) {
      return item.label.toLowerCase().contains(q) ||
          item.value.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Contact Picker')),
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
                Icon(Icons.search_rounded, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Type a name or email to search. The custom filter '
                    'matches against both fields simultaneously.',
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
            searchEnabled: true,
            searchFilter: _multiFieldFilter,
            fieldDecoration: FieldDecoration(
              hintText: 'Search by name or email',
              prefixIcon: const Icon(Icons.contacts_outlined),
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
                'Emails: ${_selected.join(', ')}',
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
