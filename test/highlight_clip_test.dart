import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

void main() {
  for (final custom in [false, true]) {
    testWidgets(
      'selected item paint stays below search, custom: $custom (#213)',
      (
        tester,
      ) async {
        const boundaryKey = Key('screen');
        final controller = MultiSelectController<int>();
        await tester.pumpWidget(
          RepaintBoundary(
            key: boundaryKey,
            child: buildTestApp(
              MultiDropdown<int>(
                items: createItems(30)
                    .map((item) => item.copyWith(selected: true))
                    .toList(),
                controller: controller,
                searchEnabled: true,
                itemBuilder: custom
                    ? (item, index, onTap) => ListTile(
                        title: Text(item.label),
                        selected: item.selected,
                        selectedTileColor: const Color(0xFFFF0000),
                        onTap: onTap,
                      )
                    : null,
                dropdownDecoration: const DropdownDecoration(maxHeight: 240),
                chipDecoration: const ChipDecoration(maxDisplayCount: 1),
                dropdownItemDecoration: const DropdownItemDecoration(
                  selectedBackgroundColor: Color(0xFFFF0000),
                ),
              ),
            ),
          ),
        );
        controller.openDropdown();
        await tester.pumpAndSettle();
        final list = find.byType(ListView);
        for (final offset in [0.0, -25.0, -100.0]) {
          if (offset != 0) {
            await tester.drag(list, Offset(0, offset));
            await tester.pumpAndSettle();
          }
          final boundary = tester.renderObject<RenderRepaintBoundary>(
            find.byKey(boundaryKey),
          );
          final searchRect = tester.getRect(find.byType(TextField));
          final image = (await tester.runAsync(boundary.toImage))!;
          final data = (await tester.runAsync(
            image.toByteData,
          ))!;
          var redInSearch = 0;
          var totalRed = 0;
          for (var y = 0; y < image.height; y++) {
            for (var x = 0; x < image.width; x++) {
              final i = (y * image.width + x) * 4;
              if (data.getUint8(i) == 255 &&
                  data.getUint8(i + 1) == 0 &&
                  data.getUint8(i + 2) == 0) {
                totalRed++;
                if (searchRect.contains(Offset(x.toDouble(), y.toDouble()))) {
                  redInSearch++;
                }
              }
            }
          }
          image.dispose();
          expect(totalRed, greaterThan(0));
          expect(redInSearch, 0);
          expect(tester.takeException(), isNull);
        }
        await tester.pumpWidget(const SizedBox.shrink());
        controller.dispose();
      },
    );
  }
}
