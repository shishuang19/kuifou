import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kuifou/features/home/domain/entities/asset.dart';
import 'package:kuifou/features/home/domain/entities/dashboard_metrics.dart';
import 'package:kuifou/features/home/home_page.dart';
import 'package:kuifou/features/home/presentation/providers/asset_list_provider.dart';
import 'package:kuifou/features/home/presentation/providers/dashboard_metrics_provider.dart';

Asset _asset() {
  return Asset(
    id: 'asset-1',
    name: 'Widget Test Asset',
    categoryId: 'cat-1',
    icon: '📦',
    purchasePrice: 1000,
    purchaseDate: DateTime(2026, 1, 1),
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

DashboardMetrics _metrics() {
  return DashboardMetrics(
    id: 'metrics-1',
    totalResidualValue: 100,
    todayCost: 5,
    assetCount: 1,
    estimatedDailyCost: 5,
    snapshotDate: DateTime(2026, 3, 6),
    createdAt: DateTime(2026, 3, 6),
  );
}

void main() {
  testWidgets('HomePage shows empty state when no assets', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          assetListProvider.overrideWith((ref) async => []),
          dashboardMetricsProvider.overrideWith((ref) async => _metrics()),
        ],
        child: const MaterialApp(home: HomePage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('还没有资产记录'), findsOneWidget);
    expect(find.text('点击下方按钮添加你的第一件物品吧'), findsOneWidget);
  });

  testWidgets('HomePage shows list when assets exist', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          assetListProvider.overrideWith((ref) async => [_asset()]),
          dashboardMetricsProvider.overrideWith((ref) async => _metrics()),
        ],
        child: const MaterialApp(home: HomePage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Widget Test Asset'), findsOneWidget);
    expect(find.text('我的资产'), findsOneWidget);
  });
}
