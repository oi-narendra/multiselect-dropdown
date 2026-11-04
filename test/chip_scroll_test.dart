import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

void main() {
  for (final custom in [false, true]) {
    testWidgets('wrapped chips scroll with custom builder: $custom', (
      tester,
    ) async {
      final controller = MultiSelectController<int>();
      await tester.pumpWidget(
        buildTestApp(
          SizedBox(
            width: 240,
            child: MultiDropdown<int>(
              controller: controller,
              items: createItems(30)
                  .map((item) => item.copyWith(selected: true))
                  .toList(),
              chipDecoration: const ChipDecoration(wrapMaxHeight: 80),
              selectedItemBuilder: custom
                  ? (item) => SizedBox(
                      width: 120,
                      height: 32,
                      child: Text(item.label),
                    )
                  : null,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final scroller = find.descendant(
        of: find.byType(MultiDropdown<int>),
        matching: find.byType(SingleChildScrollView),
      );
      expect(scroller, findsOneWidget);
      expect(tester.getSize(scroller).height, 80);
      final scrollable = tester.state<ScrollableState>(
        find.descendant(
          of: scroller,
          matching: find.byType(Scrollable),
        ),
      );
      expect(scrollable.position.maxScrollExtent, greaterThan(0));
      await tester.drag(scroller, const Offset(0, -5000));
      await tester.pumpAndSettle();
      expect(scrollable.position.pixels, greaterThan(0));
      expect(find.text('Item 30').hitTestable(), findsOneWidget);
      if (!custom) {
        final chip = find
            .ancestor(
              of: find.text('Item 30'),
              matching: find.byType(AnimatedContainer),
            )
            .first;
        await tester.tap(
          find.descendant(of: chip, matching: find.byType(InkWell)),
        );
        await tester.pumpAndSettle();
        expect(controller.selectedItems.length, 29);
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    });
  }

  testWidgets('height limit is ignored for horizontal chips', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        MultiDropdown<int>(
          items: createItems(10)
              .map((item) => item.copyWith(selected: true))
              .toList(),
          chipDecoration: const ChipDecoration(wrap: false, wrapMaxHeight: 1),
        ),
      ),
    );
    final list = find.descendant(
      of: find.byType(MultiDropdown<int>),
      matching: find.byType(ListView),
    );
    expect(tester.widget<ListView>(list).scrollDirection, Axis.horizontal);
    expect(tester.getSize(list).height, greaterThan(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'short chip content keeps its natural height and overflow label',
    (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(10)
                .map((item) => item.copyWith(selected: true))
                .toList(),
            chipDecoration: const ChipDecoration(
              wrapMaxHeight: 120,
              maxDisplayCount: 1,
            ),
          ),
        ),
      );
      final scroller = find.descendant(
        of: find.byType(MultiDropdown<int>),
        matching: find.byType(SingleChildScrollView),
      );
      expect(tester.getSize(scroller).height, lessThan(120));
      expect(find.text('+9 more'), findsOneWidget);
      expect(find.text('Item 2'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  test('wrapMaxHeight rejects invalid heights', () {
    for (final height in [0.0, -1.0, double.infinity, double.nan]) {
      expect(() => ChipDecoration(wrapMaxHeight: height), throwsAssertionError);
    }
    expect(const ChipDecoration().wrapMaxHeight, isNull);
  });
}
