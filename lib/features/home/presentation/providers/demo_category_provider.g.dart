// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demo_category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$demoCategoriesHash() => r'aedd7520771249cc4d1e14b4ce320cbd2d7c3583';

/// 演示用分类数据（Web 平台临时方案）
///
/// Copied from [demoCategories].
@ProviderFor(demoCategories)
final demoCategoriesProvider =
    AutoDisposeFutureProvider<List<Category>>.internal(
  demoCategories,
  name: r'demoCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$demoCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DemoCategoriesRef = AutoDisposeFutureProviderRef<List<Category>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
