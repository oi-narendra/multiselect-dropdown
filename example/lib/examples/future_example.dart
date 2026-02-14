import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Async data loading using [MultiDropdown.future].
///
/// Simulates fetching users from an API with a network delay,
/// showing the built-in loading spinner.
class FutureExample extends StatefulWidget {
  const FutureExample({super.key});

  @override
  State<FutureExample> createState() => _FutureExampleState();
}

class _FutureExampleState extends State<FutureExample> {
  List<String> _selected = [];

  /// Simulates an API call that returns a list of users.
  Future<List<DropdownItem<String>>> _fetchUsers() async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(seconds: 2));

    return [
      DropdownItem(label: 'Alice Johnson', value: 'alice'),
      DropdownItem(label: 'Bob Martinez', value: 'bob'),
      DropdownItem(label: 'Carol Chen', value: 'carol'),
      DropdownItem(label: 'Daniel Kim', value: 'daniel'),
      DropdownItem(label: 'Emma Wilson', value: 'emma'),
      DropdownItem(label: 'Frank Lee', value: 'frank'),
      DropdownItem(label: 'Grace Patel', value: 'grace'),
      DropdownItem(label: 'Henry Taylor', value: 'henry'),
      DropdownItem(label: 'Iris Thompson', value: 'iris'),
      DropdownItem(label: 'Jack Brown', value: 'jack'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Async Loading'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan.withAlpha(40),
                  Colors.blue.withAlpha(30),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.cloud_download_rounded, color: Colors.cyan),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Items are loaded asynchronously using '
                    'MultiDropdown.future(). '
                    'Notice the loading spinner during the 2-second delay.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Async dropdown
          MultiDropdown<String>.future(
            future: _fetchUsers,
            chipDecoration: ChipDecoration(
              backgroundColor: Colors.cyan.shade50,
              labelStyle: TextStyle(
                color: Colors.cyan.shade800,
                fontSize: 13,
              ),
              borderRadius: BorderRadius.circular(20),
              deleteIcon: Icon(
                Icons.close_rounded,
                size: 14,
                color: Colors.cyan.shade400,
              ),
              wrap: true,
              spacing: 8,
              runSpacing: 8,
            ),
            fieldDecoration: FieldDecoration(
              hintText: 'Select users',
              prefixIcon: Icon(
                Icons.people_outline_rounded,
                color: Colors.cyan.shade400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.cyan.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.cyan.shade400,
                  width: 2,
                ),
              ),
            ),
            dropdownDecoration: DropdownDecoration(
              backgroundColor: colorScheme.surfaceContainerLow,
              maxHeight: 300,
            ),
            onSelectionChange: (values) {
              setState(() => _selected = values);
            },
          ),
          const SizedBox(height: 24),

          // How it works
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
                  'How it works',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.code_rounded,
                  label: 'Uses MultiDropdown.future()',
                  colorScheme: colorScheme,
                ),
                _InfoRow(
                  icon: Icons.timer_rounded,
                  label: '2-second simulated API delay',
                  colorScheme: colorScheme,
                ),
                _InfoRow(
                  icon: Icons.refresh_rounded,
                  label: 'Shows loading spinner automatically',
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Selected values
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _selected.isNotEmpty
                ? Container(
                    key: ValueKey(_selected.length),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.cyan.shade50.withAlpha(60),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.cyan.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 18,
                          color: Colors.cyan.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Selected: ${_selected.join(", ")}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontFamily: 'monospace',
                              color: Colors.cyan.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
