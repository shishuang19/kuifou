import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:kuifou/core/errors/app_exception.dart';
import 'package:kuifou/core/errors/result.dart';
import 'package:kuifou/features/home/domain/entities/asset.dart';
import 'package:kuifou/features/home/domain/entities/category.dart';
import 'package:kuifou/features/home/domain/repositories/asset_repository.dart';
import 'package:kuifou/features/home/domain/repositories/category_repository.dart';
import 'package:kuifou/features/profile/data/services/backup_service.dart';

class FakeAssetRepository implements AssetRepository {
  FakeAssetRepository(this.assets);

  final List<Asset> assets;
  int _id = 1;

  @override
  Future<Result<Asset>> createAsset({
    required String name,
    required String categoryId,
    required String icon,
    required double purchasePrice,
    required DateTime purchaseDate,
    DateTime? warrantyEndDate,
    int? expectedLifeDays,
    String? note,
  }) async {
    final created = Asset(
      id: 'asset-${_id++}',
      name: name,
      categoryId: categoryId,
      icon: icon,
      purchasePrice: purchasePrice,
      purchaseDate: purchaseDate,
      warrantyEndDate: warrantyEndDate,
      expectedLifeDays: expectedLifeDays,
      note: note,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );
    assets.add(created);
    return Success(created);
  }

  @override
  Future<Result<void>> deleteAsset(String id) async {
    assets.removeWhere((item) => item.id == id);
    return const Success(null);
  }

  @override
  Future<Result<List<Asset>>> getAllAssets() async => Success([...assets]);

  @override
  Future<Result<Asset?>> getAssetById(String id) async {
    final found = assets.where((item) => item.id == id).firstOrNull;
    return Success(found);
  }

  @override
  Future<Result<List<Asset>>> getAssetsByCategory(String categoryId) async {
    return Success(
      assets.where((item) => item.categoryId == categoryId).toList(),
    );
  }

  @override
  Future<Result<List<Asset>>> getAssetsByStatus(String status) async {
    return Success(
        assets.where((item) => item.status.value == status).toList());
  }

  @override
  Future<Result<Asset>> updateAsset({
    required String id,
    String? name,
    String? categoryId,
    String? icon,
    double? purchasePrice,
    DateTime? purchaseDate,
    DateTime? warrantyEndDate,
    int? expectedLifeDays,
    AssetStatus? status,
    String? note,
  }) async {
    final index = assets.indexWhere((item) => item.id == id);
    if (index < 0) {
      return Failure(NotFoundException(message: 'Asset not found: $id'));
    }

    final current = assets[index];
    final updated = Asset(
      id: current.id,
      name: name ?? current.name,
      categoryId: categoryId ?? current.categoryId,
      icon: icon ?? current.icon,
      purchasePrice: purchasePrice ?? current.purchasePrice,
      purchaseDate: purchaseDate ?? current.purchaseDate,
      warrantyEndDate: warrantyEndDate ?? current.warrantyEndDate,
      expectedLifeDays: expectedLifeDays ?? current.expectedLifeDays,
      status: status ?? current.status,
      note: note ?? current.note,
      createdAt: current.createdAt,
      updatedAt: DateTime(2026, 1, 2),
    );
    assets[index] = updated;
    return Success(updated);
  }
}

class FakeCategoryRepository implements CategoryRepository {
  FakeCategoryRepository(this.categories);

  final List<Category> categories;
  int _id = 1;

  @override
  Future<Result<Category>> createCategory({
    required String name,
    required String icon,
    String description = '',
    int sortOrder = 0,
    bool isDefault = false,
  }) async {
    final created = Category(
      id: 'cat-${_id++}',
      name: name,
      icon: icon,
      description: description,
      sortOrder: sortOrder,
      isDefault: isDefault,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );
    categories.add(created);
    return Success(created);
  }

  @override
  Future<Result<void>> deleteCategory(String id) async {
    categories.removeWhere((item) => item.id == id);
    return const Success(null);
  }

  @override
  Future<Result<List<Category>>> getAllCategories() async {
    final sorted = [...categories]..sort((a, b) => a.sortOrder - b.sortOrder);
    return Success(sorted);
  }

  @override
  Future<Result<Category?>> getCategoryById(String id) async {
    final found = categories.where((item) => item.id == id).firstOrNull;
    return Success(found);
  }

