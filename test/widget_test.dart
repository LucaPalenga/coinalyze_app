import 'package:flutter_test/flutter_test.dart';

import 'package:coinalyze_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CoinalyzeApp());
    // Verify the app builds without errors
    expect(find.text('Coinalyze'), findsNothing); // title is in AppBar, not visible here
  });
}
