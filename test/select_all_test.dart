import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

void main() {
  group('Select All / Deselect All', () {
    // =========================================================================
    // Toggle visibility
    // =========================================================================

    testWidgets('select all toggle is hidden by default', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: createItems(), controller: controller),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Select All'), findsNothing);
      controller.dispose();
    });

    testWidgets('select all toggle appears when showSelectAll is true',
        (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            showSelectAll: true,
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Select All'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('select all toggle is hidden in single-select mode',
        (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            showSelectAll: true,
            singleSelect: true,
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Select All'), findsNothing);
      controller.dispose();
    });

    // =========================================================================
    // Select all behavior
    // =========================================================================

    testWidgets('tapping select all selects all items', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(3),
            showSelectAll: true,
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(controller.selectedItems.length, 0);
      await tester.tap(find.text('Select All'));
      await tester.pumpAndSettle();

      expect(controller.selectedItems.length, 3);
      controller.dispose();
    });

    testWidgets('tapping deselect all clears all items', (tester) async {
      final controller = MultiSelectController<int>();
      final items = List.generate(
        3,
        (i) => DropdownItem(
          label: 'Item ${i + 1}',
          value: i + 1,
          selected: true,
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: items,
            showSelectAll: true,
            controller: controller,
          ),
        ),
      );

      // Use .first to target the field InkWell (not chip InkWells)
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      expect(controller.selectedItems.length, 3);
      expect(find.text('Deselect All'), findsOneWidget);

      await tester.tap(find.text('Deselect All'));
      await tester.pumpAndSettle();

      expect(controller.selectedItems.length, 0);
      controller.dispose();
    });

    // =========================================================================
    // Custom labels
    // =========================================================================

    testWidgets('custom labels from DropdownDecoration are used',
        (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            showSelectAll: true,
            controller: controller,
            dropdownDecoration: const DropdownDecoration(
              selectAllText: 'Check All',
              deselectAllText: 'Uncheck All',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Check All'), findsOneWidget);
      expect(find.text('Select All'), findsNothing);
      controller.dispose();
    });

    // =========================================================================
    // Checkbox state
    // =========================================================================

    testWidgets('checkbox reflects all-selected state', (tester) async {
      final controller = MultiSelectController<int>();
      final items = List.generate(
        2,
        (i) => DropdownItem(
          label: 'Item ${i + 1}',
          value: i + 1,
          selected: true,
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: items,
            showSelectAll: true,
            controller: controller,
          ),
        ),
      );

      // Use .first to target the field InkWell (not chip InkWells)
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true);
      controller.dispose();
    });
  });
}
