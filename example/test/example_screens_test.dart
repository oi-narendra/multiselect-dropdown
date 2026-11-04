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
        '${screen.key} searches and selects in ${brightness.name} mode',
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
          final dropdowns = find.byWidgetPredicate(
            (widget) => widget is MultiDropdown,
          );
          final count = dropdowns.evaluate().length;
          for (var index = 0; index < count; index++) {
            if (index > 0) {
              await tester.pumpWidget(const SizedBox.shrink());
              await tester.pumpAndSettle();
              await tester.pumpWidget(
                MaterialApp(
                  theme: ThemeData(brightness: brightness),
                  home: screen.value(),
                ),
              );
              await tester.pump(const Duration(seconds: 3));
              await tester.pumpAndSettle();
            }
            final dropdown = dropdowns.at(index);
            final widget = tester.widget<MultiDropdown<String>>(dropdown);
            await tester.ensureVisible(dropdown);
            await tester.tap(dropdown);
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            final rows = find.byWidgetPredicate(
              (widget) =>
                  widget is ListTile &&
                  widget.enabled &&
                  widget.onTap != null &&
                  widget.title is Text,
            );
            final firstRow = rows.hitTestable().first;
            expect(firstRow, findsOneWidget);
            final label =
                (tester.widget<ListTile>(firstRow).title! as Text).data!;
            if (widget.searchEnabled) {
              final search = find.byType(TextField).last;
              await tester.enterText(search, 'zzzz-no-match');
              await tester.pumpAndSettle();
              expect(
                find.text(widget.dropdownDecoration.noItemsFoundText),
                findsOneWidget,
              );
              await tester.tap(find.byTooltip('Clear search'));
              await tester.pumpAndSettle();
              await tester.enterText(search, label);
              await tester.pumpAndSettle();
              expect(find.widgetWithText(ListTile, label), findsOneWidget);
            }
            final selectedRow = find.widgetWithText(ListTile, label);
            final wasSelected = tester.widget<ListTile>(selectedRow).selected;
            await tester.tap(selectedRow);
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            if (widget.singleSelect) {
              expect(find.widgetWithText(ListTile, label), findsNothing);
              expect(
                find.descendant(of: dropdown, matching: find.text(label)),
                findsOneWidget,
              );
            } else if (widget.dropdownMode == DropdownMode.bottomSheet ||
                widget.itemBuilder != null) {
              expect(tester.widget<ListTile>(selectedRow).trailing, isNotNull);
            } else {
              expect(
                tester.widget<ListTile>(selectedRow).selected,
                !wasSelected,
              );
            }
          }
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpAndSettle();
        },
      );
    }
  }
}
