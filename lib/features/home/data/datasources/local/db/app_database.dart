import 'package:drift/drift.dart';
import 'tables/assets_table.dart';
import 'tables/categories_table.dart';
import 'tables/metrics_cache_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Assets, Categories, MetricsCache],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  // Asset DAO
  Future<void> insertAsset(AssetsCompanion asset) => into(assets).insert(asset);

  Future<bool> updateAsset(AssetsCompanion asset) => update(assets).replace(asset);

  Future<int> deleteAsset(String id) =>
      (delete(assets)..where((a) => a.id.equals(id))).go();

  Future<AssetDb?> getAsspetById(String id) =>
      (select(assets)..where((a) => a.id.equals(id))).getSingleOrNull();

  Future<List<AssetDb>> getAllAssets() =>
      (select(assets)..where((a) => a.deletedAt.isNull())).get();

  Future<List<AssetDb>> getAssetsByCategory(String categoryId) => (select(assets)
        ..where((a) => a.categoryId.equals(categoryId) & a.deletedAt.isNull()))
      .get();

  // Category DAO
  Future<void> insertCategory(CategoriesCompanion category) =>
      into(categories).insert(category);

  Future<bool> updateCategory(CategoriesCompanion category) =>
      update(categories).replace(category);

  Future<int> deleteCategory(String id) =>
      (delete(categories)..where((c) => c.id.equals(id))).go();

  Future<CategoryDb?> getCategoryById(String id) =>
      (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<List<CategoryDb>> getAllCategories() =>
      (select(categories)..orderBy([(c) => OrderingTerm(expression: c.sortOrder)]))
          .get();

  // Metrics DAO
  Future<void> insertMetrics(MetricsCacheCompanion metrics) =>
      into(metricsCache).insert(metrics);

  Future<MetricsDb?> getLatestMetrics() =>
      (select(metricsCache)..orderBy([(m) => OrderingTerm(expression: m.createdAt, mode: OrderingMode.desc)])..limit(1))
          .getSingleOrNull();

  Future<List<MetricsDb>> getMetricsByDate(DateTime date) =>
      (select(metricsCache)
            ..where((m) => m.snapshotDate.equals(date.toString().split(' ')[0])))
          .get();
}
