import '../../domain/entities/category.dart';
import '../datasources/local/db/app_database.dart';

class CategoryMapper {
  CategoryMapper._();

  static Category toDomain(CategoryDb dbModel) {
    return Category(
      id: dbModel.id,
      name: dbModel.name,
      icon: dbModel.icon,
      sortOrder: dbModel.sortOrder,
      isDefault: dbModel.isDefault,
      createdAt: dbModel.createdAt,
      updatedAt: dbModel.updatedAt,
    );
  }
}
