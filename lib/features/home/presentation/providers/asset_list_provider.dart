import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/asset.dart';
import '../../domain/repositories/asset_repository.dart';
import '../../data/repositories/asset_repository_impl.dart';
import '../../data/datasources/local/db/app_database.dart';
import 'package:drift/native.dart';

part 'asset_list_provider.g.dart';

// Database provider (singleton)
@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  return AppDatabase(NativeDatabase.memory());
}

// Asset repository provider
@riverpod
AssetRepository assetRepository(AssetRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return AssetRepositoryImpl(database: database);
}

// Asset list provider (all assets)
@riverpod
Future<List<Asset>> assetList(AssetListRef ref) async {
  final repository = ref.watch(assetRepositoryProvider);
  final result = await repository.getAllAssets();
  
  return result.when(
    success: (assets) => assets,
    failure: (error) => throw error,
  );
}

// Assets by category
@riverpod
Future<List<Asset>> assetsByCategory(
  AssetsByCategoryRef ref,
  String categoryId,
) async {
  final repository = ref.watch(assetRepositoryProvider);
  final result = await repository.getAssetsByCategory(categoryId);
  
  return result.when(
    success: (assets) => assets,
    failure: (error) => throw error,
  );
}

// Assets by status
@riverpod
Future<List<Asset>> assetsByStatus(
  AssetsByStatusRef ref,
  String status,
) async {
  final repository = ref.watch(assetRepositoryProvider);
  final result = await repository.getAssetsByStatus(status);
  
  return result.when(
    success: (assets) => assets,
    failure: (error) => throw error,
  );
}