  @override
  Future<Result<Category>> updateCategory({
    required String id,
    String? name,
    String? icon,
    String? description,
    int? sortOrder,
    bool? isDefault,
  }) async {
    final index = categories.indexWhere((item) => item.id == id);
    if (index < 0) {
      return Failure(NotFoundException(message: 'Category not found: $id'));
    }

    final current = categories[index];
    final updated = Category(
      id: current.id,
      name: name ?? current.name,
      icon: icon ?? current.icon,
      description: description ?? current.description,
      sortOrder: sortOrder ?? current.sortOrder,
      isDefault: isDefault ?? current.isDefault,
      createdAt: current.createdAt,
      updatedAt: DateTime(2026, 1, 2),
    );

    categories[index] = updated;
    return Success(updated);
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => this.isEmpty ? null : first;
}

Category _category({
  required String id,
  required String name,
  required String icon,
  required int sortOrder,
  bool isDefault = false,
}) {
  return Category(
    id: id,
    name: name,
    icon: icon,
    sortOrder: sortOrder,
    isDefault: isDefault,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

Asset _asset({
  required String id,
  required String name,
  required String categoryId,
  AssetStatus status = AssetStatus.using,
}) {
  return Asset(
    id: id,
    name: name,
    categoryId: categoryId,
    icon: '📦',
    purchasePrice: 999,
    purchaseDate: DateTime(2026, 1, 1),
    status: status,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('BackupService', () {
    test('exportBackupJson returns valid json with assets and categories',
        () async {
      final categories = [
        _category(id: 'c1', name: '数码', icon: '💻', sortOrder: 1),
      ];
      final assets = [
        _asset(id: 'a1', name: 'MacBook', categoryId: 'c1'),
      ];

      final service = BackupService(
        assetRepository: FakeAssetRepository(assets),
        categoryRepository: FakeCategoryRepository(categories),
      );

      final result = await service.exportBackupJson();

      result.when(
        success: (jsonText) {
          final decoded = jsonDecode(jsonText) as Map<String, dynamic>;
          expect(decoded['schemaVersion'], 1);
          expect((decoded['categories'] as List).length, 1);
          expect((decoded['assets'] as List).length, 1);
        },
        failure: (error) => fail('Unexpected export error: $error'),
      );
    });

    test('restoreFromJson fails when asset references missing category',
        () async {
      final service = BackupService(
        assetRepository: FakeAssetRepository([]),
        categoryRepository: FakeCategoryRepository([]),
      );

      const invalidJson = '''
{
  "schemaVersion": 1,
  "exportedAt": "2026-03-07T00:00:00.000Z",
  "categories": [],
  "assets": [
    {
      "id": "a-1",
      "name": "Laptop",
      "categoryId": "missing-cat",
      "icon": "💻",
      "purchasePrice": 5000,
      "purchaseDate": "2026-01-01T00:00:00.000Z",
      "warrantyEndDate": null,
      "expectedLifeDays": null,
      "status": "using",
      "note": null,
      "createdAt": "2026-01-01T00:00:00.000Z",
      "updatedAt": "2026-01-01T00:00:00.000Z"
    }
  ]
}
''';

      final result = await service.restoreFromJson(invalidJson);

      result.when(
        success: (_) => fail('Expected restore validation failure'),
        failure: (error) {
          expect(error.toString(), contains('引用了不存在的分类 ID'));
        },
      );
    });

    test('restoreFromJson replaces existing data', () async {
      final categoryRepo = FakeCategoryRepository([
        _category(id: 'old-c1', name: '旧分类', icon: '📦', sortOrder: 1),
      ]);
      final assetRepo = FakeAssetRepository([
        _asset(id: 'old-a1', name: '旧资产', categoryId: 'old-c1'),
      ]);

      final service = BackupService(
        assetRepository: assetRepo,
        categoryRepository: categoryRepo,
      );

      const backupJson = '''
{
  "schemaVersion": 1,
  "exportedAt": "2026-03-07T00:00:00.000Z",
  "categories": [
    {
      "id": "c-1",
      "name": "新分类",
      "icon": "💻",
      "sortOrder": 1,
      "isDefault": false,
      "createdAt": "2026-01-01T00:00:00.000Z",
      "updatedAt": "2026-01-01T00:00:00.000Z"
    }
  ],
  "assets": [
    {
      "id": "a-1",
      "name": "新资产",
      "categoryId": "c-1",
      "icon": "💻",
      "purchasePrice": 8888,
      "purchaseDate": "2026-01-01T00:00:00.000Z",
      "warrantyEndDate": null,
      "expectedLifeDays": 365,
      "status": "idle",
      "note": "restored",
      "createdAt": "2026-01-01T00:00:00.000Z",
      "updatedAt": "2026-01-01T00:00:00.000Z"
    }
  ]
}
''';

      final result = await service.restoreFromJson(backupJson);

      result.when(
        success: (summary) {
          expect(summary.restoredCategoryCount, 1);
          expect(summary.restoredAssetCount, 1);
        },
        failure: (error) => fail('Unexpected restore error: $error'),
      );

      expect(categoryRepo.categories.length, 1);
      expect(categoryRepo.categories.first.name, '新分类');

      expect(assetRepo.assets.length, 1);
      expect(assetRepo.assets.first.name, '新资产');
      expect(assetRepo.assets.first.status, AssetStatus.idle);
    });
  });
}
