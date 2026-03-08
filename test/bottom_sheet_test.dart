import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

void main() {
  group('Bottom Sheet Mode', () {
    // =========================================================================
    // Default mode is overlay
    // =========================================================================

    testWidgets('default dropdownMode is overlay', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: createItems(), controller: controller),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // In overlay mode, items appear in overlay — no bottom sheet
      expect(find.byType(BottomSheet), findsNothing);
      expect(find.text('Item 1'), findsOneWidget);

      controller.dispose();
    });

    // =========================================================================
    // Bottom sheet mode opens a modal
    // =========================================================================

    testWidgets('bottom sheet mode opens a modal bottom sheet', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(3),
            dropdownMode: DropdownMode.bottomSheet,
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Items should be visible inside the bottom sheet
      expect(find.widgetWithText(ListTile, 'Item 1'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Item 2'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Item 3'), findsOneWidget);

      controller.dispose();
    });

    // =========================================================================
    // Selection works in bottom sheet
    // =========================================================================

    testWidgets('selecting items works in bottom sheet mode', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(3),
            dropdownMode: DropdownMode.bottomSheet,
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ListTile, 'Item 1'));
      await tester.pumpAndSettle();

      expect(controller.selectedItems.length, 1);
      expect(controller.selectedItems.first.label, 'Item 1');

      controller.dispose();
    });

    // =========================================================================
    // Title shown from labelText
    // =========================================================================

    testWidgets('bottom sheet shows title from fieldDecoration.labelText',
        (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            dropdownMode: DropdownMode.bottomSheet,
            controller: controller,
            fieldDecoration: const FieldDecoration(
              labelText: 'Select Items',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(find.text('Select Items'), findsWidgets);

      controller.dispose();
    });

    // =========================================================================
    // Drag handle is visible
    // =========================================================================

    testWidgets('bottom sheet has a drag handle', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            dropdownMode: DropdownMode.bottomSheet,
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // The drag handle is a Container with a specific width
      final dragHandle = find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.constraints != null &&
            w.constraints!.maxWidth == 40 &&
            w.constraints!.maxHeight == 4,
      );
      expect(dragHandle, findsOneWidget);

      controller.dispose();
    });
  });
}
