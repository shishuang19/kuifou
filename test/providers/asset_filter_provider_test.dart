import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kuifou/features/home/domain/entities/asset.dart';
import 'package:kuifou/features/home/presentation/providers/asset_filter_provider.dart';
import 'package:kuifou/features/home/presentation/providers/asset_list_provider.dart';

Asset _asset({
  required String id,
  required String name,
  required String categoryId,
  required double price,
  required DateTime purchaseDate,
  AssetStatus status = AssetStatus.using,
}) {
  return Asset(
    id: id,
    name: name,
    categoryId: categoryId,
    icon: '📦',
    purchasePrice: price,
    purchaseDate: purchaseDate,
    status: status,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('AssetFilterProvider', () {
    final sampleAssets = [
      _asset(
        id: 'a1',
        name: 'MacBook Pro',
        categoryId: 'cat-electronics',
        price: 12000,
        purchaseDate: DateTime(2026, 1, 15),
      ),
      _asset(
        id: 'a2',
        name: 'Camera',
        categoryId: 'cat-electronics',
        price: 3500,
        purchaseDate: DateTime(2025, 5, 10),
      ),
      _asset(
        id: 'a3',
        name: 'Road Bike',
        categoryId: 'cat-sports',
        price: 4200,
        purchaseDate: DateTime(2024, 9, 5),
        status: AssetStatus.idle,
      ),
    ];

    ProviderContainer createContainer() {
      return ProviderContainer(
        overrides: [
          assetListProvider.overrideWith((ref) async => sampleAssets),
        ],
      );
    }

    test('activeFilterCount reflects selected filters', () {
      final container = createContainer();
      addTearDown(container.dispose);

      expect(container.read(activeFilterCountProvider), 0);

      final notifier = container.read(assetFilterNotifierProvider.notifier);
      notifier.setSearchQuery('mac');
      expect(container.read(activeFilterCountProvider), 1);

      notifier.setCategoryId('cat-electronics');
      expect(container.read(activeFilterCountProvider), 2);

      notifier.setStatus(AssetStatus.using);
      expect(container.read(activeFilterCountProvider), 3);

      notifier.clearFilters();
      expect(container.read(activeFilterCountProvider), 0);
    });

    test('filteredAssetList filters by search and status', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      final notifier = container.read(assetFilterNotifierProvider.notifier);
      notifier.setSearchQuery('mac');
      notifier.setStatus(AssetStatus.using);

      container.invalidate(filteredAssetListProvider);
      final filtered = await container.read(filteredAssetListProvider.future);

      expect(filtered.length, 1);
      expect(filtered.first.id, 'a1');
    });

    test('filteredAssetList applies price sort', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      final notifier = container.read(assetFilterNotifierProvider.notifier);
      notifier.setSortOption(AssetSortOption.priceAsc);

      container.invalidate(filteredAssetListProvider);
      final filtered = await container.read(filteredAssetListProvider.future);

      expect(filtered.map((item) => item.id).toList(), ['a2', 'a3', 'a1']);
    });
  });
}
