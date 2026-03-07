import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/asset.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/asset_repository.dart';
import '../../domain/repositories/category_repository.dart';
import 'demo_data_provider.dart';

class WebInMemoryAssetRepository implements AssetRepository {
  String _nextId() => DateTime.now().microsecondsSinceEpoch.toString();

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
    final now = DateTime.now();
    final created = Asset(
      id: _nextId(),
      name: name,
      categoryId: categoryId,
      icon: icon,
      purchasePrice: purchasePrice,
      purchaseDate: purchaseDate,
      warrantyEndDate: warrantyEndDate,
      expectedLifeDays: expectedLifeDays,
      status: AssetStatus.using,
      note: note,
      createdAt: now,
      updatedAt: now,
    );

    demoAssets.insert(0, created);
    return Success(created);
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
    final index = demoAssets.indexWhere((asset) => asset.id == id);
    if (index == -1) {
      return Failure(NotFoundException(message: 'Asset not found: $id'));
    }

    final current = demoAssets[index];
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
      updatedAt: DateTime.now(),
    );

    demoAssets[index] = updated;
    return Success(updated);
  }

  @override
  Future<Result<void>> deleteAsset(String id) async {
    final before = demoAssets.length;
    demoAssets.removeWhere((asset) => asset.id == id);
    if (demoAssets.length == before) {
      return Failure(NotFoundException(message: 'Asset not found: $id'));
    }
    return const Success(null);
  }

  @override
  Future<Result<Asset?>> getAssetById(String id) async {
    final asset = demoAssets.where((item) => item.id == id).firstOrNull;
    return Success(asset);
  }

  @override
  Future<Result<List<Asset>>> getAllAssets() async {
    return Success(List.unmodifiable(demoAssets));
  }

  @override
  Future<Result<List<Asset>>> getAssetsByCategory(String categoryId) async {
    final assets = demoAssets
        .where((asset) => asset.categoryId == categoryId)
        .toList(growable: false);
    return Success(assets);
  }

  @override
  Future<Result<List<Asset>>> getAssetsByStatus(String status) async {
    final assets = demoAssets
        .where((asset) => asset.status.value == status)
        .toList(growable: false);
    return Success(assets);
  }
}

class WebInMemoryCategoryRepository implements CategoryRepository {
  String _nextId() => DateTime.now().microsecondsSinceEpoch.toString();

  @override
  Future<Result<Category>> createCategory({
    required String name,
    required String icon,
    int sortOrder = 0,
    bool isDefault = false,
  }) async {
    final now = DateTime.now();
    final created = Category(
      id: _nextId(),
      name: name,
      icon: icon,
      sortOrder: sortOrder,
      isDefault: isDefault,
      createdAt: now,
      updatedAt: now,
    );

    demoCategories.add(created);
    return Success(created);
  }

  @override
  Future<Result<Category>> updateCategory({
    required String id,
    String? name,
    String? icon,
    int? sortOrder,
    bool? isDefault,
  }) async {
    final index = demoCategories.indexWhere((category) => category.id == id);
    if (index == -1) {
      return Failure(NotFoundException(message: 'Category not found: $id'));
    }

    final current = demoCategories[index];
    final updated = Category(
      id: current.id,
      name: name ?? current.name,
      icon: icon ?? current.icon,
      sortOrder: sortOrder ?? current.sortOrder,
      isDefault: isDefault ?? current.isDefault,
      createdAt: current.createdAt,
      updatedAt: DateTime.now(),
    );

    demoCategories[index] = updated;
    return Success(updated);
  }

  @override
  Future<Result<void>> deleteCategory(String id) async {
    final before = demoCategories.length;
    demoCategories.removeWhere((category) => category.id == id);
    if (demoCategories.length == before) {
      return Failure(NotFoundException(message: 'Category not found: $id'));
    }
    return const Success(null);
  }

  @override
  Future<Result<Category?>> getCategoryById(String id) async {
    final category = demoCategories.where((item) => item.id == id).firstOrNull;
    return Success(category);
  }

  @override
  Future<Result<List<Category>>> getAllCategories() async {
    final categories = demoCategories.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return Success(categories);
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
