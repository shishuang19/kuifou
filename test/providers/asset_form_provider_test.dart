import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kuifou/core/errors/app_exception.dart';
import 'package:kuifou/core/errors/result.dart';
import 'package:kuifou/features/home/domain/entities/asset.dart';
import 'package:kuifou/features/home/domain/repositories/asset_repository.dart';
import 'package:kuifou/features/home/presentation/providers/asset_form_provider.dart';
import 'package:kuifou/features/home/presentation/providers/asset_list_provider.dart';
import 'package:kuifou/features/profile/domain/entities/profile_preferences.dart';
import 'package:kuifou/features/profile/presentation/providers/profile_preferences_provider.dart';

class _FakeAssetRepository implements AssetRepository {
  bool createCalled = false;
  bool updateCalled = false;
  bool failDuplicateOnCreate = false;

  String? lastName;
  String? lastCategoryId;
  AssetStatus? lastStatus;

  Asset _assetFromInput({
    required String id,
    required String name,
    required String categoryId,
    required String icon,
    required double purchasePrice,
    required DateTime purchaseDate,
    DateTime? warrantyEndDate,
    int? expectedLifeDays,
    AssetStatus status = AssetStatus.using,
    String? note,
  }) {
    return Asset(
      id: id,
      name: name,
      categoryId: categoryId,
      icon: icon,
      purchasePrice: purchasePrice,
      purchaseDate: purchaseDate,
      warrantyEndDate: warrantyEndDate,
      expectedLifeDays: expectedLifeDays,
      status: status,
      note: note,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
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
    createCalled = true;
    lastName = name;
    lastCategoryId = categoryId;

    if (failDuplicateOnCreate) {
      return Failure(
        StorageException(
          message:
              'SqliteException(2067): UNIQUE constraint failed: assets.category_id, assets.name',
        ),
      );
    }

    return Success(
      _assetFromInput(
        id: 'created-id',
        name: name,
        categoryId: categoryId,
        icon: icon,
        purchasePrice: purchasePrice,
        purchaseDate: purchaseDate,
        warrantyEndDate: warrantyEndDate,
        expectedLifeDays: expectedLifeDays,
        note: note,
      ),
    );
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
    updateCalled = true;
    lastName = name;
    lastCategoryId = categoryId;
    lastStatus = status;

    return Success(
      _assetFromInput(
        id: id,
        name: name ?? 'updated-asset',
        categoryId: categoryId ?? 'cat-default',
        icon: icon ?? '📦',
        purchasePrice: purchasePrice ?? 100,
        purchaseDate: purchaseDate ?? DateTime(2026, 1, 1),
        warrantyEndDate: warrantyEndDate,
        expectedLifeDays: expectedLifeDays,
        status: status ?? AssetStatus.using,
        note: note,
      ),
    );
  }

  @override
  Future<Result<void>> deleteAsset(String id) async => const Success(null);

  @override
  Future<Result<Asset?>> getAssetById(String id) async => const Success(null);

  @override
  Future<Result<List<Asset>>> getAllAssets() async => const Success([]);

  @override
  Future<Result<List<Asset>>> getAssetsByCategory(String categoryId) async =>
      const Success([]);

  @override
  Future<Result<List<Asset>>> getAssetsByStatus(String status) async =>
      const Success([]);
}

void main() {
  ProviderContainer createContainer(
    _FakeAssetRepository repository, {
    DepreciationMethodPreference? defaultMethod,
  }) {
    return ProviderContainer(
      overrides: [
        assetRepositoryProvider.overrideWith((ref) => repository),
        if (defaultMethod != null)
          defaultDepreciationMethodPreferenceProvider.overrideWith(
            (ref) => defaultMethod,
          ),
      ],
    );
  }

  group('AssetFormNotifier', () {
    test('save fails when required fields are empty', () async {
      final repository = _FakeAssetRepository();
      final container = createContainer(repository);
      addTearDown(container.dispose);

      final notifier = container.read(assetFormNotifierProvider.notifier);
      final success = await notifier.save();

      final state = container.read(assetFormNotifierProvider);
      expect(success, isFalse);
      expect(repository.createCalled, isFalse);
      expect(state.errors['name'], isNotNull);
      expect(state.errors['purchasePrice'], isNotNull);
      expect(state.errors['categoryId'], isNotNull);
    });

    test('save creates asset when form is valid', () async {
      final repository = _FakeAssetRepository();
      final container = createContainer(repository);
      addTearDown(container.dispose);

      final notifier = container.read(assetFormNotifierProvider.notifier);
      notifier.updateName('MacBook Air');
      notifier.updateCategoryId('cat-electronics');
      notifier.updateIcon('💻');
      notifier.updatePurchasePrice(8999);
      notifier.updatePurchaseDate(DateTime(2025, 1, 1));

      final success = await notifier.save();

      expect(success, isTrue);
      expect(repository.createCalled, isTrue);
      expect(repository.lastName, 'MacBook Air');
      expect(repository.lastCategoryId, 'cat-electronics');
    });

    test('save updates asset when editing', () async {
      final repository = _FakeAssetRepository();
      final container = createContainer(repository);
      addTearDown(container.dispose);

      final existing = Asset(
        id: 'asset-1',
        name: 'Old Camera',
        categoryId: 'cat-electronics',
        icon: '📷',
        purchasePrice: 3000,
        purchaseDate: DateTime(2024, 1, 1),
        status: AssetStatus.using,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final notifier = container.read(assetFormNotifierProvider.notifier);
      notifier.loadAsset(existing);
      notifier.updateName('New Camera');
      notifier.updateStatus(AssetStatus.idle);

      final success = await notifier.save();

      expect(success, isTrue);
      expect(repository.updateCalled, isTrue);
      expect(repository.lastName, 'New Camera');
      expect(repository.lastStatus, AssetStatus.idle);
    });

    test('create defaults follow depreciation method preference', () {
      final repository = _FakeAssetRepository();
      final container = createContainer(
        repository,
        defaultMethod: DepreciationMethodPreference.doubleDeclining,
      );
      addTearDown(container.dispose);

      final state = container.read(assetFormNotifierProvider);
      expect(
        state.depreciationMethod,
        DepreciationMethodPreference.doubleDeclining,
      );
      expect(
        state.expectedLifeDays,
        DepreciationMethodPreference.doubleDeclining.defaultExpectedLifeDays,
      );

      final purchase = state.purchaseDate;
      expect(
        state.warrantyEndDate,
        DateTime(purchase.year + 1, purchase.month, purchase.day),
      );
    });

    test('purchase date change auto-updates default warranty to +1 year', () {
      final repository = _FakeAssetRepository();
      final container = createContainer(repository);
      addTearDown(container.dispose);

      final notifier = container.read(assetFormNotifierProvider.notifier);
      notifier.updatePurchaseDate(DateTime(2026, 3, 11));

      final state = container.read(assetFormNotifierProvider);
      expect(state.warrantyEndDate, DateTime(2027, 3, 11));
    });

    test('save shows duplicate name error under name field', () async {
      final repository = _FakeAssetRepository()..failDuplicateOnCreate = true;
      final container = createContainer(repository);
      addTearDown(container.dispose);

      final notifier = container.read(assetFormNotifierProvider.notifier);
      notifier.updateName('重复资产');
      notifier.updateCategoryId('cat-electronics');
      notifier.updateIcon('📷');
      notifier.updatePurchasePrice(21323);
      notifier.updatePurchaseDate(DateTime(2026, 3, 11));

      final success = await notifier.save();
      final state = container.read(assetFormNotifierProvider);

      expect(success, isFalse);
      expect(state.errors['name'], '名称已存在');
      expect(state.errors['general'], isNull);
    });
  });
}
