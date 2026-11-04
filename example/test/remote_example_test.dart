import 'package:example/examples/remote_example.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

void main() {
  for (final bottomSheet in [false, true]) {
    testWidgets('remote example search, paging and selection ($bottomSheet)', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RemoteExample()));
      if (bottomSheet) {
        await tester.tap(find.byType(SwitchListTile));
        await tester.pump();
      }
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(MultiDropdown<int>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Member 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Load more'));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      final dropdown = tester.widget<MultiDropdown<int>>(
        find.byType(MultiDropdown<int>),
      );
      expect(
        dropdown.dropdownMode,
        bottomSheet ? DropdownMode.bottomSheet : DropdownMode.overlay,
      );
      await tester.enterText(find.byType(TextField), '60');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      expect(find.text('Member 60'), findsOneWidget);
      await tester.tap(find.text('Member 60'));
      await tester.pumpAndSettle();
      expect(find.text('Selected: 1, 60'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('remote example retries a simulated failure ($bottomSheet)', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RemoteExample()));
      if (bottomSheet) {
        await tester.tap(find.byType(SwitchListTile));
        await tester.pump();
      }
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Fail next request'));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(MultiDropdown<int>));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Member');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      expect(find.text('Could not load results.'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      expect(find.text('Member 1'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
