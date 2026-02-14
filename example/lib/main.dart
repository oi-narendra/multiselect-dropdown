import 'package:flutter/material.dart';

import 'examples/basic_example.dart';
import 'examples/controller_example.dart';
import 'examples/custom_style_example.dart';
import 'examples/form_validation_example.dart';
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
        colorSchemeSeed: const Color(0xFF6750A4),
        useMaterial3: true,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF6750A4),
        useMaterial3: true,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final examples = <_ExampleEntry>[
      _ExampleEntry(
        title: 'Basic Multi-Select',
        subtitle: 'Select multiple items with chips',
        icon: Icons.checklist_rounded,
        gradient: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
        builder: (_) => const BasicExample(),
      ),
      _ExampleEntry(
        title: 'Single Select',
        subtitle: 'Pick exactly one item',
        icon: Icons.touch_app_rounded,
        gradient: [const Color(0xFFF093FB), const Color(0xFFF5576C)],
        builder: (_) => const SingleSelectExample(),
      ),
      _ExampleEntry(
        title: 'Searchable',
        subtitle: 'Filter items by typing',
        icon: Icons.search_rounded,
        gradient: [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
        builder: (_) => const SearchableExample(),
      ),
      _ExampleEntry(
        title: 'Custom Styling',
        subtitle: 'Chips, borders, colors & disabled items',
        icon: Icons.palette_rounded,
        gradient: [const Color(0xFFF6D365), const Color(0xFFFDA085)],
        builder: (_) => const CustomStyleExample(),
      ),
      _ExampleEntry(
        title: 'Controller Actions',
        subtitle: 'Programmatic control via controller',
        icon: Icons.tune_rounded,
        gradient: [const Color(0xFF89F7FE), const Color(0xFF66A6FF)],
        builder: (_) => const ControllerExample(),
      ),
      _ExampleEntry(
        title: 'Form Validation',
        subtitle: 'Form integration with validators',
        icon: Icons.verified_rounded,
        gradient: [const Color(0xFF38F9D7), const Color(0xFF43E97B)],
        builder: (_) => const FormValidationExample(),
      ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar.large(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                'MultiDropdown',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primaryContainer.withAlpha(100),
                      colorScheme.surface,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60, right: 24),
                    child: Icon(
                      Icons.widgets_rounded,
                      size: 80,
                      color: colorScheme.primary.withAlpha(30),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Subtitle
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Text(
                'Explore different use cases and customization options.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          // Example cards grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.95,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _ExampleCard(entry: examples[index]),
                childCount: examples.length,
              ),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
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
    required this.gradient,
    required this.builder,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final WidgetBuilder builder;
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.entry});

  final _ExampleEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant.withAlpha(80),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: entry.builder),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gradient header with icon
            Container(
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: entry.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Decorative circles
                  Positioned(
                    top: -10,
                    right: -10,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(20),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -15,
                    left: -15,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(15),
                      ),
                    ),
                  ),
                  // Icon
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        entry.icon,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Text content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
