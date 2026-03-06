import 'package:uuid/uuid.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/result.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/local/db/app_database.dart';
import '../mappers/category_mapper.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final AppDatabase _database;
  static const _uuid = Uuid();

  CategoryRepositoryImpl({required AppDatabase database}) : _database = database;

  @override
  Future<Result<Category>> createCategory({
    required String name,
    required String icon,
    int sortOrder = 0,
    bool isDefault = false,
  }) async {
    try {
      final categoryId = _uuid.v4();
      final now = DateTime.now();

      final companion = CategoriesCompanion(
        id: Value(categoryId),
        name: Value(name),
        icon: Value(icon),
        sortOrder: Value(sortOrder),
        isDefault: Value(isDefault),
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      await _database.insertCategory(companion);

      final created = await _database.getCategoryById(categoryId);
      if (created == null) {
        return Failure(
          StorageException(message: 'Failed to retrieve created category'),
        );
      }

      return Success(CategoryMapper.toDomain(created));
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        StorageException(message: 'Failed to create category: $e'),
      );
    }
  }

  @override
  Future<Result<Category>> updateCategory({
    required String id,
    String? name,
    String? icon,
    int? sortOrder,
    bool? isDefault,
  }) async {
    try {
      final existing = await _database.getCategoryById(id);
      if (existing == null) {
        return Failure(
          NotFoundException(message: 'Category not found: $id'),
        );
      }

      final updated = existing.toCompanion(true).copyWith(
            name: Value(name ?? existing.name),
            icon: Value(icon ?? existing.icon),
            sortOrder: Value(sortOrder ?? existing.sortOrder),
            isDefault: Value(isDefault ?? existing.isDefault),
            updatedAt: Value(DateTime.now()),
          );

      await _database.updateCategory(updated);

      final result = await _database.getCategoryById(id);
      if (result == null) {
        return Failure(
          StorageException(message: 'Failed to retrieve updated category'),
        );
      }

      return Success(CategoryMapper.toDomain(result));
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        StorageException(message: 'Failed to update category: $e'),
      );
    }
  }

  @override
  Future<Result<void>> deleteCategory(String id) async {
    try {
      final existing = await _database.getCategoryById(id);
      if (existing == null) {
        return Failure(
          NotFoundException(message: 'Category not found: $id'),
        );
      }

      await _database.deleteCategory(id);
      return const Success(null);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        StorageException(message: 'Failed to delete category: $e'),
      );
    }
  }

  @override
  Future<Result<Category?>> getCategoryById(String id) async {
    try {
      final category = await _database.getCategoryById(id);
      return Success(category != null ? CategoryMapper.toDomain(category) : null);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        StorageException(message: 'Failed to fetch category: $e'),
      );
    }
  }

  @override
  Future<Result<List<Category>>> getAllCategories() async {
    try {
      final categories = await _database.getAllCategories();
      return Success(categories.map(CategoryMapper.toDomain).toList());
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        StorageException(message: 'Failed to fetch categories: $e'),
      );
    }
  }
}
