import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kuifou/features/profile/data/services/profile_preferences_service.dart';
import 'package:kuifou/features/profile/profile_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfilePage', () {
    testWidgets('renders settings and about sections',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: ProfilePage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('偏好设置'), findsOneWidget);
      expect(find.text('默认折旧方法'), findsOneWidget);
      expect(find.text('恢复默认设置'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('关于亏否'), 300);
      await tester.pumpAndSettle();

      expect(find.text('关于亏否'), findsOneWidget);
    });

    testWidgets('loads persisted preferences into summary',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        ProfilePreferencesService.themePreferenceKey: 'light',
        ProfilePreferencesService.languagePreferenceKey: 'en_US',
        ProfilePreferencesService.depreciationMethodPreferenceKey:
            'double_declining',
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: ProfilePage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('主题: 浅色'), findsOneWidget);
      expect(find.text('语言: English'), findsOneWidget);
      expect(find.text('折旧: 双倍余额递减'), findsOneWidget);
    });
  });
}
