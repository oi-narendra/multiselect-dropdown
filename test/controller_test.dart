import 'package:flutter_test/flutter_test.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

void main() {
  group('MultiSelectController', () {
    late MultiSelectController<int> controller;

    setUp(() {
      controller = MultiSelectController<int>();
    });

    tearDown(() {
      controller.dispose();
    });

    test('setItems replaces existing items', () {
      controller.setItems(createItems(3));
      expect(controller.items.length, 3);

      controller.setItems(createItems());
      expect(controller.items.length, 5);
    });

    test('selectAll marks all items as selected', () {
      controller.setItems(createItems());
      controller.selectAll();
      expect(controller.selectedItems.length, 5);
    });

    test('clearAll deselects all items', () {
      final items = List.generate(
        3,
        (i) => DropdownItem(
          label: 'Item ${i + 1}',
          value: i + 1,
          selected: true,
        ),
      );
      controller.setItems(items);
      expect(controller.selectedItems.length, 3);

      controller.clearAll();
      expect(controller.selectedItems.length, 0);
    });

    test('selectAtIndex selects the correct item', () {
      controller.setItems(createItems());
      controller.selectAtIndex(2);
      expect(controller.selectedItems.length, 1);
      expect(controller.selectedItems.first.value, 3);
    });

    test('selectAtIndex does nothing for out of range index', () {
      controller.setItems(createItems());
      controller.selectAtIndex(-1);
      controller.selectAtIndex(10);
      expect(controller.selectedItems.length, 0);
    });

    test('selectWhere selects matching items', () {
      controller.setItems(createItems());
      controller.selectWhere((item) => item.value <= 2);
      expect(controller.selectedItems.length, 2);
    });

    test('unselectWhere deselects matching items', () {
      final items = List.generate(
        3,
        (i) => DropdownItem(
          label: 'Item ${i + 1}',
          value: i + 1,
          selected: true,
        ),
      );
      controller.setItems(items);
      controller.unselectWhere((item) => item.value == 2);
      expect(controller.selectedItems.length, 2);
    });

    test('toggleWhere toggles selection state', () {
      controller.setItems(createItems());
      controller.toggleWhere((item) => item.value == 1);
      expect(controller.selectedItems.length, 1);

      controller.toggleWhere((item) => item.value == 1);
      expect(controller.selectedItems.length, 0);
    });

    test('disableWhere disables items', () {
      controller.setItems(createItems());
      controller.disableWhere((item) => item.value <= 2);
      expect(controller.disabledItems.length, 2);
    });

    test('openDropdown and closeDropdown toggle isOpen', () {
      expect(controller.isOpen, false);
      controller.openDropdown();
      expect(controller.isOpen, true);
      controller.closeDropdown();
      expect(controller.isOpen, false);
    });

    test('addItem adds item to the list', () {
      controller.setItems(createItems(3));
      controller.addItem(DropdownItem(label: 'Item 4', value: 4));
      expect(controller.items.length, 4);
    });

    test('addItems adds multiple items', () {
      controller.setItems(createItems(2));
      controller.addItems([
        DropdownItem(label: 'Item 3', value: 3),
        DropdownItem(label: 'Item 4', value: 4),
      ]);
      expect(controller.items.length, 4);
    });

    // #142/#145/#188/#190: clearSearch resets filtered items
    test('clearSearch is callable and does not throw', () {
      controller.setItems(createItems());
      expect(() => controller.clearSearch(), returnsNormally);
    });
  });
}
