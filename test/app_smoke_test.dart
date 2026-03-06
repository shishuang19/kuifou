import 'package:flutter_test/flutter_test.dart';

import 'package:kuifou/app/app.dart';

void main() {
  testWidgets('renders home page title', (WidgetTester tester) async {
    await tester.pumpWidget(const KuifouApp());
    expect(find.text('首页'), findsOneWidget);
  });
}
