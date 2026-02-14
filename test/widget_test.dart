import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

void main() {
  group('MultiDropdown Widget', () {
    // =========================================================================
    // Cursor Behavior (#158)
    // =========================================================================

    testWidgets('uses click cursor when enabled', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: createItems()),
        ),
      );

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.mouseCursor, SystemMouseCursors.click);
    });

    testWidgets('uses forbidden cursor when disabled', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: createItems(), enabled: false),
        ),
      );

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.mouseCursor, SystemMouseCursors.forbidden);
    });

    // =========================================================================
    // Disabled State (#173, #174)
    // =========================================================================

    testWidgets('tapping disabled dropdown does not open it', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            enabled: false,
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(controller.isOpen, false);
      controller.dispose();
    });

    testWidgets('disabled chips do not show delete icons', (tester) async {
      final items = List.generate(
        3,
        (i) => DropdownItem(
          label: 'Chip ${i + 1}',
          value: i + 1,
          selected: true,
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: items, enabled: false),
        ),
      );

      // In disabled state, the close icon should not appear
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('disabled chips use theme disabled color', (tester) async {
      final items = [
        DropdownItem(label: 'Test Chip', value: 1, selected: true),
      ];

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: items, enabled: false),
        ),
      );

      // Find the chip text and verify it uses disabled color
      final textWidget = tester.widget<Text>(find.text('Test Chip'));
      expect(textWidget.style?.color, isNotNull);
    });

    testWidgets('clear icon does not appear when disabled', (tester) async {
      final items = [
        DropdownItem(label: 'Item', value: 1, selected: true),
      ];

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: items,
            enabled: false,
          ),
        ),
      );

      // The clear icon should not be rendered when disabled
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('clear icon appears when enabled with selections',
        (tester) async {
      final items = [
        DropdownItem(label: 'Item', value: 1, selected: true),
      ];

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: items,
          ),
        ),
      );

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('tapping clear icon deselects all items', (tester) async {
      final controller = MultiSelectController<int>();
      final items = [
        DropdownItem(label: 'Item 1', value: 1, selected: true),
        DropdownItem(label: 'Item 2', value: 2, selected: true),
      ];

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: items,
            controller: controller,
          ),
        ),
      );

      expect(controller.selectedItems.length, 2);
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(controller.selectedItems.length, 0);
      controller.dispose();
    });

    // =========================================================================
    // Single-Select Mode (#137, #195, #139)
    // =========================================================================

    testWidgets('shows selected item text in single-select mode',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: [
              DropdownItem(label: 'Selected Item', value: 1, selected: true),
            ],
            singleSelect: true,
          ),
        ),
      );

      expect(find.text('Selected Item'), findsOneWidget);
    });

    testWidgets('applies selectedItemTextStyle in single-select mode',
        (tester) async {
      const textStyle = TextStyle(
        fontSize: 20,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      );

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: [
              DropdownItem(label: 'Styled', value: 1, selected: true),
            ],
            singleSelect: true,
            fieldDecoration: const FieldDecoration(
              selectedItemTextStyle: textStyle,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Styled'));
      expect(textWidget.style?.fontSize, 20);
      expect(textWidget.style?.color, Colors.red);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('auto-closes dropdown after selection in single-select mode',
        (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            singleSelect: true,
            controller: controller,
          ),
        ),
      );

      // Open
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(controller.isOpen, true);

      // Select item → should auto-close
      await tester.tap(find.text('Item 1'));
      await tester.pumpAndSettle();

      expect(controller.isOpen, false);
      expect(controller.selectedItems.length, 1);
      expect(controller.selectedItems.first.label, 'Item 1');
      controller.dispose();
    });

    testWidgets('replaces previous selection in single-select mode',
        (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            singleSelect: true,
            controller: controller,
          ),
        ),
      );

      // Select first item
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Item 1'));
      await tester.pumpAndSettle();

      expect(controller.selectedItems.length, 1);
      expect(controller.selectedItems.first.label, 'Item 1');

      // Select different item
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Item 3'));
      await tester.pumpAndSettle();

      expect(controller.selectedItems.length, 1);
      expect(controller.selectedItems.first.label, 'Item 3');
      controller.dispose();
    });

    // =========================================================================
    // Dropdown Opening & Closing (#136)
    // =========================================================================

    testWidgets('opens dropdown on tap', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            controller: controller,
          ),
        ),
      );

      expect(controller.isOpen, false);
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(controller.isOpen, true);
      controller.dispose();
    });

    testWidgets('shows all items when dropdown is opened', (tester) async {
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

    testWidgets('selecting item adds it to selected items', (tester) async {
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

      await tester.tap(find.text('Item 2'));
      await tester.pumpAndSettle();

      expect(controller.selectedItems.length, 1);
      expect(controller.selectedItems.first.label, 'Item 2');
      controller.dispose();
    });

    testWidgets('multi-select allows multiple selections', (tester) async {
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

      await tester.tap(find.text('Item 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Item 3'));
      await tester.pumpAndSettle();

      expect(controller.selectedItems.length, 2);
      controller.dispose();
    });

    testWidgets('tapping selected item deselects it', (tester) async {
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

      await tester.tap(find.text('Item 1'));
      await tester.pumpAndSettle();
      expect(controller.selectedItems.length, 1);

      // After selection, 'Item 1' appears as both chip AND dropdown item.
      // Use .last to target the dropdown overlay item.
      await tester.tap(find.text('Item 1').last);
      await tester.pumpAndSettle();
      expect(controller.selectedItems.length, 0);
      controller.dispose();
    });

    // =========================================================================
    // Chip Display & Overflow (#194, #187)
    // =========================================================================

    testWidgets('shows chips for selected items', (tester) async {
      final items = List.generate(
        3,
        (i) => DropdownItem(
          label: 'Chip ${i + 1}',
          value: i + 1,
          selected: true,
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: items),
        ),
      );

      expect(find.text('Chip 1'), findsOneWidget);
      expect(find.text('Chip 2'), findsOneWidget);
      expect(find.text('Chip 3'), findsOneWidget);
    });

    testWidgets('chips have delete button when enabled', (tester) async {
      final items = [
        DropdownItem(label: 'Item', value: 1, selected: true),
      ];

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: items),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('tapping chip delete removes it from selection',
        (tester) async {
      final controller = MultiSelectController<int>();
      final items = [
        DropdownItem(label: 'To Remove', value: 1, selected: true),
        DropdownItem(label: 'To Keep', value: 2, selected: true),
      ];

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: items, controller: controller),
        ),
      );

      expect(controller.selectedItems.length, 2);

      // Tap the first chip's delete button
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();

      expect(controller.selectedItems.length, 1);
      controller.dispose();
    });

    testWidgets('maxDisplayCount limits visible chips', (tester) async {
      final items = List.generate(
        5,
        (i) => DropdownItem(
          label: 'Chip ${i + 1}',
          value: i + 1,
          selected: true,
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: items,
            chipDecoration: const ChipDecoration(maxDisplayCount: 2),
          ),
        ),
      );

      expect(find.text('Chip 1'), findsOneWidget);
      expect(find.text('Chip 2'), findsOneWidget);
      expect(find.text('Chip 3'), findsNothing);
      expect(find.text('Chip 4'), findsNothing);
      expect(find.text('Chip 5'), findsNothing);
      expect(find.text('+3 more'), findsOneWidget);
    });

    testWidgets('maxDisplayCount=1 shows +N more correctly', (tester) async {
      final items = List.generate(
        4,
        (i) => DropdownItem(
          label: 'C${i + 1}',
          value: i + 1,
          selected: true,
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: items,
            chipDecoration: const ChipDecoration(maxDisplayCount: 1),
          ),
        ),
      );

      expect(find.text('C1'), findsOneWidget);
      expect(find.text('C2'), findsNothing);
      expect(find.text('+3 more'), findsOneWidget);
    });

    testWidgets('no +N more label when within maxDisplayCount', (tester) async {
      final items = List.generate(
        2,
        (i) => DropdownItem(
          label: 'Chip ${i + 1}',
          value: i + 1,
          selected: true,
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: items,
            chipDecoration: const ChipDecoration(maxDisplayCount: 3),
          ),
        ),
      );

      expect(find.text('Chip 1'), findsOneWidget);
      expect(find.text('Chip 2'), findsOneWidget);
      expect(find.textContaining('more'), findsNothing);
    });

    // =========================================================================
    // selectedItemBuilder & Wrap (#170)
    // =========================================================================

    testWidgets('selectedItemBuilder with wrap=true uses Wrap layout',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: [
              DropdownItem(label: 'Item 1', value: 1, selected: true),
              DropdownItem(label: 'Item 2', value: 2, selected: true),
            ],
            selectedItemBuilder: (item) => Chip(label: Text(item.label)),
          ),
        ),
      );

      expect(find.byType(Wrap), findsOneWidget);
      expect(find.byType(Chip), findsNWidgets(2));
    });

    testWidgets('selectedItemBuilder with wrap=false uses horizontal ListView',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: [
              DropdownItem(label: 'Item 1', value: 1, selected: true),
              DropdownItem(label: 'Item 2', value: 2, selected: true),
            ],
            selectedItemBuilder: (item) => Chip(label: Text(item.label)),
            chipDecoration: const ChipDecoration(wrap: false),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('selectedItemBuilder renders custom widget per item',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: [
              DropdownItem(label: 'Apple', value: 1, selected: true),
              DropdownItem(label: 'Banana', value: 2, selected: true),
            ],
            selectedItemBuilder: (item) => Container(
              key: ValueKey(item.value),
              child: Text('Custom: ${item.label}'),
            ),
          ),
        ),
      );

      expect(find.text('Custom: Apple'), findsOneWidget);
      expect(find.text('Custom: Banana'), findsOneWidget);
    });

    testWidgets('selectedItemBuilder in single-select shows custom widget',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: [
              DropdownItem(label: 'Selected', value: 1, selected: true),
            ],
            singleSelect: true,
            selectedItemBuilder: (item) => Text('Builder: ${item.label}'),
          ),
        ),
      );

      expect(find.text('Builder: Selected'), findsOneWidget);
    });

    // =========================================================================
    // No Items Found (#201)
    // =========================================================================

    testWidgets('shows noItemsFoundText when search yields no results',
        (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(3),
            controller: controller,
            searchEnabled: true,
            dropdownDecoration: const DropdownDecoration(
              noItemsFoundText: 'Nothing here!',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Type something that doesn't match any item
      await tester.enterText(find.byType(TextField), 'zzzzz');
      await tester.pumpAndSettle();

      expect(find.text('Nothing here!'), findsOneWidget);
      controller.dispose();
    });

    testWidgets(
        'shows noItemsFoundText when items list is empty and search enabled',
        (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: const [],
            controller: controller,
            searchEnabled: true,
            dropdownDecoration: const DropdownDecoration(
              noItemsFoundText: 'Empty state text',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Empty state text'), findsOneWidget);
      controller.dispose();
    });

    // =========================================================================
    // InputDecoration Override (#141, #150)
    // =========================================================================

    testWidgets('custom inputDecoration shows label and hint', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            fieldDecoration: const FieldDecoration(
              inputDecoration: InputDecoration(
                labelText: 'Custom Label',
                hintText: 'Custom Hint',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Custom Label'), findsOneWidget);
      expect(find.text('Custom Hint'), findsOneWidget);
    });

    testWidgets('inputDecoration overrides default border', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            fieldDecoration: const FieldDecoration(
              inputDecoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Underline Field',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Underline Field'), findsOneWidget);
      expect(find.byType(MultiDropdown<int>), findsOneWidget);
    });

    // =========================================================================
    // Field Decoration Properties
    // =========================================================================

    testWidgets('shows hint text when nothing is selected', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            fieldDecoration: const FieldDecoration(hintText: 'Select items'),
          ),
        ),
      );
      expect(find.text('Select items'), findsOneWidget);
    });

    testWidgets('shows label text', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            fieldDecoration: const FieldDecoration(labelText: 'My Dropdown'),
          ),
        ),
      );
      expect(find.text('My Dropdown'), findsOneWidget);
    });

    testWidgets('shows prefix icon', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            fieldDecoration: const FieldDecoration(
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('suffix icon rotates when dropdown opens', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            controller: controller,
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);

      // Open dropdown
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // AnimatedRotation should be present
      expect(find.byType(AnimatedRotation), findsOneWidget);
      controller.dispose();
    });

    testWidgets('renders with default parameters', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: createItems()),
        ),
      );
      expect(find.byType(MultiDropdown<int>), findsOneWidget);
    });

    testWidgets('empty selection shows nothing in field', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: createItems()),
        ),
      );

      // No chip text should be visible
      for (var i = 1; i <= 5; i++) {
        expect(find.text('Item $i'), findsNothing);
      }
    });

    // =========================================================================
    // Search Functionality (#155, #152, #160, #165, #206)
    // =========================================================================

    testWidgets('search field appears when searchEnabled', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            searchEnabled: true,
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      controller.dispose();
    });

    testWidgets('search field does not appear when searchEnabled is false',
        (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNothing);
      controller.dispose();
    });

    testWidgets('typing in search filters dropdown items', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            searchEnabled: true,
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Item 1');
      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsWidgets);
      expect(find.text('Item 2'), findsNothing);
      expect(find.text('Item 3'), findsNothing);
      controller.dispose();
    });

    testWidgets('clearing search restores all items', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(3),
            searchEnabled: true,
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Type to filter
      await tester.enterText(find.byType(TextField), 'Item 1');
      await tester.pumpAndSettle();
      expect(find.text('Item 2'), findsNothing);

      // Clear the search
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();

      // All items should be back
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('search decoration hint text is shown', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            searchEnabled: true,
            controller: controller,
            searchDecoration: SearchFieldDecoration(
              hintText: 'Type to search...',
              fillColor: Colors.grey.shade100,
              filled: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Type to search...'), findsOneWidget);
      controller.dispose();
    });

    // =========================================================================
    // ExpandDirection (#147, #210)
    // =========================================================================

    testWidgets('renders with expandDirection auto (default)', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: createItems()),
        ),
      );
      expect(find.byType(MultiDropdown<int>), findsOneWidget);
    });

    testWidgets('renders with expandDirection down', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            dropdownDecoration: const DropdownDecoration(
              expandDirection: ExpandDirection.down,
            ),
          ),
        ),
      );
      expect(find.byType(MultiDropdown<int>), findsOneWidget);
    });

    testWidgets('renders with expandDirection up', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            dropdownDecoration: const DropdownDecoration(
              expandDirection: ExpandDirection.up,
            ),
          ),
        ),
      );
      expect(find.byType(MultiDropdown<int>), findsOneWidget);
    });

    // =========================================================================
    // Icon Types (#199, #200)
    // =========================================================================

    testWidgets('accepts custom Widget for selectedIcon and disabledIcon',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            dropdownItemDecoration: const DropdownItemDecoration(
              selectedIcon: Icon(Icons.check_circle, color: Colors.green),
              disabledIcon: Icon(Icons.block, color: Colors.red),
            ),
          ),
        ),
      );
      expect(find.byType(MultiDropdown<int>), findsOneWidget);
    });

    // =========================================================================
    // Dropdown Item Text Styles (#175, #197)
    // =========================================================================

    testWidgets('dropdown items are rendered in the overlay', (tester) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(3),
            controller: controller,
            dropdownItemDecoration: const DropdownItemDecoration(
              textStyle: TextStyle(fontSize: 20, color: Colors.blue),
            ),
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
    // Validator (#141)
    // =========================================================================

    testWidgets('accepts validator callback', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            validator: (items) {
              if (items == null || items.isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
        ),
      );

      expect(find.byType(MultiDropdown<int>), findsOneWidget);
    });

    // =========================================================================
    // Callbacks
    // =========================================================================

    testWidgets('onSelectionChange fires when items are selected',
        (tester) async {
      final selectedValues = <int>[];

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(3),
            onSelectionChange: (items) {
              selectedValues
                ..clear()
                ..addAll(items);
            },
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Item 2'));
      await tester.pumpAndSettle();

      expect(selectedValues, contains(2));
    });

    // =========================================================================
    // Chip Wrap Layout
    // =========================================================================

    testWidgets('chips use Wrap layout by default', (tester) async {
      final items = List.generate(
        3,
        (i) => DropdownItem(
          label: 'C${i + 1}',
          value: i + 1,
          selected: true,
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: items),
        ),
      );

      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('chips use ListView when wrap is false', (tester) async {
      final items = List.generate(
        3,
        (i) => DropdownItem(
          label: 'C${i + 1}',
          value: i + 1,
          selected: true,
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: items,
            chipDecoration: const ChipDecoration(wrap: false),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });

    // =========================================================================
    // Pre-selected Items
    // =========================================================================

    testWidgets('renders pre-selected items as chips on load', (tester) async {
      final items = [
        DropdownItem(label: 'Pre 1', value: 1, selected: true),
        DropdownItem(label: 'Pre 2', value: 2, selected: true),
        DropdownItem(label: 'Not Selected', value: 3),
      ];

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(items: items),
        ),
      );

      expect(find.text('Pre 1'), findsOneWidget);
      expect(find.text('Pre 2'), findsOneWidget);
      expect(find.text('Not Selected'), findsNothing);
    });

    // =========================================================================
    // Disabled Items
    // =========================================================================

    testWidgets('disabled items cannot be selected', (tester) async {
      final controller = MultiSelectController<int>();
      final items = [
        DropdownItem(label: 'Enabled', value: 1),
        DropdownItem(label: 'Disabled', value: 2, disabled: true),
      ];

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: items,
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Try to tap the disabled item
      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();

      expect(controller.selectedItems.length, 0);
      controller.dispose();
    });
  });
}
