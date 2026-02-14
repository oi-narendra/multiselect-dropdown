import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Searchable dropdown with a large list of programming languages.
///
/// Demonstrates [searchEnabled] with custom [SearchFieldDecoration].
class SearchableExample extends StatefulWidget {
  const SearchableExample({super.key});

  @override
  State<SearchableExample> createState() => _SearchableExampleState();
}

class _SearchableExampleState extends State<SearchableExample> {
  final _items = [
    'C',
    'C++',
    'C#',
    'Dart',
    'Elixir',
    'Erlang',
    'Go',
    'Haskell',
    'Java',
    'JavaScript',
    'Kotlin',
    'Lua',
    'Objective-C',
    'PHP',
    'Python',
    'R',
    'Ruby',
    'Rust',
    'Scala',
    'Swift',
    'TypeScript',
    'Zig',
  ].map((lang) => DropdownItem(label: lang, value: lang)).toList();

  List<String> _selected = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Searchable Dropdown'),
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
                Icon(Icons.search_rounded, color: colorScheme.secondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Type to filter through 22 programming languages. '
                    'Great for large item lists.',
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
              hintText: 'Type to search...',
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
                Icons.search,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
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
              hintText: 'Select languages',
              prefixIcon: const Icon(Icons.code_rounded),
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

          // Animated language chips display
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _selected.isEmpty
                ? const SizedBox.shrink()
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selected.map((lang) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.secondary.withAlpha(30),
                              colorScheme.tertiary.withAlpha(20),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colorScheme.secondary.withAlpha(60),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.terminal_rounded,
                              size: 14,
                              color: colorScheme.secondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              lang,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
