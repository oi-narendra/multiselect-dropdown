import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Demonstrates the bottom sheet presentation mode.
class BottomSheetExample extends StatefulWidget {
  const BottomSheetExample({super.key});

  @override
  State<BottomSheetExample> createState() => _BottomSheetExampleState();
}

class _BottomSheetExampleState extends State<BottomSheetExample> {
  final _items = [
    DropdownItem(label: 'English', value: 'en'),
    DropdownItem(label: 'Spanish', value: 'es'),
    DropdownItem(label: 'French', value: 'fr'),
    DropdownItem(label: 'German', value: 'de'),
    DropdownItem(label: 'Italian', value: 'it'),
    DropdownItem(label: 'Portuguese', value: 'pt'),
    DropdownItem(label: 'Japanese', value: 'ja'),
    DropdownItem(label: 'Korean', value: 'ko'),
    DropdownItem(label: 'Chinese', value: 'zh'),
    DropdownItem(label: 'Hindi', value: 'hi'),
    DropdownItem(label: 'Arabic', value: 'ar'),
    DropdownItem(label: 'Russian', value: 'ru'),
  ];

  List<String> _selected = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Languages')),
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
                Icon(Icons.swipe_up_rounded, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tap the field to open a draggable bottom sheet '
                    'instead of the default overlay dropdown.',
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
            dropdownMode: DropdownMode.bottomSheet,
            searchEnabled: true,
            fieldDecoration: FieldDecoration(
              labelText: 'Spoken languages',
              hintText: 'Tap to select languages',
              prefixIcon: const Icon(Icons.language_outlined),
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
                'Languages: ${_selected.join(', ')}',
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
