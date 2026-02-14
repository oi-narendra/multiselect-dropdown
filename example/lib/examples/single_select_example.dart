import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Single-select dropdown that acts as a modern replacement for
/// [DropdownButton]. Only one item can be selected at a time.
class SingleSelectExample extends StatefulWidget {
  const SingleSelectExample({super.key});

  @override
  State<SingleSelectExample> createState() => _SingleSelectExampleState();
}

class _SingleSelectExampleState extends State<SingleSelectExample> {
  final _items = [
    DropdownItem(label: 'Software Engineer', value: 'swe'),
    DropdownItem(label: 'Product Manager', value: 'pm'),
    DropdownItem(label: 'Designer', value: 'design'),
    DropdownItem(label: 'Data Scientist', value: 'ds'),
    DropdownItem(label: 'DevOps Engineer', value: 'devops'),
    DropdownItem(label: 'QA Engineer', value: 'qa'),
  ];

  String? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Single Select'),
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
                Icon(Icons.touch_app_outlined, color: colorScheme.tertiary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Only one item can be selected at a time. '
                    'The dropdown closes automatically after selection.',
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
              hintText: 'Choose a role',
              prefixIcon: const Icon(Icons.work_outline_rounded),
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
              selectedBackgroundColor: colorScheme.tertiaryContainer.withAlpha(80),
            ),
            onSelectionChange: (values) {
              setState(() => _selected = values.firstOrNull);
            },
          ),
          const SizedBox(height: 32),

          // Selection display
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _selected != null
                ? Card(
                    key: ValueKey(_selected),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.badge_outlined,
                              color: colorScheme.onTertiaryContainer,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selected Role',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _items
                                    .firstWhere((i) => i.value == _selected)
                                    .label,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
