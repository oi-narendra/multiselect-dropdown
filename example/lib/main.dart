import 'package:flutter/material.dart';

import 'examples/accessibility_example.dart';
import 'examples/basic_example.dart';
import 'examples/controller_example.dart';
import 'examples/custom_style_example.dart';
import 'examples/form_validation_example.dart';
import 'examples/future_example.dart';
import 'examples/searchable_example.dart';
import 'examples/single_select_example.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MultiDropdown Examples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6366F1),
        useMaterial3: true,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF6366F1),
        useMaterial3: true,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  static const _examples = <_ExampleEntry>[
    _ExampleEntry(
      title: 'Country Picker',
      subtitle: 'Basic multi-select with flag emojis',
      icon: Icons.public_rounded,
      color: Color(0xFF6366F1),
      builder: BasicExample.new,
    ),
    _ExampleEntry(
      title: 'Task Priority',
      subtitle: 'Single-select with color-coded result',
      icon: Icons.flag_rounded,
      color: Color(0xFFEC4899),
      builder: SingleSelectExample.new,
    ),
    _ExampleEntry(
      title: 'Team Members',
      subtitle: 'Search with custom item builder',
      icon: Icons.group_add_rounded,
      color: Color(0xFF14B8A6),
      builder: SearchableExample.new,
    ),
    _ExampleEntry(
      title: 'Issue Labels',
      subtitle: 'Custom chip styles & overflow',
      icon: Icons.label_rounded,
      color: Color(0xFFF59E0B),
      builder: CustomStyleExample.new,
    ),
    _ExampleEntry(
      title: 'Recipe Ingredients',
      subtitle: 'Controller actions & programmatic control',
      icon: Icons.restaurant_rounded,
      color: Color(0xFF10B981),
      builder: ControllerExample.new,
    ),
    _ExampleEntry(
      title: 'Job Application',
      subtitle: 'Form validation & max selections',
      icon: Icons.work_outline_rounded,
      color: Color(0xFF4F46E5),
      builder: FormValidationExample.new,
    ),
    _ExampleEntry(
      title: 'Async Loading',
      subtitle: 'Fetch items from a Future',
      icon: Icons.cloud_download_rounded,
      color: Color(0xFF06B6D4),
      builder: FutureExample.new,
    ),
    _ExampleEntry(
      title: 'Accessibility',
      subtitle: 'Font scaling & high contrast',
      icon: Icons.accessibility_new_rounded,
      color: Color(0xFF8B5CF6),
      builder: AccessibilityExample.new,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final crossAxisCount = screenWidth >= 600 ? 2 : 1;
    final isWide = crossAxisCount == 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MultiDropdown'),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Text(
              'Examples',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Text(
              'Real-world use cases showcasing features of the '
              'multi_dropdown package.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: isWide ? 2.8 : 3.4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _examples.length,
              itemBuilder: (context, index) {
                final example = _examples[index];
                return _ExampleCard(example: example);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleEntry {
  const _ExampleEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.builder,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget Function({Key? key}) builder;
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.example});

  final _ExampleEntry example;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      button: true,
      label: '${example.title} example: ${example.subtitle}',
      child: Card(
        elevation: 0,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outlineVariant.withAlpha(120),
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => example.builder(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: example.color.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    example.icon,
                    color: example.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        example.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        example.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant.withAlpha(120),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
