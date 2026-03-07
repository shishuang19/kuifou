import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kuifou/features/home/domain/entities/asset.dart';
import 'package:kuifou/features/home/domain/entities/category.dart';
import 'package:kuifou/features/home/domain/entities/dashboard_metrics.dart';
import 'package:kuifou/features/home/home_page.dart';
import 'package:kuifou/features/home/presentation/providers/asset_list_provider.dart';
import 'package:kuifou/features/home/presentation/providers/category_list_provider.dart';
import 'package:kuifou/features/home/presentation/providers/dashboard_metrics_provider.dart';

Asset _asset({
  required String id,
  required String name,
  required AssetStatus status,
  required String categoryId,
  required DateTime purchaseDate,
  required double purchasePrice,
}) {
  return Asset(
    id: id,
    name: name,
    categoryId: categoryId,
    icon: '📦',
    purchasePrice: purchasePrice,
    purchaseDate: purchaseDate,
    status: status,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

Category _category({
  required String id,
  required String name,
  required String icon,
}) {
  return Category(
    id: id,
    name: name,
    icon: icon,
    sortOrder: 0,
    isDefault: true,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

DashboardMetrics _metrics() {
  return DashboardMetrics(
    id: 'm-1',
    totalResidualValue: 1000,
    todayCost: 20,
    assetCount: 2,
    estimatedDailyCost: 20,
    snapshotDate: DateTime(2026, 3, 6),
    createdAt: DateTime(2026, 3, 6),
  );
}

Widget _buildHome({
  required List<Asset> assets,
  required List<Category> categories,
}) {
  return ProviderScope(
    overrides: [
      assetListProvider.overrideWith((ref) async => assets),
      dashboardMetricsProvider.overrideWith((ref) async => _metrics()),
      categoryListProvider.overrideWith((ref) async => categories),
    ],
    child: const MaterialApp(home: HomePage()),
  );
}

void main() {
  final assets = [
    _asset(
      id: 'a1',
      name: 'MacBook Pro',
      status: AssetStatus.using,
      categoryId: 'cat-electronics',
      purchaseDate: DateTime(2026, 1, 15),
      purchasePrice: 12000,
    ),
    _asset(
      id: 'a2',
      name: 'Road Bike',
      status: AssetStatus.idle,
      categoryId: 'cat-sports',
      purchaseDate: DateTime(2025, 4, 20),
      purchasePrice: 4500,
    ),
  ];

  final categories = [
    _category(id: 'cat-electronics', name: '电子', icon: '💻'),
    _category(id: 'cat-sports', name: '运动', icon: '🚴'),
  ];

  testWidgets('HomePage renders metrics, search, and list content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildHome(assets: assets, categories: categories));
    await tester.pumpAndSettle();

    expect(find.text('亏否'), findsOneWidget);
    expect(find.text('资产总览'), findsOneWidget);
    expect(find.text('我的资产'), findsOneWidget);
    expect(find.text('MacBook Pro'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Road Bike'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Road Bike'), findsOneWidget);
    expect(find.text('筛选'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('HomePage search shows no-match empty state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildHome(assets: assets, categories: categories));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'NotFoundItem');
    await tester.pumpAndSettle();

    expect(find.text('没有匹配结果'), findsOneWidget);
    expect(find.text('试试调整搜索词或筛选条件'), findsOneWidget);
    expect(find.text('MacBook Pro'), findsNothing);
    expect(find.text('Road Bike'), findsNothing);
  });

  testWidgets('HomePage filter bottom sheet updates status filter and list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildHome(assets: assets, categories: categories));
    await tester.pumpAndSettle();

    await tester.tap(find.text('筛选'));
    await tester.pumpAndSettle();

    expect(find.text('筛选与排序'), findsOneWidget);

    await tester.tap(find.text('闲置'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('完成'));
    await tester.pumpAndSettle();

    expect(find.text('筛选(1)'), findsOneWidget);
    expect(find.text('Road Bike'), findsOneWidget);
    expect(find.text('MacBook Pro'), findsNothing);
  });
}
