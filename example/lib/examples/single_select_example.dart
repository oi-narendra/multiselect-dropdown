import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Task priority selector demonstrating single-select mode.
///
/// A project management scenario where the user sets a task priority.
/// The result card changes color to match the chosen priority level.
class SingleSelectExample extends StatefulWidget {
  const SingleSelectExample({super.key});

  @override
  State<SingleSelectExample> createState() => _SingleSelectExampleState();
}

class _SingleSelectExampleState extends State<SingleSelectExample> {
  static const _priorityColors = <String, Color>{
    'critical': Color(0xFFD32F2F),
    'high': Color(0xFFE65100),
    'medium': Color(0xFFF9A825),
    'low': Color(0xFF1565C0),
    'none': Color(0xFF757575),
  };

  static const _priorityIcons = <String, IconData>{
    'critical': Icons.error_rounded,
    'high': Icons.arrow_upward_rounded,
    'medium': Icons.remove_rounded,
    'low': Icons.arrow_downward_rounded,
    'none': Icons.horizontal_rule_rounded,
  };

  final _items = [
    DropdownItem(label: '🔴 Critical', value: 'critical'),
    DropdownItem(label: '🟠 High', value: 'high'),
    DropdownItem(label: '🟡 Medium', value: 'medium'),
    DropdownItem(label: '🔵 Low', value: 'low'),
    DropdownItem(label: '⚪ None', value: 'none'),
  ];

  String? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedColor =
        _selected != null ? _priorityColors[_selected]! : colorScheme.outline;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Priority'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.tertiaryContainer.withAlpha(120),
                  colorScheme.secondaryContainer.withAlpha(80),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.flag_rounded,
                  color: colorScheme.tertiary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Set the priority for your task. Only one level '
                    'can be selected at a time.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Single-select dropdown
          MultiDropdown<String>(
            items: _items,
            singleSelect: true,
            fieldDecoration: FieldDecoration(
              hintText: 'Set priority',
              prefixIcon: const Icon(Icons.flag_outlined),
              showClearIcon: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: colorScheme.tertiary,
                  width: 2,
                ),
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
            dropdownItemDecoration: DropdownItemDecoration(
              selectedIcon: Icon(
                Icons.radio_button_checked,
                color: colorScheme.tertiary,
                size: 20,
              ),
              selectedBackgroundColor:
                  colorScheme.tertiaryContainer.withAlpha(80),
            ),
            onSelectionChange: (values) {
              setState(() => _selected = values.firstOrNull);
            },
          ),
          const SizedBox(height: 32),

          // Color-coded result card
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _selected != null
                ? Card(
                    key: ValueKey(_selected),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: selectedColor.withAlpha(100),
                      ),
                    ),
                    color: selectedColor.withAlpha(20),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: selectedColor.withAlpha(40),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _priorityIcons[_selected] ?? Icons.flag_rounded,
                              color: selectedColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Priority Level',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _items
                                      .firstWhere(
                                        (i) => i.value == _selected,
                                      )
                                      .label,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: selectedColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
