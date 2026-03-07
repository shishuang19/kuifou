import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kuifou/core/errors/app_exception.dart';
import 'package:kuifou/core/errors/result.dart';
import 'package:kuifou/features/category/category_page.dart';
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
    final category = Category(
      id: 'id-${categories.length + 1}',
      name: name,
      icon: icon,
      description: description,
      sortOrder: sortOrder,
      isDefault: isDefault,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
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
    purchasePrice: 120,
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
  group('CategoryPage', () {
    testWidgets('renders category list and usage count',
        (WidgetTester tester) async {
      final repository = FakeCategoryRepository([
        _category(
            id: 'c1', name: '数码', icon: '💻', sortOrder: 1, isDefault: true),
        _category(id: 'c2', name: '家居', icon: '🪑', sortOrder: 2),
      ]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoryRepositoryProvider.overrideWith((ref) => repository),
            assetListProvider.overrideWith((ref) async => [
                  _asset(id: 'a1', categoryId: 'c1'),
                  _asset(id: 'a2', categoryId: 'c1'),
                ]),
          ],
          child: const MaterialApp(home: CategoryPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('分类管理'), findsOneWidget);
      expect(find.text('数码'), findsOneWidget);
      expect(find.text('家居'), findsOneWidget);
      expect(find.textContaining('关联 2 个资产'), findsOneWidget);
      expect(find.text('新增分类'), findsOneWidget);
    });
  });
}
