import 'package:example/examples/bottom_sheet_example.dart';
import 'package:example/examples/controller_example.dart';
import 'package:example/examples/form_validation_example.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

void main() {
  testWidgets('Spoken languages remains selectable with the keyboard open', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(const MaterialApp(home: BottomSheetExample()));
    final dropdown = find.byType(MultiDropdown<String>);
    await tester.ensureVisible(dropdown);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.drag(
      find.byType(DraggableScrollableSheet),
      const Offset(0, 80),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.byType(TextField));
    tester.view.padding = const FakeViewPadding(top: 47);
    tester.view.viewInsets = const FakeViewPadding(bottom: 336);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.enterText(find.byType(TextField), 'Spanish');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final spanish = find.widgetWithText(ListTile, 'Spanish');
    expect(tester.getBottomLeft(spanish).dy, lessThanOrEqualTo(844 - 336));
    await tester.tap(spanish);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    Navigator.of(tester.element(find.byType(TextField))).pop();
    tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
    tester.view.viewInsets = FakeViewPadding.zero;
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Languages: es'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('controller buttons select, clear, open, close and add items', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ControllerExample()));
    final controller = tester
        .widget<MultiDropdown<String>>(find.byType(MultiDropdown<String>))
        .controller!;
    Future<void> tapAction(String label) async {
      await tester.ensureVisible(find.text(label));
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }

    await tapAction('Select All');
    expect(controller.selectedItems.length, controller.items.length);
    await tapAction('Clear All');
    expect(controller.selectedItems, isEmpty);
    await tapAction('Common (first 4)');
    expect(controller.selectedItems.length, 4);
    await tapAction('Clear All');
    await tapAction('Select First');
    expect(controller.selectedItems.length, 1);
    final count = controller.items.length;
    await tapAction('Add Ingredient');
    expect(controller.items.length, count + 1);
    await tapAction('Open');
    expect(controller.isOpen, isTrue);
    // The open overlay covers the action buttons.
    controller.closeDropdown();
    await tester.pumpAndSettle();
    await tapAction('Close');
    expect(controller.isOpen, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'application form rejects missing values and accepts a completed form',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: FormValidationExample()));
      final submit = find.text('Submit Application');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pumpAndSettle();
      final form = tester.state<FormState>(find.byType(Form));
      expect(form.validate(), isFalse);
      final fields = find.byType(TextFormField);
      await tester.ensureVisible(fields.at(0));
      await tester.enterText(fields.at(0), 'Test User');
      await tester.ensureVisible(fields.at(1));
      await tester.enterText(fields.at(1), 'test@example.com');
      final dropdowns = find.byType(MultiDropdown<String>);
      for (var i = 0; i < 2; i++) {
        await tester.ensureVisible(dropdowns.at(i));
        await tester.tap(dropdowns.at(i));
        await tester.pumpAndSettle();
        final row = find.byType(ListTile).hitTestable().first;
        await tester.tap(row);
        await tester.pumpAndSettle();
        if (i == 1) {
          await tester.tapAt(const Offset(5, 5));
          await tester.pumpAndSettle();
        }
      }
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(form.validate(), isTrue);
      expect(tester.takeException(), isNull);
    },
  );
}
