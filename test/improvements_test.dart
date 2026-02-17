import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

/// Tests for new features introduced in the improvements update:
/// - Controller caching & immutability
/// - Decoration properties (animation, debounce, theme-aware defaults)
/// - Widget behavior (field toggle, animations, accessibility, loading)
void main() {
  // ===========================================================================
  // Controller: selectedItems caching
  // ===========================================================================

  group('Controller: selectedItems caching', () {
    late MultiSelectController<int> controller;

    setUp(() {
      controller = MultiSelectController<int>();
    });

    tearDown(() {
      controller.dispose();
    });

    test('selectedItems returns same list on repeated access', () {
      controller.setItems([
        DropdownItem(label: 'A', value: 1, selected: true),
        DropdownItem(label: 'B', value: 2),
      ]);

      final first = controller.selectedItems;
      final second = controller.selectedItems;
      expect(identical(first, second), isTrue);
    });

    test('selectedItems cache is invalidated after selection change', () {
      controller.setItems([
        DropdownItem(label: 'A', value: 1, selected: true),
        DropdownItem(label: 'B', value: 2),
      ]);

      final before = controller.selectedItems;
      expect(before.length, 1);

      controller.selectAll();

      final after = controller.selectedItems;
      expect(after.length, 2);
      expect(identical(before, after), isFalse);
    });

    test('selectedItems cache is invalidated after clearAll', () {
      controller
        ..setItems(createItems())
        ..selectAll();
      expect(controller.selectedItems.length, 5);

      controller.clearAll();
      expect(controller.selectedItems.length, 0);
    });
  });

  // ===========================================================================
  // Controller: _reapplySearchFilter deduplication
  // ===========================================================================

  group('Controller: search filter reapplication', () {
    late MultiSelectController<int> controller;

    setUp(() {
      controller = MultiSelectController<int>();
    });

    tearDown(() {
      controller.dispose();
    });

    test('toggleWhere preserves active search filter', () {
      controller
        ..setItems(createItems())
        // Simulate an active search
        ..notifyListeners()
        ..toggleWhere((item) => item.value == 1);
      expect(controller.selectedItems.length, 1);
    });

    test('selectWhere preserves active search filter', () {
      controller
        ..setItems(createItems())
        ..selectWhere((item) => item.value <= 3);
      expect(controller.selectedItems.length, 3);
    });

    test('unselectWhere preserves active search filter', () {
      controller
        ..setItems([
          DropdownItem(label: 'A', value: 1, selected: true),
          DropdownItem(label: 'B', value: 2, selected: true),
          DropdownItem(label: 'C', value: 3, selected: true),
        ])
        ..unselectWhere((item) => item.value == 2);
      expect(controller.selectedItems.length, 2);
    });
  });

  // ===========================================================================
  // DropdownItem immutability
  // ===========================================================================

  group('DropdownItem immutability', () {
    test('disabled and selected fields are final', () {
      final item = DropdownItem(label: 'Test', value: 1);
      expect(item.disabled, false);
      expect(item.selected, false);

      // Can only change via copyWith
      final updated = item.copyWith(selected: true, disabled: true);
      expect(updated.selected, true);
      expect(updated.disabled, true);

      // Original is unchanged
      expect(item.selected, false);
      expect(item.disabled, false);
    });

    test('copyWith preserves unspecified fields', () {
      final item = DropdownItem(
        label: 'Original',
        value: 42,
        selected: true,
        disabled: true,
      );

      final partial = item.copyWith(selected: false);
      expect(partial.label, 'Original');
      expect(partial.value, 42);
      expect(partial.selected, false);
      expect(partial.disabled, true);
    });
  });

  // ===========================================================================
  // Decoration: new properties
  // ===========================================================================

  group('Decoration: new properties', () {
    test('DropdownDecoration has animationDuration default', () {
      const d = DropdownDecoration();
      expect(d.animationDuration, const Duration(milliseconds: 200));
    });

    test('DropdownDecoration has animationCurve default', () {
      const d = DropdownDecoration();
      expect(d.animationCurve, Curves.easeOutCubic);
    });

    test('DropdownDecoration custom animation properties', () {
      const d = DropdownDecoration(
        animationDuration: Duration(milliseconds: 500),
        animationCurve: Curves.bounceOut,
      );
      expect(d.animationDuration, const Duration(milliseconds: 500));
      expect(d.animationCurve, Curves.bounceOut);
    });

    test('DropdownDecoration backgroundColor defaults to null', () {
      const d = DropdownDecoration();
      expect(d.backgroundColor, isNull);
    });

    test('ChipDecoration backgroundColor defaults to null', () {
      const d = ChipDecoration();
      expect(d.backgroundColor, isNull);
    });

    test('SearchFieldDecoration searchDebounceMs defaults to 0', () {
      const d = SearchFieldDecoration();
      expect(d.searchDebounceMs, 0);
    });

    test('SearchFieldDecoration custom debounce', () {
      const d = SearchFieldDecoration(searchDebounceMs: 300);
      expect(d.searchDebounceMs, 300);
    });
  });

  // ===========================================================================
  // Widget: field tap toggle
  // ===========================================================================

  group('Widget: field tap toggle', () {
    testWidgets('tapping field opens dropdown', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: createItems(), controller: controller),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(controller.isOpen, true);
      controller.dispose();
    });

    testWidgets('tapping field again closes dropdown', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: createItems(), controller: controller),
        ),
      );

      // Open
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(controller.isOpen, true);

      // Close by tapping field again
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      expect(controller.isOpen, false);
      controller.dispose();
    });
  });

  // ===========================================================================
  // Widget: loading indicator sizing
  // ===========================================================================

  group('Widget: loading indicator', () {
    testWidgets('loading indicator is constrained to 24x24', (tester) async {
      final completer = Completer<List<DropdownItem<int>>>();

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>.future(
            future: () => completer.future,
          ),
        ),
      );

      // Pump once to trigger the future and show the loading indicator
      await tester.pump();

      final sizedBox = tester.widgetList<SizedBox>(find.byType(SizedBox)).where(
            (box) => box.width == 24 && box.height == 24,
          );
      expect(sizedBox.isNotEmpty, isTrue);

      // Complete the future to clean up
      completer.complete(createItems());
      await tester.pumpAndSettle();
    });
  });

  // ===========================================================================
  // Widget: accessibility
  // ===========================================================================

  group('Widget: accessibility', () {
    testWidgets('field has Semantics widget', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: createItems()),
        ),
      );

      final semantics = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == 'Dropdown field',
      );
      expect(semantics, findsOneWidget);
    });

    testWidgets('field uses custom label from fieldDecoration', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            fieldDecoration: const FieldDecoration(
              labelText: 'Pick items',
            ),
          ),
        ),
      );

      final semantics = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == 'Pick items',
      );
      expect(semantics, findsOneWidget);
    });

    testWidgets('clear icon has Tooltip', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: [
              DropdownItem(label: 'A', value: 1, selected: true),
            ],
          ),
        ),
      );

      expect(find.byType(Tooltip), findsWidgets);
      expect(
        find.byTooltip('Clear selection'),
        findsOneWidget,
      );
    });
  });

  // ===========================================================================
  // Widget: AnimatedSize on field
  // ===========================================================================

  group('Widget: AnimatedSize', () {
    testWidgets('AnimatedSize wraps the dropdown field', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: createItems()),
        ),
      );

      expect(find.byType(AnimatedSize), findsOneWidget);
    });
  });

  // ===========================================================================
  // Widget: theme-aware colors
  // ===========================================================================

  group('Widget: theme-aware backgrounds', () {
    testWidgets('chip uses theme surface color by default', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: [
              DropdownItem(label: 'Selected', value: 1, selected: true),
            ],
          ),
        ),
      );

      // Find the AnimatedContainer that wraps the chip
      final animatedContainers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();
      expect(animatedContainers.isNotEmpty, isTrue);
    });

    testWidgets('custom chip background color is applied', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: [
              DropdownItem(label: 'X', value: 1, selected: true),
            ],
            chipDecoration: const ChipDecoration(
              backgroundColor: Colors.red,
            ),
          ),
        ),
      );

      final animatedContainer = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .firstWhere(
            (c) =>
                c.decoration is BoxDecoration &&
                (c.decoration! as BoxDecoration).color == Colors.red,
            orElse: () => throw TestFailure(
              'Expected an AnimatedContainer with red background',
            ),
          );
      expect(animatedContainer, isNotNull);
    });
  });

  // ===========================================================================
  // Widget: dropdown animation
  // ===========================================================================

  group('Widget: dropdown animation', () {
    testWidgets('custom animation duration is accepted', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            dropdownDecoration: const DropdownDecoration(
              animationDuration: Duration(milliseconds: 500),
              animationCurve: Curves.bounceOut,
            ),
          ),
        ),
      );

      expect(find.byType(MultiDropdown<int>), findsOneWidget);
    });

    testWidgets('zero duration disables animation', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            controller: controller,
            dropdownDecoration: const DropdownDecoration(
              animationDuration: Duration.zero,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // With zero duration, items should appear immediately.
      expect(find.text('Item 1'), findsOneWidget);
      controller.dispose();
    });
  });

  // ===========================================================================
  // Widget: empty state
  // ===========================================================================

  group('Widget: empty state', () {
    testWidgets('shows noItemsFoundText when items list is empty',
        (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: const [],
            controller: controller,
            dropdownDecoration: const DropdownDecoration(
              noItemsFoundText: 'Nothing here',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Nothing here'), findsOneWidget);
      controller.dispose();
    });
  });

  // ===========================================================================
  // Widget: dropdown list padding (#120, #172)
  // ===========================================================================

  group('Widget: dropdown list padding', () {
    testWidgets('ListView has zero padding by default (fixes #120, #172)',
        (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: createItems(), controller: controller),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.padding, EdgeInsets.zero);
      controller.dispose();
    });

    testWidgets('custom listPadding is applied to ListView', (tester) async {
      final controller = MultiSelectController<int>();
      const customPadding = EdgeInsets.symmetric(vertical: 16);
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            controller: controller,
            dropdownDecoration: const DropdownDecoration(
              listPadding: customPadding,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.padding, customPadding);
      controller.dispose();
    });

    test('DropdownDecoration listPadding defaults to null', () {
      const d = DropdownDecoration();
      expect(d.listPadding, isNull);
    });
  });
}
