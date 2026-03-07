import 'dart:convert';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/result.dart';
import '../../../home/domain/entities/asset.dart';
import '../../../home/domain/entities/category.dart';
import '../../../home/domain/repositories/asset_repository.dart';
import '../../../home/domain/repositories/category_repository.dart';
import '../../domain/entities/backup_payload.dart';

class BackupService {
  BackupService({
    required AssetRepository assetRepository,
    required CategoryRepository categoryRepository,
  })  : _assetRepository = assetRepository,
        _categoryRepository = categoryRepository;

  static const schemaVersion = 1;

  final AssetRepository _assetRepository;
  final CategoryRepository _categoryRepository;

  Future<Result<String>> exportBackupJson() async {
    try {
      final categories = await _getCategories();
      final assets = await _getAssets();

      final payload = BackupPayload(
        schemaVersion: schemaVersion,
        exportedAt: DateTime.now(),
        categories: categories
            .map(
              (item) => BackupCategoryRecord(
                id: item.id,
                name: item.name,
                icon: item.icon,
                description: item.description,
                sortOrder: item.sortOrder,
                isDefault: item.isDefault,
                createdAt: item.createdAt,
                updatedAt: item.updatedAt,
              ),
            )
            .toList(),
        assets: assets
            .map(
              (item) => BackupAssetRecord(
                id: item.id,
                name: item.name,
                categoryId: item.categoryId,
                icon: item.icon,
                purchasePrice: item.purchasePrice,
                purchaseDate: item.purchaseDate,
                warrantyEndDate: item.warrantyEndDate,
                expectedLifeDays: item.expectedLifeDays,
                status: item.status,
                note: item.note,
                createdAt: item.createdAt,
                updatedAt: item.updatedAt,
              ),
            )
            .toList(),
      );

      final jsonText =
          const JsonEncoder.withIndent('  ').convert(payload.toJson());
      return Success(jsonText);
    } on Exception catch (error) {
      return Failure(StorageException(message: '导出备份失败: $error'));
    }
  }

  Future<Result<BackupRestoreSummary>> restoreFromJson(String rawJson) async {
    if (rawJson.trim().isEmpty) {
      return Failure(ValidationException(message: '请输入备份 JSON 内容'));
    }

    final snapshotCategories = await _getCategories();
    final snapshotAssets = await _getAssets();

    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) {
        return Failure(ValidationException(message: '备份 JSON 顶层结构无效'));
      }

      final payload = BackupPayload.fromJson(decoded);
      final validateMessage = _validatePayload(payload);
      if (validateMessage != null) {
        return Failure(ValidationException(message: validateMessage));
      }

