// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeFilterCountHash() => r'bf84888e7af4e157992bb3a238d35f920fbf5291';

/// See also [activeFilterCount].
@ProviderFor(activeFilterCount)
final activeFilterCountProvider = AutoDisposeProvider<int>.internal(
  activeFilterCount,
  name: r'activeFilterCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeFilterCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveFilterCountRef = AutoDisposeProviderRef<int>;
String _$filteredAssetListHash() => r'b9837b32c1e8d1cceaad96d6058111161807c7d2';

/// See also [filteredAssetList].
@ProviderFor(filteredAssetList)
final filteredAssetListProvider =
    AutoDisposeFutureProvider<List<Asset>>.internal(
  filteredAssetList,
  name: r'filteredAssetListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredAssetListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredAssetListRef = AutoDisposeFutureProviderRef<List<Asset>>;
String _$assetFilterNotifierHash() =>
    r'45341b5d2fb724e91fb7f8eddbccb7ec464982bc';

/// See also [AssetFilterNotifier].
@ProviderFor(AssetFilterNotifier)
final assetFilterNotifierProvider =
    AutoDisposeNotifierProvider<AssetFilterNotifier, AssetFilterState>.internal(
  AssetFilterNotifier.new,
  name: r'assetFilterNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$assetFilterNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AssetFilterNotifier = AutoDisposeNotifier<AssetFilterState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
