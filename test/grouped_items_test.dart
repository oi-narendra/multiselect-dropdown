import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

void main() {
  group('Grouped Items', () {
    // =========================================================================
    // DropdownGroup model
    // =========================================================================

    test('DropdownGroup equality', () {
      final g1 = DropdownGroup(
        label: 'Fruits',
        items: [DropdownItem(label: 'Apple', value: 1)],
      );
      final g2 = DropdownGroup(
        label: 'Fruits',
        items: [DropdownItem(label: 'Apple', value: 1)],
      );
      expect(g1, equals(g2));
    });

    test('DropdownGroup copyWith', () {
      final g = DropdownGroup(
        label: 'Fruits',
        items: [DropdownItem(label: 'Apple', value: 1)],
      );
      final copy = g.copyWith(label: 'Veggies');
      expect(copy.label, 'Veggies');
      expect(copy.items.length, 1);
    });

    test('DropdownGroup toString contains label', () {
      final g = DropdownGroup<int>(label: 'Fruits', items: const []);
      expect(g.toString(), contains('Fruits'));
    });

    // =========================================================================
    // Widget rendering — group headers
    // =========================================================================

    testWidgets('renders group headers when groups are provided',
        (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: const [],
            groups: [
              DropdownGroup(
                label: 'Fruits',
                items: [
                  DropdownItem(label: 'Apple', value: 1),
                  DropdownItem(label: 'Banana', value: 2),
                ],
              ),
              DropdownGroup(
                label: 'Vegetables',
                items: [
                  DropdownItem(label: 'Carrot', value: 3),
                ],
              ),
            ],
            controller: controller,
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Group headers should be visible
      expect(find.text('Fruits'), findsOneWidget);
      expect(find.text('Vegetables'), findsOneWidget);

      // Items should be visible
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Carrot'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('items without groups renders flat list (backward compat)',
        (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(3),
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
      controller.dispose();
    });

    // =========================================================================
    // Selection works within groups
    // =========================================================================

    testWidgets('selecting items in groups works', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: const [],
            groups: [
              DropdownGroup(
                label: 'Fruits',
                items: [
                  DropdownItem(label: 'Apple', value: 1),
                  DropdownItem(label: 'Banana', value: 2),
                ],
              ),
              DropdownGroup(
                label: 'Vegetables',
                items: [
                  DropdownItem(label: 'Carrot', value: 3),
                ],
              ),
            ],
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Apple'));
      await tester.pumpAndSettle();

      expect(controller.selectedItems.length, 1);
      expect(controller.selectedItems.first.label, 'Apple');

      await tester.tap(find.text('Carrot'));
      await tester.pumpAndSettle();

      expect(controller.selectedItems.length, 2);
      controller.dispose();
    });

    // =========================================================================
    // Controller selectAll works across groups
    // =========================================================================

    testWidgets('controller selectAll works with groups', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: const [],
            groups: [
              DropdownGroup(
                label: 'Fruits',
                items: [
                  DropdownItem(label: 'Apple', value: 1),
                ],
              ),
              DropdownGroup(
                label: 'Vegetables',
                items: [
                  DropdownItem(label: 'Carrot', value: 2),
                ],
              ),
            ],
            controller: controller,
          ),
        ),
      );

      controller.selectAll();
      await tester.pumpAndSettle();

      expect(controller.selectedItems.length, 2);
      controller.dispose();
    });

    // =========================================================================
    // Search hides empty groups
    // =========================================================================

    testWidgets('search hides empty groups', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: const [],
            groups: [
              DropdownGroup(
                label: 'Fruits',
                items: [
                  DropdownItem(label: 'Apple', value: 1),
                  DropdownItem(label: 'Banana', value: 2),
                ],
              ),
              DropdownGroup(
                label: 'Vegetables',
                items: [
                  DropdownItem(label: 'Carrot', value: 3),
                ],
              ),
            ],
            controller: controller,
            searchEnabled: true,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Search for "Apple" — "Vegetables" group should be hidden
      await tester.enterText(find.byType(TextField), 'Apple');
      await tester.pumpAndSettle();

      expect(find.text('Fruits'), findsOneWidget);
      // 'Apple' appears in both the search TextField and the dropdown item
      expect(find.widgetWithText(ListTile, 'Apple'), findsOneWidget);
      expect(find.text('Vegetables'), findsNothing);
      expect(find.widgetWithText(ListTile, 'Carrot'), findsNothing);

      controller.dispose();
    });

    // =========================================================================
    // Dividers between groups
    // =========================================================================

    testWidgets('divider appears between groups by default', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: const [],
            groups: [
              DropdownGroup(
                label: 'Group A',
                items: [DropdownItem(label: 'A1', value: 1)],
              ),
              DropdownGroup(
                label: 'Group B',
                items: [DropdownItem(label: 'B1', value: 2)],
              ),
            ],
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Divider should exist between groups
      expect(find.byType(Divider), findsOneWidget);

      controller.dispose();
    });

    testWidgets('divider hidden when showDivider is false', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: const [],
            groups: [
              DropdownGroup(
                label: 'Group A',
                items: [DropdownItem(label: 'A1', value: 1)],
              ),
              DropdownGroup(
                label: 'Group B',
                items: [DropdownItem(label: 'B1', value: 2)],
              ),
            ],
            controller: controller,
            groupHeaderDecoration: const GroupHeaderDecoration(
              showDivider: false,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsNothing);

      controller.dispose();
    });
  });
}
