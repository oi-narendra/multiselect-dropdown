import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

void main() {
  for (final mode in DropdownMode.values) {
    testWidgets('custom ListTile can paint ink in ${mode.name}', (
      tester,
    ) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(),
            controller: controller,
            dropdownMode: mode,
            searchEnabled: true,
            dropdownDecoration: const DropdownDecoration(
              backgroundColor: Colors.purple,
            ),
            itemBuilder: (item, index, onTap) => ListTile(
              title: Text(item.label),
              selected: item.selected,
              selectedTileColor: Colors.blue,
              onTap: onTap,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(MultiDropdown<int>));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.widgetWithText(ListTile, 'Item 2'));
      await tester.pumpAndSettle();
      expect(controller.selectedItems.single.value, 2);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    });
  }
}
