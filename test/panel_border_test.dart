import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

/// The [Material] that paints the dropdown panel, found by the radius the
/// decoration asked for.
Material _panelOf(WidgetTester tester) {
  return tester
      .widgetList<Material>(find.byType(Material))
      .firstWhere((m) => m.shape != null || m.borderRadius != null);
}

Future<void> _openWith(WidgetTester tester, DropdownDecoration decoration) async {
  final controller = MultiSelectController<int>();

  await tester.pumpWidget(
    buildTestApp(
      MultiDropdown<int>(
        items: createItems(),
        controller: controller,
        dropdownDecoration: decoration,
      ),
    ),
  );

  controller.openDropdown();
  await tester.pumpAndSettle();
}

void main() {
  group('dropdown panel border', () {
    testWidgets('draws an outline when a border is given', (tester) async {
      await _openWith(
        tester,
        const DropdownDecoration(
          backgroundColor: Colors.white,
          border: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      );

      final shape = _panelOf(tester).shape;

      expect(shape, isA<RoundedRectangleBorder>());
      expect(
        (shape! as RoundedRectangleBorder).side.color,
        const Color(0xFFE5E7EB),
      );
    });

    // The radius has to survive the move into the shape: Material asserts that
    // shape and borderRadius are never both set, so a border that dropped the
    // radius would square off every rounded panel.
    testWidgets('keeps the radius when the border moves into the shape', (
      tester,
    ) async {
      await _openWith(
        tester,
        const DropdownDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: BorderSide(color: Colors.red),
        ),
      );

      final shape = _panelOf(tester).shape! as RoundedRectangleBorder;

      expect(shape.borderRadius, const BorderRadius.all(Radius.circular(20)));
    });

    testWidgets('falls back to borderRadius when no border is given', (
      tester,
    ) async {
      await _openWith(tester, const DropdownDecoration());

      final panel = _panelOf(tester);

      expect(panel.shape, isNull);
      expect(panel.borderRadius, isNotNull);
    });
  });
}
