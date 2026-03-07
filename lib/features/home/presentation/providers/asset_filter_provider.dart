import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/asset.dart';
import 'asset_list_provider.dart';

part 'asset_filter_provider.g.dart';

enum AssetSortOption {
  purchaseDateDesc,
  purchaseDateAsc,
  priceDesc,
  priceAsc,
}

class AssetFilterState {
  final String searchQuery;
  final String? categoryId;
  final AssetStatus? status;
  final AssetSortOption sortOption;

  const AssetFilterState({
    this.searchQuery = '',
    this.categoryId,
    this.status,
    this.sortOption = AssetSortOption.purchaseDateDesc,
  });

  AssetFilterState copyWith({
    String? searchQuery,
    String? categoryId,
    bool clearCategory = false,
    AssetStatus? status,
    bool clearStatus = false,
    AssetSortOption? sortOption,
  }) {
    return AssetFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      status: clearStatus ? null : (status ?? this.status),
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

@riverpod
class AssetFilterNotifier extends _$AssetFilterNotifier {
  @override
  AssetFilterState build() => const AssetFilterState();

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query.trim());
  }

  void setCategoryId(String? categoryId) {
    state = state.copyWith(
      categoryId: categoryId,
      clearCategory: categoryId == null,
    );
  }

  void setStatus(AssetStatus? status) {
    state = state.copyWith(
      status: status,
      clearStatus: status == null,
    );
  }

  void setSortOption(AssetSortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void clearFilters() {
    state = const AssetFilterState();
  }
}

@riverpod
int activeFilterCount(ActiveFilterCountRef ref) {
  final filter = ref.watch(assetFilterNotifierProvider);

  var count = 0;
  if (filter.searchQuery.isNotEmpty) {
    count++;
  }
  if (filter.categoryId != null) {
    count++;
  }
  if (filter.status != null) {
    count++;
  }

  return count;
}

@riverpod
Future<List<Asset>> filteredAssetList(FilteredAssetListRef ref) async {
  final assets = await ref.watch(assetListProvider.future);
  final filter = ref.watch(assetFilterNotifierProvider);

  Iterable<Asset> result = assets;

  if (filter.searchQuery.isNotEmpty) {
    final query = filter.searchQuery.toLowerCase();
    result = result.where((asset) => asset.name.toLowerCase().contains(query));
  }

  if (filter.categoryId != null) {
    result = result.where((asset) => asset.categoryId == filter.categoryId);
  }

  if (filter.status != null) {
    result = result.where((asset) => asset.status == filter.status);
  }

  final sorted = result.toList();

  switch (filter.sortOption) {
    case AssetSortOption.purchaseDateDesc:
      sorted.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
      break;
    case AssetSortOption.purchaseDateAsc:
      sorted.sort((a, b) => a.purchaseDate.compareTo(b.purchaseDate));
      break;
    case AssetSortOption.priceDesc:
      sorted.sort((a, b) => b.purchasePrice.compareTo(a.purchasePrice));
      break;
    case AssetSortOption.priceAsc:
      sorted.sort((a, b) => a.purchasePrice.compareTo(b.purchasePrice));
      break;
  }

  return sorted;
}
