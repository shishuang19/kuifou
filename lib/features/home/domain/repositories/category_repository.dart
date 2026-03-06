import '../../domain/entities/category.dart';
import '../../../../core/errors/result.dart';

abstract class CategoryRepository {
  Future<Result<Category>> createCategory({
    required String name,
    required String icon,
    int sortOrder = 0,
    bool isDefault = false,
  });

  Future<Result<Category>> updateCategory({
    required String id,
    String? name,
    String? icon,
    int? sortOrder,
    bool? isDefault,
  });

  Future<Result<void>> deleteCategory(String id);

  Future<Result<Category?>> getCategoryById(String id);

  Future<Result<List<Category>>> getAllCategories();
}
