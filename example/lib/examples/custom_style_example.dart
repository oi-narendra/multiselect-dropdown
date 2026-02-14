import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// GitHub-style issue labels demonstrating heavy customization.
///
/// Three sub-sections show different visual treatments:
/// 1. Color-coded labels with matching chip colors
/// 2. Tag chips with [maxDisplayCount] overflow
/// 3. Pre-selected & disabled labels
class CustomStyleExample extends StatelessWidget {
  const CustomStyleExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Issue Labels'),
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
                const Icon(Icons.label_rounded, color: Colors.orange),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Apply labels to issues — like GitHub. '
                    'Customize chips, colors, and overflow behavior.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ---------- Section 1: Color-coded labels ----------
          Text(
            'Color-Coded Labels',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Each label type has its own color scheme.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          MultiDropdown<String>(
            items: [
              DropdownItem(label: '🐛 Bug', value: 'bug'),
              DropdownItem(label: '✨ Feature', value: 'feature'),
              DropdownItem(label: '🔧 Enhancement', value: 'enhancement'),
              DropdownItem(label: '📚 Documentation', value: 'docs'),
              DropdownItem(label: '🧪 Testing', value: 'testing'),
              DropdownItem(label: '🚀 Performance', value: 'performance'),
              DropdownItem(label: '🔒 Security', value: 'security'),
              DropdownItem(label: '♿ Accessibility', value: 'a11y'),
            ],
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
              hintText: 'Apply labels',
              prefixIcon: Icon(
                Icons.label_outline_rounded,
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

          // ---------- Section 2: Tag overflow ----------
          Text(
            'Tags with Overflow (+N more)',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Shows max 3 chips, then a "+N more" label.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          MultiDropdown<String>(
            items: [
              DropdownItem(label: 'Frontend', value: 'frontend'),
              DropdownItem(label: 'Backend', value: 'backend'),
              DropdownItem(label: 'Mobile', value: 'mobile'),
              DropdownItem(label: 'DevOps', value: 'devops'),
              DropdownItem(label: 'Database', value: 'database'),
              DropdownItem(label: 'API', value: 'api'),
            ],
            chipDecoration: ChipDecoration(
              backgroundColor: colorScheme.surfaceContainerHighest,
              labelStyle: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: colorScheme.outlineVariant),
              deleteIcon: Icon(
                Icons.close,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              wrap: true,
              spacing: 6,
              maxDisplayCount: 3,
            ),
            fieldDecoration: FieldDecoration(
              hintText: 'Add area tags',
              prefixIcon: Icon(
                Icons.tag_rounded,
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

          // ---------- Section 3: Pre-selected & disabled items ----------
          Text(
            'Pre-Selected & Disabled Labels',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '"In Progress" is locked. "Duplicate" is disabled.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          MultiDropdown<String>(
            items: [
              DropdownItem(
                label: '🔄 In Progress',
                value: 'in_progress',
                selected: true,
                disabled: true,
              ),
              DropdownItem(label: '📋 To Do', value: 'todo'),
              DropdownItem(label: '✅ Done', value: 'done'),
              DropdownItem(label: '🔍 In Review', value: 'in_review'),
              DropdownItem(
                label: '🚫 Duplicate',
                value: 'duplicate',
                disabled: true,
              ),
              DropdownItem(label: '⏸️ On Hold', value: 'on_hold'),
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
              hintText: 'Set status',
              prefixIcon: const Icon(Icons.track_changes_rounded),
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
