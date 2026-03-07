import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../../home/domain/entities/category.dart';
import '../../../home/domain/repositories/category_repository.dart';
import '../../../home/presentation/providers/asset_list_provider.dart';
import '../../../home/presentation/providers/category_list_provider.dart';

final categoryManagementNotifierProvider =
    AsyncNotifierProvider<CategoryManagementNotifier, List<Category>>(
        CategoryManagementNotifier.new);

class CategoryManagementNotifier extends AsyncNotifier<List<Category>> {
  CategoryRepository get _repository => ref.read(categoryRepositoryProvider);

  @override
  Future<List<Category>> build() async {
    return _loadCategories();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_loadCategories);
  }

  Future<String?> createCategory({
    required String name,
    required String icon,
    String description = '',
  }) async {
    final normalizedName = name.trim();
    final normalizedIcon = icon.trim();
    final normalizedDescription = description.trim();

    if (normalizedName.isEmpty) {
      return '分类名称不能为空';
    }
    if (normalizedName.length > 20) {
      return '分类名称不能超过20个字符';
    }
    if (normalizedIcon.isEmpty) {
      return '分类图标不能为空';
    }
    if (normalizedDescription.length > 120) {
      return '分类描述不能超过120个字符';
    }

    final categories = state.valueOrNull ?? await _loadCategories();
    final maxSortOrder = categories.fold<int>(
      0,
      (previousValue, element) =>
          previousValue > element.sortOrder ? previousValue : element.sortOrder,
    );

    final result = await _repository.createCategory(
      name: normalizedName,
      icon: normalizedIcon,
      description: normalizedDescription,
      sortOrder: maxSortOrder + 1,
      isDefault: false,
    );

    final message = _resultError(result);
    if (message != null) {
      return message;
    }

    await _reloadAfterMutation();
    return null;
  }

  Future<String?> updateCategory({
    required String id,
    required String name,
    required String icon,
    String description = '',
  }) async {
    final normalizedName = name.trim();
    final normalizedIcon = icon.trim();
    final normalizedDescription = description.trim();

    if (normalizedName.isEmpty) {
      return '分类名称不能为空';
    }
    if (normalizedName.length > 20) {
      return '分类名称不能超过20个字符';
    }
    if (normalizedIcon.isEmpty) {
      return '分类图标不能为空';
    }
    if (normalizedDescription.length > 120) {
      return '分类描述不能超过120个字符';
    }

    final result = await _repository.updateCategory(
      id: id,
      name: normalizedName,
      icon: normalizedIcon,
      description: normalizedDescription,
    );

    final message = _resultError(result);
    if (message != null) {
      return message;
    }

    await _reloadAfterMutation();
    return null;
  }

  Future<String?> deleteCategory(String id) async {
    final categories = state.valueOrNull ?? await _loadCategories();
    final target = categories.where((item) => item.id == id).firstOrNull;
    if (target == null) {
      return '分类不存在';
    }

    if (target.isDefault) {
      return '默认分类不允许删除';
    }

    final assets = await ref.read(assetListProvider.future);
    if (assets.any((asset) => asset.categoryId == id)) {
      return '该分类已被资产使用，无法删除';
    }

    final result = await _repository.deleteCategory(id);
    final message = _resultError(result);
    if (message != null) {
      return message;
    }

    await _reloadAfterMutation();
    return null;
  }

  Future<String?> moveCategoryUp(String id) async {
    return _swapSortOrder(id, direction: -1);
  }

  Future<String?> moveCategoryDown(String id) async {
    return _swapSortOrder(id, direction: 1);
  }

  Future<String?> reorderCategory({
    required int oldIndex,
    required int newIndex,
  }) async {
    final categories = state.valueOrNull ?? await _loadCategories();
    if (oldIndex < 0 || oldIndex >= categories.length) {
      return null;
    }

    var adjustedNewIndex = newIndex;
    if (adjustedNewIndex > oldIndex) {
      adjustedNewIndex -= 1;
    }

    if (adjustedNewIndex < 0 || adjustedNewIndex >= categories.length) {
      return null;
    }
    if (oldIndex == adjustedNewIndex) {
      return null;
    }

    final reordered = [...categories];
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(adjustedNewIndex, moved);

    for (var index = 0; index < reordered.length; index++) {
      final category = reordered[index];
      final expectedSortOrder = index + 1;
      if (category.sortOrder == expectedSortOrder) {
        continue;
      }

      final updateResult = await _repository.updateCategory(
        id: category.id,
        sortOrder: expectedSortOrder,
      );
      final error = _resultError(updateResult);
      if (error != null) {
        return error;
      }
    }

    await _reloadAfterMutation();
    return null;
  }

  Future<String?> _swapSortOrder(
    String id, {
    required int direction,
  }) async {
    final categories = state.valueOrNull ?? await _loadCategories();
    final sorted = [...categories]..sort((a, b) => a.sortOrder - b.sortOrder);

    final sourceIndex = sorted.indexWhere((item) => item.id == id);
    final targetIndex = sourceIndex + direction;

    if (sourceIndex < 0 || targetIndex < 0 || targetIndex >= sorted.length) {
      return null;
    }

    final source = sorted[sourceIndex];
    final target = sorted[targetIndex];

    final sourceUpdate = await _repository.updateCategory(
      id: source.id,
      sortOrder: target.sortOrder,
    );
    final sourceError = _resultError(sourceUpdate);
    if (sourceError != null) {
      return sourceError;
    }

    final targetUpdate = await _repository.updateCategory(
      id: target.id,
      sortOrder: source.sortOrder,
    );
    final targetError = _resultError(targetUpdate);
    if (targetError != null) {
      return targetError;
    }

    await _reloadAfterMutation();
    return null;
  }

  Future<List<Category>> _loadCategories() async {
    final result = await _repository.getAllCategories();

    return result.when(
      success: (categories) {
        final sorted = [...categories]
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        return sorted;
      },
      failure: (error) => throw error,
    );
  }

  Future<void> _reloadAfterMutation() async {
    state = await AsyncValue.guard(_loadCategories);
    ref.invalidate(categoryListProvider);
  }

  String? _resultError<T>(Result<T> result) {
    return result.when(
      success: (_) => null,
      failure: (error) => _normalizeError(error),
    );
  }

  String _normalizeError(Exception error) {
    final text = error.toString();
    return text.startsWith('AppException: ')
        ? text.replaceFirst('AppException: ', '')
        : text;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
