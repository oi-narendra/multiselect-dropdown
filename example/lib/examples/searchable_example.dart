import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Team member picker with search and custom item builder.
///
/// Demonstrates [searchEnabled] with a realistic "add people to a project"
/// scenario, showing avatar initials + department in each dropdown item.
class SearchableExample extends StatefulWidget {
  const SearchableExample({super.key});

  @override
  State<SearchableExample> createState() => _SearchableExampleState();
}

class _SearchableExampleState extends State<SearchableExample> {
  static const _departments = <String, String>{
    'alice_johnson': 'Engineering',
    'bob_martinez': 'Design',
    'carol_chen': 'Product',
    'daniel_kim': 'Engineering',
    'emma_wilson': 'Marketing',
    'frank_lee': 'Engineering',
    'grace_patel': 'Finance',
    'henry_taylor': 'Design',
    'iris_thompson': 'Product',
    'jack_brown': 'Engineering',
    'kate_davis': 'HR',
    'liam_garcia': 'Marketing',
    'mia_anderson': 'Engineering',
    'noah_wright': 'Design',
    'olivia_clark': 'Product',
    'peter_wang': 'Engineering',
    'quinn_foster': 'Finance',
    'rachel_moore': 'HR',
    'samuel_james': 'Engineering',
    'tara_singh': 'Marketing',
  };

  static const _avatarColors = [
    Color(0xFF6366F1),
    Color(0xFFEC4899),
    Color(0xFF14B8A6),
    Color(0xFFF59E0B),
    Color(0xFF8B5CF6),
    Color(0xFFEF4444),
    Color(0xFF06B6D4),
    Color(0xFF10B981),
  ];

  final _items = _departments.entries.map((e) {
    final name = e.key
        .split('_')
        .map(
          (w) => '${w[0].toUpperCase()}${w.substring(1)}',
        )
        .join(' ');
    return DropdownItem(label: name, value: e.key);
  }).toList();

  List<String> _selected = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Members'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.secondaryContainer.withAlpha(120),
                  colorScheme.primaryContainer.withAlpha(80),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.group_add_rounded, color: colorScheme.secondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Search and add team members to your project. '
                    'Type a name to filter through 20 people.',
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
            searchDecoration: SearchFieldDecoration(
              hintText: 'Search by name...',
              autofocus: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.secondary,
                  width: 1.5,
                ),
              ),
              searchIcon: Icon(
                Icons.person_search_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            itemBuilder: (item, index, onTap) {
              final initials =
                  item.label.split(' ').take(2).map((w) => w[0]).join();
              final dept = _departments[item.value] ?? '';
              final avatarColor = _avatarColors[index % _avatarColors.length];

              return ListTile(
                onTap: onTap,
                leading: CircleAvatar(
                  backgroundColor: item.selected
                      ? colorScheme.primary
                      : avatarColor.withAlpha(40),
                  child: Text(
                    initials,
                    style: TextStyle(
                      color:
                          item.selected ? colorScheme.onPrimary : avatarColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                title: Text(
                  item.label,
                  style: TextStyle(
                    fontWeight:
                        item.selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                subtitle: Text(
                  dept,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: item.selected
                    ? Icon(
                        Icons.check_circle_rounded,
                        color: colorScheme.primary,
                        size: 20,
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
              );
            },
            chipDecoration: ChipDecoration(
              backgroundColor: colorScheme.secondaryContainer,
              labelStyle: TextStyle(
                color: colorScheme.onSecondaryContainer,
                fontSize: 13,
              ),
              wrap: true,
              runSpacing: 4,
              spacing: 8,
              borderRadius: BorderRadius.circular(20),
              deleteIcon: Icon(
                Icons.close_rounded,
                size: 14,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
            fieldDecoration: FieldDecoration(
              hintText: 'Add team members',
              prefixIcon: const Icon(Icons.group_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: colorScheme.secondary,
                  width: 2,
                ),
              ),
            ),
            dropdownDecoration: DropdownDecoration(
              maxHeight: 350,
              backgroundColor: colorScheme.surfaceContainerLow,
            ),
            onSelectionChange: (values) {
              setState(() => _selected = values);
            },
          ),
          const SizedBox(height: 24),

          // Team members display
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _selected.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          'Team (${_selected.length} members)',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      ..._selected.map((id) {
                        final name =
                            _items.firstWhere((i) => i.value == id).label;
                        final dept = _departments[id] ?? '';
                        final index = _items.indexWhere((i) => i.value == id);
                        final color =
                            _avatarColors[index % _avatarColors.length];
                        final initials =
                            name.split(' ').take(2).map((w) => w[0]).join();

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest
                                  .withAlpha(80),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.outlineVariant.withAlpha(80),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: color.withAlpha(40),
                                  child: Text(
                                    initials,
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        dept,
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
