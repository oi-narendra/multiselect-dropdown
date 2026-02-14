import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Demonstrates programmatic control via [MultiSelectController].
///
/// Showcases: selectAll, clearAll, selectWhere, selectAtIndex,
/// openDropdown, closeDropdown, and addItem.
class ControllerExample extends StatefulWidget {
  const ControllerExample({super.key});

  @override
  State<ControllerExample> createState() => _ControllerExampleState();
}

class _ControllerExampleState extends State<ControllerExample> {
  final _controller = MultiSelectController<int>();
  int _addCounter = 6;

  final _items = [
    DropdownItem(label: 'React', value: 1),
    DropdownItem(label: 'Angular', value: 2),
    DropdownItem(label: 'Vue', value: 3),
    DropdownItem(label: 'Svelte', value: 4),
    DropdownItem(label: 'Flutter', value: 5),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controller Actions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.indigo.withAlpha(40),
                  Colors.blue.withAlpha(30),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.gamepad_outlined, color: Colors.indigo),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Control the dropdown programmatically using '
                    'MultiSelectController methods.',
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
          MultiDropdown<int>(
            items: _items,
            controller: _controller,
            chipDecoration: ChipDecoration(
              backgroundColor: Colors.indigo.shade50,
              labelStyle: TextStyle(
                color: Colors.indigo.shade700,
                fontSize: 13,
              ),
              borderRadius: BorderRadius.circular(20),
              deleteIcon: Icon(
                Icons.close_rounded,
                size: 14,
                color: Colors.indigo.shade400,
              ),
              wrap: true,
              spacing: 8,
              runSpacing: 8,
            ),
            fieldDecoration: FieldDecoration(
              hintText: 'Select frameworks',
              prefixIcon: Icon(
                Icons.widgets_outlined,
                color: Colors.indigo.shade400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.indigo.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.indigo.shade400,
                  width: 2,
                ),
              ),
            ),
            dropdownDecoration: DropdownDecoration(
              backgroundColor: colorScheme.surfaceContainerLow,
              maxHeight: 300,
            ),
          ),
          const SizedBox(height: 24),

          // Controller action buttons
          Text(
            'Controller Actions',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ActionChip(
                icon: Icons.select_all_rounded,
                label: 'Select All',
                color: Colors.green,
                onTap: () => _controller.selectAll(),
              ),
              _ActionChip(
                icon: Icons.deselect_rounded,
                label: 'Clear All',
                color: Colors.red,
                onTap: () => _controller.clearAll(),
              ),
              _ActionChip(
                icon: Icons.filter_alt_outlined,
                label: 'Select Where (value ≤ 3)',
                color: Colors.orange,
                onTap: () => _controller.selectWhere(
                  (item) => item.value <= 3,
                ),
              ),
              _ActionChip(
                icon: Icons.looks_one_outlined,
                label: 'Select At Index 0',
                color: Colors.teal,
                onTap: () => _controller.selectAtIndex(0),
              ),
              _ActionChip(
                icon: Icons.arrow_drop_down_circle_outlined,
                label: 'Open Dropdown',
                color: Colors.blue,
                onTap: () => _controller.openDropdown(),
              ),
              _ActionChip(
                icon: Icons.arrow_drop_up_outlined,
                label: 'Close Dropdown',
                color: Colors.blueGrey,
                onTap: () => _controller.closeDropdown(),
              ),
              _ActionChip(
                icon: Icons.add_circle_outline,
                label: 'Add Item',
                color: Colors.purple,
                onTap: () {
                  _addCounter++;
                  _controller.addItem(
                    DropdownItem(
                      label: 'Framework $_addCounter',
                      value: _addCounter,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withAlpha(20),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
