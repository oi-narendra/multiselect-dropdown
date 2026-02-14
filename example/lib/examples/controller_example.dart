import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Recipe ingredient selector with programmatic controller actions.
///
/// Demonstrates all [MultiSelectController] methods in a realistic
/// cooking/meal planning scenario.
class ControllerExample extends StatefulWidget {
  const ControllerExample({super.key});

  @override
  State<ControllerExample> createState() => _ControllerExampleState();
}

class _ControllerExampleState extends State<ControllerExample> {
  final _controller = MultiSelectController<String>();
  int _customCounter = 0;

  final _items = [
    DropdownItem(label: '🧅 Onion', value: 'onion'),
    DropdownItem(label: '🍅 Tomato', value: 'tomato'),
    DropdownItem(label: '🧄 Garlic', value: 'garlic'),
    DropdownItem(label: '🫑 Bell Pepper', value: 'bell_pepper'),
    DropdownItem(label: '🥕 Carrot', value: 'carrot'),
    DropdownItem(label: '🥔 Potato', value: 'potato'),
    DropdownItem(label: '🌶️ Chili', value: 'chili'),
    DropdownItem(label: '🍄 Mushroom', value: 'mushroom'),
    DropdownItem(label: '🥦 Broccoli', value: 'broccoli'),
    DropdownItem(label: '🌽 Corn', value: 'corn'),
  ];

  static const _customIngredients = [
    '🧂 Salt',
    '🫒 Olive Oil',
    '🧈 Butter',
    '🍋 Lemon',
    '🌿 Basil',
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
        title: const Text('Recipe Ingredients'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.teal.withAlpha(40),
                  Colors.green.withAlpha(30),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.restaurant_rounded, color: Colors.teal),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Select ingredients for your recipe. Use the '
                    'controller buttons below to manage selection.',
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
          MultiDropdown<String>(
            items: _items,
            controller: _controller,
            chipDecoration: ChipDecoration(
              backgroundColor: Colors.teal.shade50,
              labelStyle: TextStyle(
                color: Colors.teal.shade800,
                fontSize: 13,
              ),
              borderRadius: BorderRadius.circular(20),
              deleteIcon: Icon(
                Icons.close_rounded,
                size: 14,
                color: Colors.teal.shade400,
              ),
              wrap: true,
              spacing: 8,
              runSpacing: 8,
            ),
            fieldDecoration: FieldDecoration(
              hintText: 'Select ingredients',
              prefixIcon: Icon(
                Icons.egg_outlined,
                color: Colors.teal.shade400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.teal.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.teal.shade400,
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
            'Quick Actions',
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
                icon: Icons.restaurant_menu_rounded,
                label: 'Common (first 4)',
                color: Colors.orange,
                onTap: () {
                  _controller.clearAll();
                  _controller.selectWhere(
                    (item) => ['onion', 'tomato', 'garlic', 'bell_pepper']
                        .contains(item.value),
                  );
                },
              ),
              _ActionChip(
                icon: Icons.looks_one_outlined,
                label: 'Select First',
                color: Colors.teal,
                onTap: () => _controller.selectAtIndex(0),
              ),
              _ActionChip(
                icon: Icons.arrow_drop_down_circle_outlined,
                label: 'Open',
                color: Colors.blue,
                onTap: () => _controller.openDropdown(),
              ),
              _ActionChip(
                icon: Icons.arrow_drop_up_outlined,
                label: 'Close',
                color: Colors.blueGrey,
                onTap: () => _controller.closeDropdown(),
              ),
              _ActionChip(
                icon: Icons.add_circle_outline,
                label: 'Add Ingredient',
                color: Colors.purple,
                onTap: () {
                  final name = _customIngredients[
                      _customCounter % _customIngredients.length];
                  _customCounter++;
                  _controller.addItem(
                    DropdownItem(
                      label: name,
                      value: 'custom_$_customCounter',
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
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
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
      ),
    );
  }
}
