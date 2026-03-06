import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/asset.dart';
import '../../domain/repositories/asset_repository.dart';
import '../datasources/local/db/app_database.dart';
import '../mappers/asset_mapper.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AppDatabase _database;
  static const _uuid = Uuid();

  AssetRepositoryImpl({required AppDatabase database}) : _database = database;

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
    try {
      final assetId = _uuid.v4();
      final now = DateTime.now();

      final companion = AssetsCompanion(
        id: Value(assetId),
        name: Value(name),
        categoryId: Value(categoryId),
        icon: Value(icon),
        purchasePrice: Value(purchasePrice),
        purchaseDate: Value(purchaseDate.toString().split(' ')[0]),
        warrantyEndDate: Value(warrantyEndDate?.toString().split(' ')[0]),
        expectedLifeDays: Value(expectedLifeDays),
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      await _database.insertAsset(companion);

      final created = await _database.getAsspetById(assetId);
      if (created == null) {
        return Failure(
          StorageException(message: 'Failed to retrieve created asset'),
        );
      }

      return Success(AssetMapper.toDomain(created));
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        StorageException(message: 'Failed to create asset: $e'),
      );
    }
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
    String? note,
  }) async {
    try {
      final existing = await _database.getAsspetById(id);
      if (existing == null) {
        return Failure(
          NotFoundException(message: 'Asset not found: $id'),
        );
      }

      final updated = existing.toCompanion(true).copyWith(
            name: Value(name ?? existing.name),
            categoryId: Value(categoryId ?? existing.categoryId),
            icon: Value(icon ?? existing.icon),
            purchasePrice: Value(purchasePrice ?? existing.purchasePrice),
            purchaseDate: Value(purchaseDate?.toString().split(' ')[0] ?? existing.purchaseDate),
            warrantyEndDate: Value(warrantyEndDate?.toString().split(' ')[0]),
            expectedLifeDays: Value(expectedLifeDays ?? existing.expectedLifeDays),
            note: Value(note ?? existing.note),
            updatedAt: Value(DateTime.now()),
          );

      await _database.updateAsset(updated);

      final result = await _database.getAsspetById(id);
      if (result == null) {
        return Failure(
          StorageException(message: 'Failed to retrieve updated asset'),
        );
      }

      return Success(AssetMapper.toDomain(result));
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        StorageException(message: 'Failed to update asset: $e'),
      );
    }
  }

  @override
  Future<Result<void>> deleteAsset(String id) async {
    try {
      final existing = await _database.getAsspetById(id);
      if (existing == null) {
        return Failure(
          NotFoundException(message: 'Asset not found: $id'),
        );
      }

      await _database.deleteAsset(id);
      return const Success(null);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        StorageException(message: 'Failed to delete asset: $e'),
      );
    }
  }

  @override
  Future<Result<Asset?>> getAssetById(String id) async {
    try {
      final asset = await _database.getAsspetById(id);
      return Success(asset != null ? AssetMapper.toDomain(asset) : null);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        StorageException(message: 'Failed to fetch asset: $e'),
      );
    }
  }

  @override
  Future<Result<List<Asset>>> getAllAssets() async {
    try {
      final assets = await _database.getAllAssets();
      return Success(assets.map(AssetMapper.toDomain).toList());
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        StorageException(message: 'Failed to fetch assets: $e'),
      );
    }
  }

  @override
  Future<Result<List<Asset>>> getAssetsByCategory(String categoryId) async {
    try {
      final assets = await _database.getAssetsByCategory(categoryId);
      return Success(assets.map(AssetMapper.toDomain).toList());
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        StorageException(message: 'Failed to fetch assets by category: $e'),
      );
    }
  }

  @override
  Future<Result<List<Asset>>> getAssetsByStatus(String status) async {
    try {
      final allAssets = await _database.getAllAssets();
      final filtered = allAssets
          .where((a) => a.status == status)
          .map(AssetMapper.toDomain)
          .toList();
      return Success(filtered);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        StorageException(message: 'Failed to fetch assets by status: $e'),
      );
    }
  }
}
