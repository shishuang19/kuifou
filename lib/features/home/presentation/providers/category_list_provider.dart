import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../../data/repositories/category_repository_impl.dart';
import 'asset_list_provider.dart';

part 'category_list_provider.g.dart';

// Category repository provider
@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(CategoryRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return CategoryRepositoryImpl(database: database);
}

// Category list provider (all categories)
@riverpod
Future<List<Category>> categoryList(CategoryListRef ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  final result = await repository.getAllCategories();

  return result.when(
    success: (categories) => categories,
    failure: (error) => throw error,
  );
}

// Get category by ID
@riverpod
Future<Category?> categoryById(
  CategoryByIdRef ref,
  String categoryId,
) async {
  final repository = ref.watch(categoryRepositoryProvider);
  final result = await repository.getCategoryById(categoryId);

  return result.when(
    success: (category) => category,
    failure: (error) => null,
  );
}
