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

    // =========================================================================
    // Basic operations (existing)
    // =========================================================================

    test('setItems replaces existing items', () {
      controller.setItems(createItems(3));
      expect(controller.items.length, 3);

      controller.setItems(createItems());
      expect(controller.items.length, 5);
    });

    test('selectAll marks all items as selected', () {
      controller
        ..setItems(createItems())
        ..selectAll();
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
      controller
        ..setItems(createItems())
        ..selectAtIndex(2);
      expect(controller.selectedItems.length, 1);
      expect(controller.selectedItems.first.value, 3);
    });

    test('selectAtIndex does nothing for out of range index', () {
      controller
        ..setItems(createItems())
        ..selectAtIndex(-1)
        ..selectAtIndex(10);
      expect(controller.selectedItems.length, 0);
    });

    test('selectWhere selects matching items', () {
      controller
        ..setItems(createItems())
        ..selectWhere((item) => item.value <= 2);
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
      controller
        ..setItems(items)
        ..unselectWhere((item) => item.value == 2);
      expect(controller.selectedItems.length, 2);
    });

    test('toggleWhere toggles selection state', () {
      controller
        ..setItems(createItems())
        ..toggleWhere((item) => item.value == 1);
      expect(controller.selectedItems.length, 1);

      controller.toggleWhere((item) => item.value == 1);
      expect(controller.selectedItems.length, 0);
    });

    test('disableWhere disables items', () {
      controller
        ..setItems(createItems())
        ..disableWhere((item) => item.value <= 2);
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
      controller
        ..setItems(createItems(3))
        ..addItem(DropdownItem(label: 'Item 4', value: 4));
      expect(controller.items.length, 4);
    });

    test('addItems adds multiple items', () {
      controller
        ..setItems(createItems(2))
        ..addItems([
          DropdownItem(label: 'Item 3', value: 3),
          DropdownItem(label: 'Item 4', value: 4),
        ]);
      expect(controller.items.length, 4);
    });

    test('clearSearch is callable and does not throw', () {
      controller.setItems(createItems());
      expect(() => controller.clearSearch(), returnsNormally);
    });

    // =========================================================================
    // In-place mutation verification
    // =========================================================================

    test('selectAll modifies items in-place, all become selected', () {
      controller
        ..setItems(createItems(3))
        ..selectAll();
      expect(controller.items.length, 3);
      expect(controller.selectedItems.length, 3);
      for (final item in controller.items) {
        expect(item.selected, true);
      }
    });

    test('clearAll only touches selected items', () {
      controller
        ..setItems([
          DropdownItem(label: 'A', value: 1, selected: true),
          DropdownItem(label: 'B', value: 2),
          DropdownItem(label: 'C', value: 3, selected: true),
        ])
        ..clearAll();
      expect(controller.selectedItems.length, 0);
      expect(controller.items[1].label, 'B');
      expect(controller.items[1].selected, false);
    });

    // =========================================================================
    // selectedItems caching
    // =========================================================================

    test('selectedItems returns identical list on repeated access', () {
      controller.setItems([
        DropdownItem(label: 'A', value: 1, selected: true),
        DropdownItem(label: 'B', value: 2),
      ]);

      final first = controller.selectedItems;
      final second = controller.selectedItems;
      expect(identical(first, second), isTrue);
    });

    test('selectedItems cache invalidated after selectAll', () {
      controller.setItems(createItems(3));
      final before = controller.selectedItems;
      expect(before.length, 0);

      controller.selectAll();
      final after = controller.selectedItems;
      expect(after.length, 3);
      expect(identical(before, after), isFalse);
    });

    test('selectedItems cache invalidated after toggleWhere', () {
      controller.setItems(createItems(3));
      expect(controller.selectedItems.length, 0);

      controller.toggleWhere((item) => item.value == 2);
      expect(controller.selectedItems.length, 1);
      expect(controller.selectedItems.first.value, 2);
    });

    test('selectedItems cache invalidated after clearAll', () {
      controller
        ..setItems(createItems())
        ..selectAll();
      expect(controller.selectedItems.length, 5);

      controller.clearAll();
      expect(controller.selectedItems.length, 0);
    });

    // =========================================================================
    // selectAtIndex edge cases
    // =========================================================================

    test('selectAtIndex skips disabled items', () {
      controller
        ..setItems([
          DropdownItem(label: 'A', value: 1, disabled: true),
          DropdownItem(label: 'B', value: 2),
        ])
        ..selectAtIndex(0);
      expect(controller.selectedItems.length, 0);

      controller.selectAtIndex(1);
      expect(controller.selectedItems.length, 1);
    });

    test('selectAtIndex skips already selected items', () {
      controller
        ..setItems([
          DropdownItem(label: 'A', value: 1, selected: true),
        ])
        ..selectAtIndex(0); // already selected, no-op
      expect(controller.selectedItems.length, 1);
    });

    // =========================================================================
    // addItem with index
    // =========================================================================

    test('addItem inserts at specific index', () {
      controller
        ..setItems(createItems(3))
        ..addItem(
          DropdownItem(label: 'Inserted', value: 99),
          index: 1,
        );

      expect(controller.items.length, 4);
      expect(controller.items[1].label, 'Inserted');
      expect(controller.items[1].value, 99);
    });

    // =========================================================================
    // disableWhere edge cases
    // =========================================================================

    test('disableWhere skips already disabled items', () {
      controller
        ..setItems([
          DropdownItem(label: 'A', value: 1, disabled: true),
          DropdownItem(label: 'B', value: 2),
        ])
        ..disableWhere((item) => true);
      expect(controller.disabledItems.length, 2);
    });

    // =========================================================================
    // openDropdown / closeDropdown idempotency
    // =========================================================================

    test('openDropdown is idempotent (does not notify when already open)', () {
      var notifyCount = 0;
      controller
        ..addListener(() => notifyCount++)
        ..setItems(createItems());
      notifyCount = 0;

      controller.openDropdown();
      expect(notifyCount, 1);

      controller.openDropdown(); // already open
      expect(notifyCount, 1);
    });

    test('closeDropdown is idempotent (does not notify when already closed)',
        () {
      var notifyCount = 0;
      controller
        ..addListener(() => notifyCount++)
        ..setItems(createItems())
        ..openDropdown();
      notifyCount = 0;

      controller.closeDropdown();
      expect(notifyCount, 1);

      controller.closeDropdown(); // already closed
      expect(notifyCount, 1);
    });

    // =========================================================================
    // setItems resets search
    // =========================================================================

    test('setItems resets search query and shows all items', () {
      controller.setItems(createItems());
      expect(controller.items.length, 5);

      controller.setItems(createItems(3));
      expect(controller.items.length, 3);
    });

    // =========================================================================
    // toString / equality
    // =========================================================================

    test('toString contains class name and open state', () {
      controller.setItems(createItems(2));
      final str = controller.toString();
      expect(str, contains('MultiSelectController'));
      expect(str, contains('open: false'));
    });

    test('two controllers with same items are equal', () {
      final other = MultiSelectController<int>();
      controller.setItems(createItems(3));
      other.setItems(createItems(3));

      expect(controller, equals(other));
      other.dispose();
    });

    test('two controllers with different items are not equal', () {
      final other = MultiSelectController<int>();
      controller.setItems(createItems(3));
      other.setItems(createItems());

      expect(controller, isNot(equals(other)));
      other.dispose();
    });

    // =========================================================================
    // dispose safety
    // =========================================================================

    test('dispose is idempotent', () {
      final c = MultiSelectController<int>()..dispose();
      expect(c.isDisposed, true);
      expect(c.dispose, returnsNormally);
    });
  });
}
