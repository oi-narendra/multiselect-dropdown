import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

void main() {
  group('Custom Search Filter', () {
    // =========================================================================
    // Default search still works
    // =========================================================================

    testWidgets('default search filters by label contains', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(5),
            searchEnabled: true,
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Item 3');
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, 'Item 3'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Item 1'), findsNothing);

      controller.dispose();
    });

    // =========================================================================
    // Custom filter is used
    // =========================================================================

    testWidgets('custom searchFilter overrides default logic', (tester) async {
      final controller = MultiSelectController<int>();
      // Custom filter: only match items where label STARTS WITH query
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: [
              DropdownItem(label: 'Apple Pie', value: 1),
              DropdownItem(label: 'Pineapple', value: 2),
              DropdownItem(label: 'Banana', value: 3),
            ],
            searchEnabled: true,
            searchFilter: (query, items) {
              return items
                  .where(
                    (i) => i.label.toLowerCase().startsWith(query.toLowerCase()),
                  )
                  .toList();
            },
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // "apple" should match "Apple Pie" but NOT "Pineapple" (startsWith)
      await tester.enterText(find.byType(TextField), 'apple');
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, 'Apple Pie'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Pineapple'), findsNothing);
      expect(find.widgetWithText(ListTile, 'Banana'), findsNothing);

      controller.dispose();
    });

    testWidgets('custom filter returns empty shows no items found',
        (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(3),
            searchEnabled: true,
            searchFilter: (query, items) => [], // always empty
            controller: controller,
            dropdownDecoration: const DropdownDecoration(
              noItemsFoundText: 'Nothing matches',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();

      expect(find.text('Nothing matches'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('null searchFilter uses default contains logic',
        (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: [
              DropdownItem(label: 'Apple Pie', value: 1),
              DropdownItem(label: 'Pineapple', value: 2),
            ],
            searchEnabled: true,
            // searchFilter is null — default contains should work
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // "apple" should match both "Apple Pie" AND "Pineapple" (contains)
      await tester.enterText(find.byType(TextField), 'apple');
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, 'Apple Pie'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Pineapple'), findsOneWidget);

      controller.dispose();
    });

    // =========================================================================
    // Custom filter receives correct arguments
    // =========================================================================

    testWidgets('custom filter receives full items list and query',
        (tester) async {
      final controller = MultiSelectController<int>();
      String? capturedQuery;
      int? capturedItemCount;

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(5),
            searchEnabled: true,
            searchFilter: (query, items) {
              capturedQuery = query;
              capturedItemCount = items.length;
              return items; // return all
            },
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pumpAndSettle();

      expect(capturedQuery, 'hello');
      expect(capturedItemCount, 5);

      controller.dispose();
    });
  });
}
