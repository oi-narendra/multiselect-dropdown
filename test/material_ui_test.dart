import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

void main() {
  for (final mode in DropdownMode.values) {
    testWidgets('material_ui search borders render in ${mode.name}', (
      tester,
    ) async {
      const border = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color(0xFFD9D9D9)),
      );
      const focusedBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color(0xFFE91E63), width: 1.2),
      );
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(3),
            controller: controller,
            dropdownMode: mode,
            searchEnabled: true,
            searchDecoration: const SearchFieldDecoration(
              border: border,
              focusedBorder: focusedBorder,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(MultiDropdown<int>));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final search = find.byType(TextField);
      final field = tester.widget<TextField>(search);
      expect(field.decoration!.border, border);
      expect(field.decoration!.focusedBorder, focusedBorder);
      await tester.tap(search);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .focusNode
            .hasFocus,
        isTrue,
      );
      await tester.enterText(search, 'Item 2');
      await tester.pumpAndSettle();
      expect(find.widgetWithText(ListTile, 'Item 1'), findsNothing);
      expect(find.widgetWithText(ListTile, 'Item 2'), findsOneWidget);
      await tester.tap(find.widgetWithText(ListTile, 'Item 2'));
      await tester.pumpAndSettle();
      expect(controller.selectedItems.single.value, 2);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    });
  }
}
