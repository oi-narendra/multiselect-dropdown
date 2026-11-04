import 'package:example/examples/searchable_example.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

void main() {
  testWidgets('Team Members opens, searches and selects without assertions', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SearchableExample()));
    await tester.tap(find.byType(MultiDropdown<String>));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.enterText(find.byType(TextField), 'Alice');
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, 'Alice Johnson'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Alice Johnson'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      tester
          .widget<ListTile>(find.widgetWithText(ListTile, 'Alice Johnson'))
          .trailing,
      isNotNull,
    );
  });
}
