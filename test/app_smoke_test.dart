import 'package:flutter_test/flutter_test.dart';

import 'package:kuifou/app/app.dart';

void main() {
  testWidgets('renders home page title', (WidgetTester tester) async {
    await tester.pumpWidget(const KuifouApp());
    await tester.pumpAndSettle();
    expect(find.text('亏否'), findsOneWidget);
  });
}
