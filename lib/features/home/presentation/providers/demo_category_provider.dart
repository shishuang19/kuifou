import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/category.dart';

part 'demo_category_provider.g.dart';

/// 演示用分类数据（Web 平台临时方案）
@riverpod
Future<List<Category>> demoCategories(DemoCategoriesRef ref) async {
  await Future.delayed(const Duration(milliseconds: 100));
  
  return [
    Category(
      id: '1',
      name: '电子产品',
      icon: '💻',
      sortOrder: 1,
      isDefault: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Category(
      id: '2',
      name: '家具家电',
      icon: '🪑',
      sortOrder: 2,
      isDefault: false,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      updatedAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
    Category(
      id: '3',
      name: '运动健身',
      icon: '🏋️',
      sortOrder: 3,
      isDefault: false,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Category(
      id: '4',
      name: '交通工具',
      icon: '🚗',
      sortOrder: 4,
      isDefault: false,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];
}
