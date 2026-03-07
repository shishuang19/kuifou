import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:kuifou/features/home/domain/entities/dashboard_metrics.dart';
import 'package:kuifou/features/home/presentation/widgets/dashboard_metrics_card.dart';

void main() {
  testWidgets('DashboardMetricsCard renders all metric labels and values', (
    WidgetTester tester,
  ) async {
    final metrics = DashboardMetrics(
      id: 'metrics-1',
      totalResidualValue: 12345.67,
      todayCost: 23.45,
      assetCount: 42,
      estimatedDailyCost: 56.78,
      snapshotDate: DateTime(2026, 3, 6),
      createdAt: DateTime(2026, 3, 6),
    );

    final formatter = NumberFormat.currency(
      locale: 'zh_CN',
      symbol: '¥',
      decimalDigits: 2,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardMetricsCard(metrics: metrics),
        ),
      ),
    );

    expect(find.text('资产总览'), findsOneWidget);
    expect(find.text('总残值'), findsOneWidget);
    expect(find.text('今日成本'), findsOneWidget);
    expect(find.text('资产数量'), findsOneWidget);
    expect(find.text('每日成本'), findsOneWidget);

    expect(
      find.text(formatter.format(metrics.totalResidualValue)),
      findsOneWidget,
    );
    expect(find.text(formatter.format(metrics.todayCost)), findsOneWidget);
    expect(find.text('${metrics.assetCount}'), findsOneWidget);
    expect(find.text(formatter.format(metrics.estimatedDailyCost)), findsOneWidget);

    expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
    expect(find.byIcon(Icons.trending_down), findsOneWidget);
    expect(find.byIcon(Icons.inventory_2), findsOneWidget);
    expect(find.byIcon(Icons.calendar_today), findsOneWidget);
  });
}
