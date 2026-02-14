import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Demonstrates heavy customization of chip, field, dropdown, and item
/// decorations to create a unique, branded look.
class CustomStyleExample extends StatelessWidget {
  const CustomStyleExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final fruits = [
      DropdownItem(label: '🍎 Apple', value: 'apple'),
      DropdownItem(label: '🍌 Banana', value: 'banana'),
      DropdownItem(label: '🫐 Blueberry', value: 'blueberry'),
      DropdownItem(label: '🍒 Cherry', value: 'cherry'),
      DropdownItem(label: '🥭 Mango', value: 'mango'),
      DropdownItem(label: '🍊 Orange', value: 'orange'),
      DropdownItem(label: '🍑 Peach', value: 'peach'),
      DropdownItem(label: '🍓 Strawberry', value: 'strawberry'),
    ];

    final tags = [
      DropdownItem(label: 'Urgent', value: 'urgent'),
      DropdownItem(label: 'Bug', value: 'bug'),
      DropdownItem(label: 'Feature', value: 'feature'),
      DropdownItem(label: 'Enhancement', value: 'enhancement'),
      DropdownItem(label: 'Documentation', value: 'docs'),
      DropdownItem(label: 'Help Wanted', value: 'help'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Styling'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.withAlpha(40),
                  Colors.orange.withAlpha(30),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.palette_outlined, color: Colors.orange),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Customize every visual aspect — chips, borders, '
                    'dropdown background, item colors, and more.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ---------- Example 1: Rounded pill chips ----------
          Text(
            'Pill-Style Chips',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          MultiDropdown<String>(
            items: fruits,
            chipDecoration: ChipDecoration(
              backgroundColor: Colors.deepOrange.shade50,
              labelStyle: TextStyle(
                color: Colors.deepOrange.shade800,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.deepOrange.shade200,
              ),
              deleteIcon: Icon(
                Icons.cancel_rounded,
                size: 16,
                color: Colors.deepOrange.shade400,
              ),
              wrap: true,
              spacing: 8,
              runSpacing: 8,
            ),
            fieldDecoration: FieldDecoration(
              hintText: 'Pick your fruits',
              prefixIcon: Icon(
                Icons.eco_outlined,
                color: Colors.deepOrange.shade400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.deepOrange.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.deepOrange.shade400,
                  width: 2,
                ),
              ),
              backgroundColor: Colors.deepOrange.shade50.withAlpha(40),
            ),
            dropdownDecoration: DropdownDecoration(
              backgroundColor: colorScheme.surfaceContainerLow,
              maxHeight: 300,
              borderRadius: BorderRadius.circular(16),
              elevation: 4,
            ),
            dropdownItemDecoration: DropdownItemDecoration(
              selectedIcon: Icon(
                Icons.check_circle,
                color: Colors.deepOrange.shade400,
                size: 20,
              ),
              selectedBackgroundColor: Colors.deepOrange.shade50,
            ),
          ),
          const SizedBox(height: 36),

          // ---------- Example 2: Dark tag style ----------
          Text(
            'Tag-Style Chips with Max Display Count',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          MultiDropdown<String>(
            items: tags,
            chipDecoration: ChipDecoration(
              backgroundColor: colorScheme.inverseSurface,
              labelStyle: TextStyle(
                color: colorScheme.onInverseSurface,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              borderRadius: BorderRadius.circular(6),
              deleteIcon: Icon(
                Icons.close,
                size: 14,
                color: colorScheme.onInverseSurface,
              ),
              wrap: false,
              spacing: 6,
              maxDisplayCount: 3,
            ),
            fieldDecoration: FieldDecoration(
              hintText: 'Add tags',
              prefixIcon: Icon(
                Icons.label_outline_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            dropdownDecoration: DropdownDecoration(
              backgroundColor: colorScheme.surfaceContainerLow,
              maxHeight: 280,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 36),

          // ---------- Example 3: Disabled items ----------
          Text(
            'With Pre-Selected & Disabled Items',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          MultiDropdown<String>(
            items: [
              DropdownItem(
                label: 'Admin',
                value: 'admin',
                selected: true,
                disabled: true,
              ),
              DropdownItem(label: 'Editor', value: 'editor'),
              DropdownItem(label: 'Viewer', value: 'viewer'),
              DropdownItem(
                label: 'Guest',
                value: 'guest',
                disabled: true,
              ),
              DropdownItem(label: 'Moderator', value: 'moderator'),
            ],
            chipDecoration: ChipDecoration(
              backgroundColor: colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontSize: 13,
              ),
              borderRadius: BorderRadius.circular(20),
              deleteIcon: Icon(
                Icons.close_rounded,
                size: 14,
                color: colorScheme.onPrimaryContainer,
              ),
              wrap: true,
              spacing: 8,
              runSpacing: 8,
            ),
            fieldDecoration: FieldDecoration(
              hintText: 'Assign roles',
              prefixIcon: const Icon(Icons.people_outline_rounded),
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
            dropdownItemDecoration: DropdownItemDecoration(
              disabledIcon: Icon(
                Icons.lock_outline,
                color: colorScheme.outline,
                size: 18,
              ),
            ),
            dropdownDecoration: DropdownDecoration(
              backgroundColor: colorScheme.surfaceContainerLow,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
