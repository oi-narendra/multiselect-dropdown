import 'package:example/examples/accessibility_example.dart';
import 'package:example/examples/basic_example.dart';
import 'package:example/examples/bottom_sheet_example.dart';
import 'package:example/examples/controller_example.dart';
import 'package:example/examples/custom_search_example.dart';
import 'package:example/examples/custom_style_example.dart';
import 'package:example/examples/form_validation_example.dart';
import 'package:example/examples/future_example.dart';
import 'package:example/examples/grouped_items_example.dart';
import 'package:example/examples/searchable_example.dart';
import 'package:example/examples/select_all_example.dart';
import 'package:example/examples/single_select_example.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

void main() {
  final screens = <String, Widget Function()>{
    'Accessibility': AccessibilityExample.new,
    'Country Picker': BasicExample.new,
    'Languages': BottomSheetExample.new,
    'Recipe Ingredients': ControllerExample.new,
    'Contact Picker': CustomSearchExample.new,
    'Issue Labels': CustomStyleExample.new,
    'Job Application': FormValidationExample.new,
    'Async Loading': FutureExample.new,
    'Grocery List': GroupedItemsExample.new,
    'Team Members': SearchableExample.new,
    'Working Days': SelectAllExample.new,
    'Task Priority': SingleSelectExample.new,
  };
  for (final brightness in Brightness.values) {
    for (final screen in screens.entries) {
      testWidgets(
        '${screen.key} opens its dropdown in ${brightness.name} mode',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(390, 844));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(brightness: brightness),
              home: screen.value(),
            ),
          );
          await tester.pump(const Duration(seconds: 3));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          if (screen.key == 'Accessibility') {
            await tester.ensureVisible(find.byType(SwitchListTile));
            await tester.tap(find.byType(SwitchListTile));
            await tester.pumpAndSettle();
            expect(
              tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
              isTrue,
            );
            expect(tester.takeException(), isNull);
          }
          final dropdown = find
              .byWidgetPredicate((widget) => widget is MultiDropdown)
              .first;
          await tester.ensureVisible(dropdown);
          await tester.tap(dropdown);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpAndSettle();
        },
      );
    }
  }
}
