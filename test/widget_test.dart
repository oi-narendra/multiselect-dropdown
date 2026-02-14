import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

void main() {
  group('MultiDropdown Widget', () {
    // --- #158: Cursor should be click, not grab ---

    testWidgets('uses click cursor when enabled', (tester) async {
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(items: createItems()),
      ));

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.mouseCursor, SystemMouseCursors.click);
    });

    testWidgets('uses forbidden cursor when disabled', (tester) async {
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(items: createItems(), enabled: false),
      ));

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.mouseCursor, SystemMouseCursors.forbidden);
    });

    // --- #173/#174: Disabled state prevents interaction ---

    testWidgets('tapping disabled dropdown does nothing', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: createItems(),
          enabled: false,
          controller: controller,
        ),
      ));

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(controller.isOpen, false);
      controller.dispose();
    });

    // --- #137/#195: Single-select text styling ---

    testWidgets('applies selectedItemTextStyle in single-select mode',
        (tester) async {
      const textStyle = TextStyle(
        fontSize: 20,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      );

      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: [
            DropdownItem(label: 'Selected Item', value: 1, selected: true),
          ],
          singleSelect: true,
          fieldDecoration: const FieldDecoration(
            selectedItemTextStyle: textStyle,
          ),
        ),
      ));

      final textWidget = tester.widget<Text>(find.text('Selected Item'));
      expect(textWidget.style?.fontSize, 20);
      expect(textWidget.style?.color, Colors.red);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });

    // --- #201: Customizable noItemsFoundText ---

    testWidgets('shows custom noItemsFoundText', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: const [],
          controller: controller,
          searchEnabled: true,
          dropdownDecoration: const DropdownDecoration(
            noItemsFoundText: 'Nothing here!',
          ),
        ),
      ));

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Nothing here!'), findsOneWidget);
      controller.dispose();
    });

    // --- #141/#150: InputDecoration override ---

    testWidgets('uses custom inputDecoration when provided', (tester) async {
      const customDecoration = InputDecoration(
        labelText: 'Custom Label',
        hintText: 'Custom Hint',
        border: OutlineInputBorder(),
      );

      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: createItems(),
          fieldDecoration: const FieldDecoration(
            inputDecoration: customDecoration,
          ),
        ),
      ));

      expect(find.text('Custom Label'), findsOneWidget);
      expect(find.text('Custom Hint'), findsOneWidget);
    });

    // --- #194/#187: Chip overflow with maxDisplayCount ---

    testWidgets('shows +N more label when maxDisplayCount exceeded',
        (tester) async {
      final items = List.generate(
        5,
        (i) => DropdownItem(
          label: 'Chip ${i + 1}',
          value: i + 1,
          selected: true,
        ),
      );

      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: items,
          chipDecoration: const ChipDecoration(maxDisplayCount: 2),
        ),
      ));

      expect(find.text('Chip 1'), findsOneWidget);
      expect(find.text('Chip 2'), findsOneWidget);
      expect(find.text('Chip 3'), findsNothing);
      expect(find.text('+3 more'), findsOneWidget);
    });

    // --- #170: selectedItemBuilder respects wrap ---

    testWidgets('selectedItemBuilder uses wrap layout when wrap is true',
        (tester) async {
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: [
            DropdownItem(label: 'Item 1', value: 1, selected: true),
            DropdownItem(label: 'Item 2', value: 2, selected: true),
          ],
          selectedItemBuilder: (item) => Chip(label: Text(item.label)),
        ),
      ));

      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('selectedItemBuilder uses ListView when wrap is false',
        (tester) async {
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: [
            DropdownItem(label: 'Item 1', value: 1, selected: true),
            DropdownItem(label: 'Item 2', value: 2, selected: true),
          ],
          selectedItemBuilder: (item) => Chip(label: Text(item.label)),
          chipDecoration: const ChipDecoration(wrap: false),
        ),
      ));

      expect(find.byType(ListView), findsOneWidget);
    });

    // --- #136: Dropdown opens on tap ---

    testWidgets('opens dropdown on tap', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: createItems(),
          controller: controller,
        ),
      ));

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(controller.isOpen, true);
      controller.dispose();
    });

    // --- #147/#210: ExpandDirection ---

    testWidgets('renders with expandDirection auto', (tester) async {
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(items: createItems()),
      ));
      expect(find.byType(MultiDropdown<int>), findsOneWidget);
    });

    testWidgets('renders with expandDirection down', (tester) async {
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: createItems(),
          dropdownDecoration: const DropdownDecoration(
            expandDirection: ExpandDirection.down,
          ),
        ),
      ));
      expect(find.byType(MultiDropdown<int>), findsOneWidget);
    });

    testWidgets('renders with expandDirection up', (tester) async {
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: createItems(),
          dropdownDecoration: const DropdownDecoration(
            expandDirection: ExpandDirection.up,
          ),
        ),
      ));
      expect(find.byType(MultiDropdown<int>), findsOneWidget);
    });

    // --- #199/#200: Widget? icon types ---

    testWidgets('accepts Widget for selectedIcon and disabledIcon',
        (tester) async {
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: createItems(),
          dropdownItemDecoration: const DropdownItemDecoration(
            selectedIcon: Icon(Icons.check_circle, color: Colors.green),
            disabledIcon: Icon(Icons.block, color: Colors.red),
          ),
        ),
      ));
      expect(find.byType(MultiDropdown<int>), findsOneWidget);
    });

    // --- Basic rendering tests ---

    testWidgets('renders with default parameters', (tester) async {
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(items: createItems()),
      ));
      expect(find.byType(MultiDropdown<int>), findsOneWidget);
    });

    testWidgets('shows hint text when nothing is selected', (tester) async {
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: createItems(),
          fieldDecoration: const FieldDecoration(hintText: 'Select items'),
        ),
      ));
      expect(find.text('Select items'), findsOneWidget);
    });

    testWidgets('shows label text', (tester) async {
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: createItems(),
          fieldDecoration: const FieldDecoration(labelText: 'My Dropdown'),
        ),
      ));
      expect(find.text('My Dropdown'), findsOneWidget);
    });

    // --- Single-select mode behavior ---

    testWidgets('auto-closes dropdown in single-select mode', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: createItems(),
          singleSelect: true,
          controller: controller,
        ),
      ));

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(controller.isOpen, true);

      await tester.tap(find.text('Item 1'));
      await tester.pumpAndSettle();

      expect(controller.isOpen, false);
      expect(controller.selectedItems.length, 1);
      controller.dispose();
    });

    // --- #155/#152/#160/#165/#206: Search functionality ---

    testWidgets('search field filters items', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: createItems(),
          searchEnabled: true,
          controller: controller,
        ),
      ));

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Item 1');
      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsWidgets);
      expect(find.text('Item 2'), findsNothing);
      controller.dispose();
    });

    testWidgets('search field renders with custom decoration', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: createItems(),
          searchEnabled: true,
          controller: controller,
          searchDecoration: SearchFieldDecoration(
            hintText: 'Search here...',
            textStyle: const TextStyle(fontSize: 18),
            fillColor: Colors.grey.shade100,
            filled: true,
          ),
        ),
      ));

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Search here...'), findsOneWidget);
      controller.dispose();
    });

    // --- #175/#197: Dropdown item text styles ---

    testWidgets('dropdown items render with custom textStyle', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: createItems(3),
          controller: controller,
          dropdownItemDecoration: const DropdownItemDecoration(
            textStyle: TextStyle(fontSize: 20, color: Colors.blue),
          ),
        ),
      ));

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      controller.dispose();
    });

    // --- Multi-select validation ---

    testWidgets('accepts validator callback', (tester) async {
      await tester.pumpWidget(buildTestApp(
        MultiDropdown<int>(
          items: createItems(),
          validator: (items) {
            if (items == null || items.isEmpty) {
              return 'Required';
            }
            return null;
          },
        ),
      ));

      expect(find.byType(MultiDropdown<int>), findsOneWidget);
    });
  });
}
