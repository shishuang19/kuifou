// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'6b3fea5b2873d755394d57b5955f1a3a0fe80d1b';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = AutoDisposeProvider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = AutoDisposeProviderRef<AppDatabase>;
String _$assetRepositoryHash() => r'345aa32a70683ec00182e8ea5990593992e84be7';

/// See also [assetRepository].
@ProviderFor(assetRepository)
final assetRepositoryProvider = AutoDisposeProvider<AssetRepository>.internal(
  assetRepository,
  name: r'assetRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$assetRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AssetRepositoryRef = AutoDisposeProviderRef<AssetRepository>;
String _$assetListHash() => r'3c35422b7f1495506dceca41b28251ce838acf6f';

/// See also [assetList].
@ProviderFor(assetList)
final assetListProvider = AutoDisposeFutureProvider<List<Asset>>.internal(
  assetList,
  name: r'assetListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$assetListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AssetListRef = AutoDisposeFutureProviderRef<List<Asset>>;
String _$assetsByCategoryHash() => r'9f9baa7288a5e7cb7d10cf342ffeebd4b65b79e1';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [assetsByCategory].
@ProviderFor(assetsByCategory)
const assetsByCategoryProvider = AssetsByCategoryFamily();

/// See also [assetsByCategory].
class AssetsByCategoryFamily extends Family<AsyncValue<List<Asset>>> {
  /// See also [assetsByCategory].
  const AssetsByCategoryFamily();

  /// See also [assetsByCategory].
  AssetsByCategoryProvider call(
    String categoryId,
  ) {
    return AssetsByCategoryProvider(
      categoryId,
    );
  }

  @override
  AssetsByCategoryProvider getProviderOverride(
    covariant AssetsByCategoryProvider provider,
  ) {
    return call(
      provider.categoryId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'assetsByCategoryProvider';
}

/// See also [assetsByCategory].
class AssetsByCategoryProvider extends AutoDisposeFutureProvider<List<Asset>> {
  /// See also [assetsByCategory].
  AssetsByCategoryProvider(
    String categoryId,
  ) : this._internal(
          (ref) => assetsByCategory(
            ref as AssetsByCategoryRef,
            categoryId,
          ),
          from: assetsByCategoryProvider,
          name: r'assetsByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$assetsByCategoryHash,
          dependencies: AssetsByCategoryFamily._dependencies,
          allTransitiveDependencies:
              AssetsByCategoryFamily._allTransitiveDependencies,
          categoryId: categoryId,
        );

  AssetsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  Override overrideWith(
    FutureOr<List<Asset>> Function(AssetsByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetsByCategoryProvider._internal(
        (ref) => create(ref as AssetsByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Asset>> createElement() {
    return _AssetsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetsByCategoryProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssetsByCategoryRef on AutoDisposeFutureProviderRef<List<Asset>> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _AssetsByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Asset>>
    with AssetsByCategoryRef {
  _AssetsByCategoryProviderElement(super.provider);

  @override
  String get categoryId => (origin as AssetsByCategoryProvider).categoryId;
}

String _$assetsByStatusHash() => r'b9ee83f60569bb8d6209ea3be037d239efc44128';

/// See also [assetsByStatus].
@ProviderFor(assetsByStatus)
const assetsByStatusProvider = AssetsByStatusFamily();

/// See also [assetsByStatus].
class AssetsByStatusFamily extends Family<AsyncValue<List<Asset>>> {
  /// See also [assetsByStatus].
  const AssetsByStatusFamily();

  /// See also [assetsByStatus].
  AssetsByStatusProvider call(
    String status,
  ) {
    return AssetsByStatusProvider(
      status,
    );
  }

  @override
  AssetsByStatusProvider getProviderOverride(
    covariant AssetsByStatusProvider provider,
  ) {
    return call(
      provider.status,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'assetsByStatusProvider';
}

/// See also [assetsByStatus].
class AssetsByStatusProvider extends AutoDisposeFutureProvider<List<Asset>> {
  /// See also [assetsByStatus].
  AssetsByStatusProvider(
    String status,
  ) : this._internal(
          (ref) => assetsByStatus(
            ref as AssetsByStatusRef,
            status,
          ),
          from: assetsByStatusProvider,
          name: r'assetsByStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$assetsByStatusHash,
          dependencies: AssetsByStatusFamily._dependencies,
          allTransitiveDependencies:
              AssetsByStatusFamily._allTransitiveDependencies,
          status: status,
        );

  AssetsByStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final String status;

  @override
  Override overrideWith(
    FutureOr<List<Asset>> Function(AssetsByStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetsByStatusProvider._internal(
        (ref) => create(ref as AssetsByStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Asset>> createElement() {
    return _AssetsByStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetsByStatusProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssetsByStatusRef on AutoDisposeFutureProviderRef<List<Asset>> {
  /// The parameter `status` of this provider.
  String get status;
}

class _AssetsByStatusProviderElement
    extends AutoDisposeFutureProviderElement<List<Asset>>
    with AssetsByStatusRef {
  _AssetsByStatusProviderElement(super.provider);

  @override
  String get status => (origin as AssetsByStatusProvider).status;
}

String _$assetByIdHash() => r'c2235b6e57c640924afe6793df7ee5a415763342';

/// See also [assetById].
@ProviderFor(assetById)
const assetByIdProvider = AssetByIdFamily();

/// See also [assetById].
class AssetByIdFamily extends Family<AsyncValue<Asset?>> {
  /// See also [assetById].
  const AssetByIdFamily();

  /// See also [assetById].
  AssetByIdProvider call(
    String assetId,
  ) {
    return AssetByIdProvider(
      assetId,
    );
  }

  @override
  AssetByIdProvider getProviderOverride(
    covariant AssetByIdProvider provider,
  ) {
    return call(
      provider.assetId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'assetByIdProvider';
}

/// See also [assetById].
class AssetByIdProvider extends AutoDisposeFutureProvider<Asset?> {
  /// See also [assetById].
  AssetByIdProvider(
    String assetId,
  ) : this._internal(
          (ref) => assetById(
            ref as AssetByIdRef,
            assetId,
          ),
          from: assetByIdProvider,
          name: r'assetByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$assetByIdHash,
          dependencies: AssetByIdFamily._dependencies,
          allTransitiveDependencies: AssetByIdFamily._allTransitiveDependencies,
          assetId: assetId,
        );

  AssetByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assetId,
  }) : super.internal();

  final String assetId;

  @override
  Override overrideWith(
    FutureOr<Asset?> Function(AssetByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetByIdProvider._internal(
        (ref) => create(ref as AssetByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assetId: assetId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Asset?> createElement() {
    return _AssetByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetByIdProvider && other.assetId == assetId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assetId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssetByIdRef on AutoDisposeFutureProviderRef<Asset?> {
  /// The parameter `assetId` of this provider.
  String get assetId;
}

class _AssetByIdProviderElement extends AutoDisposeFutureProviderElement<Asset?>
    with AssetByIdRef {
  _AssetByIdProviderElement(super.provider);

  @override
  String get assetId => (origin as AssetByIdProvider).assetId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
