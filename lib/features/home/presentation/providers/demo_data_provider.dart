import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/asset.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/dashboard_metrics.dart';

part 'demo_data_provider.g.dart';

/// Web 端兜底数据源（内存）
final demoAssets = <Asset>[
  Asset(
    id: '1',
    name: 'MacBook Pro 2023',
    purchasePrice: 18999.00,
    purchaseDate: DateTime(2023, 6, 15),
    expectedLifeDays: 1095, // 3年
    categoryId: 'cat_digital',
    icon: '💻',
    status: AssetStatus.using,
    createdAt: DateTime(2023, 6, 15),
    updatedAt: DateTime.now(),
  ),
  Asset(
    id: '2',
    name: 'iPhone 15 Pro',
    purchasePrice: 9999.00,
    purchaseDate: DateTime(2024, 9, 20),
    expectedLifeDays: 730, // 2年
    categoryId: 'cat_digital',
    icon: '📱',
    status: AssetStatus.using,
    createdAt: DateTime(2024, 9, 20),
    updatedAt: DateTime.now(),
  ),
  Asset(
    id: '3',
    name: 'Sony A7M4 相机',
    purchasePrice: 16800.00,
    purchaseDate: DateTime(2023, 3, 10),
    expectedLifeDays: 1825, // 5年
    categoryId: 'cat_digital',
    icon: '📷',
    status: AssetStatus.using,
    createdAt: DateTime(2023, 3, 10),
    updatedAt: DateTime.now(),
  ),
  Asset(
    id: '4',
    name: '公路自行车',
    purchasePrice: 5600.00,
    purchaseDate: DateTime(2022, 5, 1),
    expectedLifeDays: 2190, // 6年
    categoryId: 'cat_sports',
    icon: '🚲',
    status: AssetStatus.idle,
    createdAt: DateTime(2022, 5, 1),
    updatedAt: DateTime.now(),
  ),
];

final demoCategories = <Category>[
  Category(
    id: 'cat_digital',
    name: '数码产品',
    icon: '💻',
    sortOrder: 1,
    isDefault: true,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Category(
    id: 'cat_sports',
    name: '运动器材',
    icon: '🏃',
    sortOrder: 2,
    isDefault: false,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];

/// 演示资产列表
@riverpod
Future<List<Asset>> demoAssetList(DemoAssetListRef ref) async {
  // 模拟网络延迟
  await Future.delayed(const Duration(milliseconds: 300));
  return List.unmodifiable(demoAssets);
}

/// 演示分类列表
@riverpod
Future<List<Category>> demoCategoryList(DemoCategoryListRef ref) async {
  await Future.delayed(const Duration(milliseconds: 200));
  return List.unmodifiable(demoCategories);
}

/// 演示仪表盘指标
@riverpod
Future<DashboardMetrics> demoDashboardMetrics(
    DemoDashboardMetricsRef ref) async {
  await Future.delayed(const Duration(milliseconds: 250));

  final totalResidualValue = demoAssets.fold<double>(
    0,
    (sum, asset) => sum + asset.residualValue,
  );

  final totalDailyCost = demoAssets.fold<double>(
    0,
    (sum, asset) => sum + asset.dailyCost,
  );

  return DashboardMetrics(
    id: 'demo_metrics',
    totalResidualValue: totalResidualValue,
    todayCost: totalDailyCost,
    assetCount: demoAssets.length,
    estimatedDailyCost: totalDailyCost,
    snapshotDate: DateTime.now(),
    createdAt: DateTime.now(),
  );
}
