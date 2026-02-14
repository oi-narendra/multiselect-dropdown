import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Basic multi-select dropdown with country items.
///
/// Demonstrates the simplest usage of [MultiDropdown] with
/// chip-based selection and an `onSelectionChange` callback.
class BasicExample extends StatefulWidget {
  const BasicExample({super.key});

  @override
  State<BasicExample> createState() => _BasicExampleState();
}

class _BasicExampleState extends State<BasicExample> {
  final _items = [
    DropdownItem(label: 'Australia', value: 'AU'),
    DropdownItem(label: 'Canada', value: 'CA'),
    DropdownItem(label: 'France', value: 'FR'),
    DropdownItem(label: 'Germany', value: 'DE'),
    DropdownItem(label: 'India', value: 'IN'),
    DropdownItem(label: 'Japan', value: 'JP'),
    DropdownItem(label: 'Nepal', value: 'NP'),
    DropdownItem(label: 'United Kingdom', value: 'UK'),
    DropdownItem(label: 'United States', value: 'US'),
  ];

  List<String> _selected = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Multi-Select'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Description card
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
                Icon(Icons.info_outline, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Select multiple countries from the dropdown. '
                    'Selected items appear as chips below the field.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Dropdown
          MultiDropdown<String>(
            items: _items,
            chipDecoration: ChipDecoration(
              backgroundColor: colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontSize: 13,
              ),
              wrap: true,
              runSpacing: 4,
              spacing: 8,
              borderRadius: BorderRadius.circular(20),
              deleteIcon: Icon(
                Icons.close_rounded,
                size: 14,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            fieldDecoration: FieldDecoration(
              hintText: 'Select countries',
              prefixIcon: const Icon(Icons.flag_outlined),
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

          // Live output
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _selected.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    key: ValueKey(_selected.length),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withAlpha(100),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected (${_selected.length})',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selected.join(', '),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
