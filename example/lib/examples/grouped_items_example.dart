import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Demonstrates grouped / sectioned dropdown items.
class GroupedItemsExample extends StatefulWidget {
  const GroupedItemsExample({super.key});

  @override
  State<GroupedItemsExample> createState() => _GroupedItemsExampleState();
}

class _GroupedItemsExampleState extends State<GroupedItemsExample> {
  final _groups = [
    DropdownGroup(
      label: '🍎 Fruits',
      items: [
        DropdownItem(label: 'Apple', value: 'apple'),
        DropdownItem(label: 'Banana', value: 'banana'),
        DropdownItem(label: 'Mango', value: 'mango'),
        DropdownItem(label: 'Strawberry', value: 'strawberry'),
      ],
    ),
    DropdownGroup(
      label: '🥦 Vegetables',
      items: [
        DropdownItem(label: 'Broccoli', value: 'broccoli'),
        DropdownItem(label: 'Carrot', value: 'carrot'),
        DropdownItem(label: 'Spinach', value: 'spinach'),
      ],
    ),
    DropdownGroup(
      label: '🥩 Proteins',
      items: [
        DropdownItem(label: 'Chicken', value: 'chicken'),
        DropdownItem(label: 'Salmon', value: 'salmon'),
        DropdownItem(label: 'Tofu', value: 'tofu'),
      ],
    ),
  ];

  List<String> _selected = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Grocery List')),
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
                Icon(Icons.category_rounded, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Items are organized under section headers. '
                    'Search filters within groups automatically.',
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
            items: const [],
            groups: _groups,
            searchEnabled: true,
            groupHeaderDecoration: GroupHeaderDecoration(
              textStyle: TextStyle(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
                fontSize: 14,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ),
            fieldDecoration: FieldDecoration(
              hintText: 'Build your grocery list',
              prefixIcon: const Icon(Icons.shopping_cart_outlined),
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
                'Shopping list: ${_selected.join(', ')}',
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
