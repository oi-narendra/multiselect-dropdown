import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('dropdown shortcuts follow the target platform', (tester) async {
    final controller = MultiSelectController<int>();
    await tester.pumpWidget(
      buildTestApp(
        MultiDropdown<int>(items: createItems(), controller: controller),
      ),
    );
    controller.openDropdown();
    await tester.pumpAndSettle();
    final shortcuts = find.byWidgetPredicate(
      (widget) =>
          widget is Shortcuts &&
          widget.shortcuts.length == 2 &&
          widget.shortcuts.containsKey(
            const SingleActivator(LogicalKeyboardKey.arrowDown),
          ),
    );
    final desktop = [
      TargetPlatform.macOS,
      TargetPlatform.linux,
      TargetPlatform.windows,
    ].contains(defaultTargetPlatform);
    expect(shortcuts, kIsWeb || desktop ? findsOneWidget : findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
  }, variant: TargetPlatformVariant.all());
}
