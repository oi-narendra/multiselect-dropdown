import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

void main() {
  for (final (size, textScale) in [
    (const Size(390, 844), 1.0),
    (const Size(320, 640), 1.0),
    (const Size(844, 390), 1.0),
    (const Size(390, 844), 2.0),
    (const Size(320, 640), 2.0),
  ]) {
    testWidgets(
      'bottom-sheet search stays usable above keyboard at $size, text scale $textScale',
      (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        tester.platformDispatcher.textScaleFactorTestValue = textScale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetViewInsets);
        final controller = MultiSelectController<int>();
        await tester.pumpWidget(
          buildTestApp(
            MultiDropdown<int>(
              items: createItems(30),
              controller: controller,
              dropdownMode: DropdownMode.bottomSheet,
              searchEnabled: true,
              fieldDecoration: const FieldDecoration(
                labelText: 'Spoken languages',
              ),
            ),
          ),
        );
        await tester.tap(find.byType(MultiDropdown<int>));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(ListView), Offset(0, size.height * 0.1));
        await tester.pumpAndSettle();
        final beforeFocus = tester
            .getSize(find.byType(DraggableScrollableSheet))
            .height;
        await tester.tap(find.byType(TextField));
        await tester.pumpAndSettle();
        expect(
          tester.getSize(find.byType(DraggableScrollableSheet)).height,
          greaterThan(beforeFocus),
        );
        final keyboardHeight = size.height < 500 ? 230.0 : 300.0;
        tester.view.viewInsets = FakeViewPadding(bottom: keyboardHeight);
        await tester.pumpAndSettle();
        final keyboardTop = size.height - keyboardHeight;
        expect(
          tester.getBottomLeft(find.byType(TextField)).dy,
          lessThanOrEqualTo(keyboardTop),
        );
        expect(tester.getSize(find.byType(ListView)).height, greaterThan(48));
        expect(tester.takeException(), isNull);
        await tester.enterText(find.byType(TextField), 'Item 2');
        await tester.pumpAndSettle();
        final item = find.widgetWithText(ListTile, 'Item 2');
        expect(tester.getBottomLeft(item).dy, lessThanOrEqualTo(keyboardTop));
        await tester.tap(item);
        await tester.pumpAndSettle();
        expect(controller.selectedItems.single.value, 2);
        await tester.enterText(find.byType(TextField), 'no matches');
        await tester.pumpAndSettle();
        expect(find.text('No items found'), findsOneWidget);
        await tester.tap(find.byTooltip('Clear search'));
        await tester.pumpAndSettle();
        expect(find.text('Item 1'), findsWidgets);
        tester.view.viewInsets = FakeViewPadding.zero;
        await tester.pumpAndSettle();
        Navigator.of(tester.element(find.byType(TextField))).pop();
        await tester.pumpAndSettle();
        expect(controller.isOpen, isFalse);
        await tester.tap(find.byType(MultiDropdown<int>));
        await tester.pumpAndSettle();
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          isEmpty,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        controller.dispose();
      },
    );
  }
  testWidgets(
    'autofocus expands an empty sheet and survives keyboard changes',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpWidget(
        buildTestApp(
          const MultiDropdown<int>(
            items: [],
            dropdownMode: DropdownMode.bottomSheet,
            searchEnabled: true,
            searchDecoration: SearchFieldDecoration(autofocus: true),
          ),
        ),
      );
      await tester.tap(find.byType(MultiDropdown<int>));
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(DraggableScrollableSheet)).height,
        greaterThan(600),
      );
      for (final inset in [300.0, 350.0, 0.0]) {
        tester.view.viewInsets = FakeViewPadding(bottom: inset);
        await tester.pumpAndSettle();
        expect(
          tester.getBottomLeft(find.text('No items found')).dy,
          lessThan(844 - inset),
        );
        expect(tester.takeException(), isNull);
      }
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('sheet dismisses with a search query and keyboard open', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(
      buildTestApp(
        MultiDropdown<int>(
          items: createItems(),
          dropdownMode: DropdownMode.bottomSheet,
          searchEnabled: true,
        ),
      ),
    );
    await tester.tap(find.byType(MultiDropdown<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextField));
    tester.view.padding = const FakeViewPadding(top: 47);
    tester.view.viewInsets = const FakeViewPadding(bottom: 336);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Item');
    await tester.pumpAndSettle();
    expect(find.byTooltip('Clear search'), findsOneWidget);
    expect(tester.takeException(), isNull);
    Navigator.of(tester.element(find.byType(TextField))).pop();
    tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
    tester.view.viewInsets = FakeViewPadding.zero;
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sheet can close during search expansion', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        MultiDropdown<int>(
          items: createItems(),
          dropdownMode: DropdownMode.bottomSheet,
          searchEnabled: true,
        ),
      ),
    );
    await tester.tap(find.byType(MultiDropdown<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextField));
    await tester.pump(const Duration(milliseconds: 20));
    Navigator.of(tester.element(find.byType(TextField))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
