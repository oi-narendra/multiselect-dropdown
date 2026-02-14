import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders home page', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());

    expect(find.text('MultiDropdown'), findsOneWidget);
  });
}
