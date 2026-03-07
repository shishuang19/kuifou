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
      icon: 'laptop',
      color: 0xFF5B3DF5,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Category(
      id: '2',
      name: '家具家电',
      icon: 'chair',
      color: 0xFF8C52FF,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
    Category(
      id: '3',
      name: '运动健身',
      icon: 'fitness',
      color: 0xFF60A5FA,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Category(
      id: '4',
      name: '交通工具',
      icon: 'directions_car',
      color: 0xFF22C55E,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];
}
