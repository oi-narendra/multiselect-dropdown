import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Accessibility showcase demonstrating a11y best practices.
///
/// Includes a live font scale slider to test how the dropdown
/// handles different text sizes, plus high contrast mode.
class AccessibilityExample extends StatefulWidget {
  const AccessibilityExample({super.key});

  @override
  State<AccessibilityExample> createState() => _AccessibilityExampleState();
}

class _AccessibilityExampleState extends State<AccessibilityExample> {
  double _textScale = 1.0;
  bool _highContrast = false;
  List<String> _selected = [];

  final _items = [
    DropdownItem(label: 'Notification Preferences', value: 'notif'),
    DropdownItem(label: 'Display Settings', value: 'display'),
    DropdownItem(label: 'Privacy Options', value: 'privacy'),
    DropdownItem(label: 'Language & Region', value: 'lang'),
    DropdownItem(label: 'Sound & Haptics', value: 'sound'),
    DropdownItem(label: 'Accessibility Features', value: 'a11y'),
    DropdownItem(label: 'Storage Management', value: 'storage'),
    DropdownItem(label: 'Account Security', value: 'security'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final highContrastColors = _highContrast
        ? (
            border: Colors.black,
            background: Colors.white,
            text: Colors.black,
            chip: Colors.black,
            chipText: Colors.white,
          )
        : (
            border: colorScheme.outline,
            background: colorScheme.surface,
            text: colorScheme.onSurface,
            chip: colorScheme.primaryContainer,
            chipText: colorScheme.onPrimaryContainer,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility'),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(_textScale),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Semantics(
              label: 'Accessibility showcase for the multi-select dropdown',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.withAlpha(40),
                      Colors.deepPurple.withAlpha(30),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.accessibility_new_rounded,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Adjust font size and contrast to see how '
                        'the dropdown handles different accessibility settings.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Accessibility controls
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withAlpha(80),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Live Controls',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Font scale slider
                  Semantics(
                    label: 'Font size scale slider',
                    value: '${(_textScale * 100).round()}%',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.text_fields, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Font Scale: ${_textScale.toStringAsFixed(1)}x',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Slider(
                          value: _textScale,
                          min: 0.8,
                          max: 2.0,
                          divisions: 12,
                          label: '${_textScale.toStringAsFixed(1)}x',
                          onChanged: (value) {
                            setState(() => _textScale = value);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '0.8x',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '2.0x',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // High contrast toggle
                  Semantics(
                    toggled: _highContrast,
                    label: 'High contrast mode',
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _highContrast,
                      onChanged: (v) {
                        setState(() => _highContrast = v);
                      },
                      title: Row(
                        children: [
                          const Icon(Icons.contrast, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'High Contrast',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // The dropdown under test
            Semantics(
              label: 'Settings categories selection',
              child: MultiDropdown<String>(
                items: _items,
                chipDecoration: ChipDecoration(
                  backgroundColor: highContrastColors.chip,
                  labelStyle: TextStyle(
                    color: highContrastColors.chipText,
                    fontWeight:
                        _highContrast ? FontWeight.w700 : FontWeight.w400,
                    fontSize: 13,
                  ),
                  borderRadius: BorderRadius.circular(_highContrast ? 4 : 20),
                  deleteIcon: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: highContrastColors.chipText,
                  ),
                  border: _highContrast
                      ? Border.all(color: Colors.black, width: 2)
                      : const Border(),
                  wrap: true,
                  spacing: 8,
                  runSpacing: 8,
                ),
                fieldDecoration: FieldDecoration(
                  hintText: 'Choose settings categories',
                  prefixIcon: const Icon(Icons.settings_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_highContrast ? 4 : 14),
                    borderSide: BorderSide(
                      color: highContrastColors.border,
                      width: _highContrast ? 2 : 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_highContrast ? 4 : 14),
                    borderSide: BorderSide(
                      color: _highContrast ? Colors.black : colorScheme.primary,
                      width: _highContrast ? 3 : 2,
                    ),
                  ),
                ),
                dropdownDecoration: DropdownDecoration(
                  backgroundColor: highContrastColors.background,
                  maxHeight: 320,
                ),
                dropdownItemDecoration: DropdownItemDecoration(
                  selectedIcon: Icon(
                    Icons.check_circle,
                    color: _highContrast ? Colors.black : colorScheme.primary,
                    size: 20,
                  ),
                ),
                onSelectionChange: (values) {
                  setState(() => _selected = values);
                },
              ),
            ),
            const SizedBox(height: 24),

            // Current state info
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selected.isNotEmpty
                  ? Container(
                      key: ValueKey(_selected.length),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50.withAlpha(60),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.purple.shade200,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected ${_selected.length} categories',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.purple.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Font scale: ${_textScale.toStringAsFixed(1)}x  •  '
                            'High contrast: ${_highContrast ? "ON" : "OFF"}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
