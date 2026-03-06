import '../entities/asset.dart';
import '../../../../core/errors/result.dart';

abstract class AssetRepository {
  Future<Result<Asset>> createAsset({
    required String name,
    required String categoryId,
    required String icon,
    required double purchasePrice,
    required DateTime purchaseDate,
    DateTime? warrantyEndDate,
    int? expectedLifeDays,
    String? note,
  });

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
  });

  Future<Result<void>> deleteAsset(String id);

  Future<Result<Asset?>> getAssetById(String id);

  Future<Result<List<Asset>>> getAllAssets();

  Future<Result<List<Asset>>> getAssetsByCategory(String categoryId);

  Future<Result<List<Asset>>> getAssetsByStatus(String status);
}
