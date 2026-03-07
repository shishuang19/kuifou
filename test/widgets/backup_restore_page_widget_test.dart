import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kuifou/features/profile/backup_restore_page.dart';

void main() {
  group('BackupRestorePage', () {
    testWidgets('renders export and restore sections',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: BackupRestorePage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('备份与恢复'), findsOneWidget);
      expect(find.text('导出备份'), findsOneWidget);
      expect(find.text('恢复备份'), findsOneWidget);
      expect(find.text('导出 JSON'), findsOneWidget);
      expect(find.text('校验并恢复'), findsOneWidget);
    });
  });
}