      final summary = await _replaceAllData(payload);
      return Success(summary);
    } on FormatException catch (error) {
      return Failure(ValidationException(message: '备份格式错误: ${error.message}'));
    } on Exception catch (error) {
      try {
        await _replaceWithSnapshot(
          categories: snapshotCategories,
          assets: snapshotAssets,
        );
      } catch (rollbackError) {
        return Failure(
          StorageException(
            message: '恢复失败且回滚失败: $error / $rollbackError',
          ),
        );
      }

      return Failure(StorageException(message: '恢复失败，已回滚原始数据: $error'));
    }
  }

  Future<List<Category>> _getCategories() async {
    final result = await _categoryRepository.getAllCategories();
    return result.when(
      success: (categories) => categories,
      failure: (error) => throw error,
    );
  }

  Future<List<Asset>> _getAssets() async {
    final result = await _assetRepository.getAllAssets();
    return result.when(
      success: (assets) => assets,
      failure: (error) => throw error,
    );
  }

  String? _validatePayload(BackupPayload payload) {
    if (payload.schemaVersion != schemaVersion) {
      return '不支持的备份版本: ${payload.schemaVersion}';
    }

    final categoryIds = payload.categories.map((item) => item.id).toList();
    final categoryIdSet = categoryIds.toSet();
    if (categoryIds.length != categoryIdSet.length) {
      return '分类 ID 存在重复';
    }

    final assetIds = payload.assets.map((item) => item.id).toList();
    final assetIdSet = assetIds.toSet();
    if (assetIds.length != assetIdSet.length) {
      return '资产 ID 存在重复';
    }

    for (final asset in payload.assets) {
      if (!categoryIdSet.contains(asset.categoryId)) {
        return '资产 ${asset.name} 引用了不存在的分类 ID: ${asset.categoryId}';
      }
    }

    return null;
  }

  Future<BackupRestoreSummary> _replaceAllData(BackupPayload payload) async {
    final currentAssets = await _getAssets();
    for (final asset in currentAssets) {
      final deleteResult = await _assetRepository.deleteAsset(asset.id);
      final deleteError = _errorFromResult(deleteResult);
      if (deleteError != null) {
        throw StorageException(message: deleteError);
      }
    }

    final currentCategories = await _getCategories();
    for (final category in currentCategories) {
      final deleteResult =
          await _categoryRepository.deleteCategory(category.id);
      final deleteError = _errorFromResult(deleteResult);
      if (deleteError != null) {
        throw StorageException(message: deleteError);
      }
    }

    final sortedCategories = [...payload.categories]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    final categoryIdMapping = <String, String>{};
    for (final category in sortedCategories) {
      final createResult = await _categoryRepository.createCategory(
        name: category.name,
        icon: category.icon,
        description: category.description,
        sortOrder: category.sortOrder,
        isDefault: category.isDefault,
      );
      final createError = _errorFromResult(createResult);
      if (createError != null) {
        throw StorageException(message: createError);
      }

      final created = createResult.when(
        success: (data) => data,
        failure: (error) => throw error,
      );
      categoryIdMapping[category.id] = created.id;
    }

    for (final asset in payload.assets) {
      final mappedCategoryId = categoryIdMapping[asset.categoryId];
      if (mappedCategoryId == null) {
        throw ValidationException(
          message: '资产 ${asset.name} 无法映射分类 ${asset.categoryId}',
        );
      }

      final createResult = await _assetRepository.createAsset(
        name: asset.name,
        categoryId: mappedCategoryId,
        icon: asset.icon,
        purchasePrice: asset.purchasePrice,
        purchaseDate: asset.purchaseDate,
        warrantyEndDate: asset.warrantyEndDate,
        expectedLifeDays: asset.expectedLifeDays,
        note: asset.note,
      );
      final createError = _errorFromResult(createResult);
      if (createError != null) {
        throw StorageException(message: createError);
      }

      final createdAsset = createResult.when(
        success: (data) => data,
        failure: (error) => throw error,
      );

      if (asset.status != AssetStatus.using) {
        final statusResult = await _assetRepository.updateAsset(
          id: createdAsset.id,
          status: asset.status,
        );
        final statusError = _errorFromResult(statusResult);
        if (statusError != null) {
          throw StorageException(message: statusError);
        }
      }
    }

    return BackupRestoreSummary(
      restoredCategoryCount: payload.categories.length,
      restoredAssetCount: payload.assets.length,
    );
  }

  Future<void> _replaceWithSnapshot({
    required List<Category> categories,
    required List<Asset> assets,
  }) async {
    final payload = BackupPayload(
      schemaVersion: schemaVersion,
      exportedAt: DateTime.now(),
      categories: categories
          .map(
            (item) => BackupCategoryRecord(
              id: item.id,
              name: item.name,
              icon: item.icon,
              description: item.description,
              sortOrder: item.sortOrder,
              isDefault: item.isDefault,
              createdAt: item.createdAt,
              updatedAt: item.updatedAt,
            ),
          )
          .toList(),
      assets: assets
          .map(
            (item) => BackupAssetRecord(
              id: item.id,
              name: item.name,
              categoryId: item.categoryId,
              icon: item.icon,
              purchasePrice: item.purchasePrice,
              purchaseDate: item.purchaseDate,
              warrantyEndDate: item.warrantyEndDate,
              expectedLifeDays: item.expectedLifeDays,
              status: item.status,
              note: item.note,
              createdAt: item.createdAt,
              updatedAt: item.updatedAt,
            ),
          )
          .toList(),
    );

    await _replaceAllData(payload);
  }

  String? _errorFromResult<T>(Result<T> result) {
    return result.when(
      success: (_) => null,
      failure: (error) => error.toString(),
    );
  }
}
