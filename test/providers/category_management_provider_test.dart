import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kuifou/core/errors/app_exception.dart';
import 'package:kuifou/core/errors/result.dart';
import 'package:kuifou/features/category/presentation/providers/category_management_provider.dart';
import 'package:kuifou/features/home/domain/entities/asset.dart';
import 'package:kuifou/features/home/domain/entities/category.dart';
import 'package:kuifou/features/home/domain/repositories/category_repository.dart';
import 'package:kuifou/features/home/presentation/providers/asset_list_provider.dart';
import 'package:kuifou/features/home/presentation/providers/category_list_provider.dart';

class FakeCategoryRepository implements CategoryRepository {
  FakeCategoryRepository(this.categories);

  final List<Category> categories;

  @override
  Future<Result<Category>> createCategory({
    required String name,
    required String icon,
    String description = '',
    int sortOrder = 0,
    bool isDefault = false,
  }) async {
    final now = DateTime(2026, 1, 1);
    final category = Category(
      id: 'id-${categories.length + 1}',
      name: name,
      icon: icon,
      description: description,
      sortOrder: sortOrder,
      isDefault: isDefault,
      createdAt: now,
      updatedAt: now,
    );
    categories.add(category);
    return Success(category);
  }

  @override
  Future<Result<void>> deleteCategory(String id) async {
    final before = categories.length;
    categories.removeWhere((item) => item.id == id);
    if (before == categories.length) {
      return Failure(NotFoundException(message: 'Category not found: $id'));
    }
    return const Success(null);
  }

  @override
  Future<Result<List<Category>>> getAllCategories() async {
    final sorted = [...categories]..sort((a, b) => a.sortOrder - b.sortOrder);
    return Success(sorted);
  }

  @override
  Future<Result<Category?>> getCategoryById(String id) async {
    return Success(categories.where((item) => item.id == id).firstOrNull);
  }

  @override
  Future<Result<Category>> updateCategory({
    required String id,
    String? name,
    String? icon,
    String? description,
    int? sortOrder,
    bool? isDefault,
  }) async {
    final index = categories.indexWhere((item) => item.id == id);
    if (index == -1) {
      return Failure(NotFoundException(message: 'Category not found: $id'));
    }

    final current = categories[index];
    final updated = Category(
      id: current.id,
      name: name ?? current.name,
      icon: icon ?? current.icon,
      description: description ?? current.description,
      sortOrder: sortOrder ?? current.sortOrder,
      isDefault: isDefault ?? current.isDefault,
      createdAt: current.createdAt,
      updatedAt: DateTime(2026, 1, 2),
    );
    categories[index] = updated;
    return Success(updated);
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => this.isEmpty ? null : first;
}

Asset _asset({required String id, required String categoryId}) {
  return Asset(
    id: id,
    name: 'Asset $id',
    categoryId: categoryId,
    icon: '📦',
    purchasePrice: 100,
    purchaseDate: DateTime(2026, 1, 1),
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

Category _category({
  required String id,
  required String name,
  required String icon,
  required int sortOrder,
  bool isDefault = false,
}) {
  return Category(
    id: id,
    name: name,
    icon: icon,
    sortOrder: sortOrder,
    isDefault: isDefault,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('CategoryManagementNotifier', () {
    test('deleteCategory blocks category in use', () async {
      final repository = FakeCategoryRepository([
        _category(id: 'c1', name: '数码', icon: '💻', sortOrder: 1),
      ]);

      final container = ProviderContainer(
        overrides: [
          categoryRepositoryProvider.overrideWith((ref) => repository),
          assetListProvider.overrideWith((ref) async => [
                _asset(id: 'a1', categoryId: 'c1'),
              ]),
        ],
      );
      addTearDown(container.dispose);

      await container.read(categoryManagementNotifierProvider.future);

      final message = await container
          .read(categoryManagementNotifierProvider.notifier)
          .deleteCategory('c1');

      expect(message, '该分类已被资产使用，无法删除');
      expect(repository.categories.length, 1);
    });

    test('createCategory appends with next sort order', () async {
      final repository = FakeCategoryRepository([
        _category(id: 'c1', name: '数码', icon: '💻', sortOrder: 1),
      ]);

      final container = ProviderContainer(
        overrides: [
          categoryRepositoryProvider.overrideWith((ref) => repository),
          assetListProvider.overrideWith((ref) async => const []),
        ],
      );
      addTearDown(container.dispose);

      await container.read(categoryManagementNotifierProvider.future);

      final message = await container
          .read(categoryManagementNotifierProvider.notifier)
          .createCategory(name: '运动', icon: '🏃');

      expect(message, isNull);
      expect(repository.categories.length, 2);
      expect(repository.categories.last.sortOrder, 2);
    });

    test('moveCategoryDown swaps sort order with next item', () async {
      final repository = FakeCategoryRepository([
        _category(id: 'c1', name: '数码', icon: '💻', sortOrder: 1),
        _category(id: 'c2', name: '家居', icon: '🪑', sortOrder: 2),
      ]);

      final container = ProviderContainer(
        overrides: [
          categoryRepositoryProvider.overrideWith((ref) => repository),
          assetListProvider.overrideWith((ref) async => const []),
        ],
      );
      addTearDown(container.dispose);

      await container.read(categoryManagementNotifierProvider.future);

      final message = await container
          .read(categoryManagementNotifierProvider.notifier)
          .moveCategoryDown('c1');

      expect(message, isNull);
      final sorted = [...repository.categories]
        ..sort((a, b) => a.sortOrder - b.sortOrder);
      expect(sorted.first.id, 'c2');
      expect(sorted.last.id, 'c1');
    });

    test('reorderCategory moves item to target position', () async {
      final repository = FakeCategoryRepository([
        _category(id: 'c1', name: '数码', icon: '💻', sortOrder: 1),
        _category(id: 'c2', name: '家居', icon: '🪑', sortOrder: 2),
        _category(id: 'c3', name: '运动', icon: '🏃', sortOrder: 3),
      ]);

      final container = ProviderContainer(
        overrides: [
          categoryRepositoryProvider.overrideWith((ref) => repository),
          assetListProvider.overrideWith((ref) async => const []),
        ],
      );
      addTearDown(container.dispose);

      await container.read(categoryManagementNotifierProvider.future);

      final message = await container
          .read(categoryManagementNotifierProvider.notifier)
          .reorderCategory(oldIndex: 0, newIndex: 3);

      expect(message, isNull);
      final sorted = [...repository.categories]
        ..sort((a, b) => a.sortOrder - b.sortOrder);
      expect(sorted.map((item) => item.id).toList(), ['c2', 'c3', 'c1']);
      expect(sorted.map((item) => item.sortOrder).toList(), [1, 2, 3]);
    });
  });
}
