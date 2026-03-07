import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kuifou/core/errors/result.dart';
import 'package:kuifou/features/home/domain/entities/asset.dart';
import 'package:kuifou/features/home/domain/repositories/asset_repository.dart';
import 'package:kuifou/features/home/presentation/providers/asset_list_provider.dart';

class _FakeAssetRepository implements AssetRepository {
  final List<Asset> assets;

  _FakeAssetRepository(this.assets);

  @override
  Future<Result<List<Asset>>> getAllAssets() async {
    return Success(assets);
  }

  @override
  Future<Result<List<Asset>>> getAssetsByCategory(String categoryId) async {
    return Success(
      assets.where((asset) => asset.categoryId == categoryId).toList(),
    );
  }

  @override
  Future<Result<List<Asset>>> getAssetsByStatus(String status) async {
    return Success(
      assets.where((asset) => asset.status.value == status).toList(),
    );
  }

  @override
  Future<Result<Asset?>> getAssetById(String id) async {
    return Success(
      assets.where((asset) => asset.id == id).firstOrNull,
    );
  }

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
    throw UnimplementedError();
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
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> deleteAsset(String id) async {
    throw UnimplementedError();
  }
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
    purchasePrice: 1000,
    purchaseDate: DateTime(2026, 1, 1),
    status: status,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('Asset list providers', () {
    final mockAssets = [
      _asset(id: 'a1', name: 'MacBook', categoryId: 'cat-1'),
      _asset(id: 'a2', name: 'Bike', categoryId: 'cat-2', status: AssetStatus.idle),
      _asset(id: 'a3', name: 'Camera', categoryId: 'cat-1', status: AssetStatus.disposed),
    ];

    ProviderContainer createContainer() {
      return ProviderContainer(
        overrides: [
          assetRepositoryProvider.overrideWith(
            (ref) => _FakeAssetRepository(mockAssets),
          ),
        ],
      );
    }

    test('assetListProvider returns all assets', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      final result = await container.read(assetListProvider.future);
      expect(result.length, 3);
      expect(result.map((item) => item.id), ['a1', 'a2', 'a3']);
    });

    test('assetsByCategoryProvider filters by category', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      final result = await container.read(assetsByCategoryProvider('cat-1').future);
      expect(result.length, 2);
      expect(result.map((item) => item.id), ['a1', 'a3']);
    });

    test('assetsByStatusProvider filters by status', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      final result = await container.read(assetsByStatusProvider('idle').future);
      expect(result.length, 1);
      expect(result.first.id, 'a2');
    });

    test('assetByIdProvider returns target asset', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      final result = await container.read(assetByIdProvider('a3').future);
      expect(result, isNotNull);
      expect(result!.name, 'Camera');
    });
  });
}
