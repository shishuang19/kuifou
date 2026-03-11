# 亏否 - M1 数据层完成指南

## 📋 当前状态
- ✅ Domain entities (Asset, Category, DashboardMetrics) - 已实现
- ✅ Repository interfaces - 已实现
- ✅ Repository implementations - 已实现
- ✅ Database schema (SQLite + drift) - 已定义
- ✅ Services (DepreciationService, ValidationService) - 已实现
- ✅ Error handling (AppException, Result<T>) - 已实现
- ⏳ Drift ORM 代码生成 - **需要本地 Flutter SDK**

## 🚀 下一步（需要在本地运行）

### 1. 安装 Flutter SDK

从 [flutter.dev](https://flutter.dev/docs/get-started/install) 下载 Flutter 3.24+

```bash
# 验证 Flutter 安装
flutter doctor

# 输出应该显示：
# [✓] Flutter
# [✓] Dart
# 等等
```

### 2. 生成 Drift ORM 代码

```bash
cd /path/to/kuifou

# 安装依赖
flutter pub get

# 生成 SQLite 绑定代码
# 这会创建 lib/features/home/data/datasources/local/db/app_database.g.dart
flutter pub run build_runner build
```

### 3. 验证代码生成

```bash
# 检查生成的文件
ls -la lib/features/home/data/datasources/local/db/app_database.g.dart

# 运行测试验证编译
flutter test test/app_smoke_test.dart
```

### 4. 创建 M1 单元测试（可选但推荐）

```bash
# 测试资产库
flutter test test/features/home/data/repositories/asset_repository_impl_test.dart

# 测试折旧服务
flutter test test/features/home/domain/services/depreciation_service_test.dart

# 测试验证服务
flutter test test/features/home/domain/services/validation_service_test.dart
```

### 5. 验证所有测试通过

```bash
flutter test
```

## 📚 快速检查清单

- [ ] 本地安装 Flutter 3.24+
- [ ] 运行 `flutter pub get`
- [ ] 运行 `flutter pub run build_runner build`
- [ ] 检查 `app_database.g.dart` 已生成
- [ ] 运行 `flutter test` 通过
- [ ] Git 提交任何生成的文件：`git add . && git commit -m "chore(M1): drift ORM code generation"`

## 🔑 关键文件

**数据层文件树**:
```
lib/
├── core/errors/
│   ├── app_exception.dart          # 异常体系
│   └── result.dart                 # Result<T> 返回类型
└── features/home/
    ├── domain/
    │   ├── entities/               # 领域模型
    │   │   ├── asset.dart
    │   │   ├── category.dart
    │   │   └── dashboard_metrics.dart
    │   ├── repositories/           # 仓储接口
    │   │   ├── asset_repository.dart
    │   │   └── category_repository.dart
    │   └── services/               # 业务逻辑
    │       ├── depreciation_service.dart
    │       └── validation_service.dart
    └── data/
        ├── datasources/local/db/   # SQLite 数据源
        │   ├── app_database.dart   # drift DB 定义
        │   ├── app_database.g.dart # ← 待生成
        │   └── tables/             # SQLite 表定义
        │       ├── assets_table.dart
        │       ├── categories_table.dart
        │       └── metrics_cache_table.dart
        ├── mappers/                # DTO 转换
        │   ├── asset_mapper.dart
        │   └── category_mapper.dart
        └── repositories/           # 仓储实现
            ├── asset_repository_impl.dart
            └── category_repository_impl.dart
```

## 🧪 测试示例（伪代码）

```dart
// test/features/home/domain/services/depreciation_service_test.dart
void main() {
  test('calculate daily cost correctly', () {
    final asset = Asset(
      id: '1',
      purchasePrice: 1000,
      purchaseDate: DateTime.now().subtract(Duration(days: 100)),
      // ...
    );
    
    // 应该是 1000 / 100 = 10
    expect(asset.dailyCost, 10.0);
  });
}
```

## ⚠️ 故障排除

**问题**: `app_database.g.dart` 未生成
```bash
# 解决：清除并重新生成
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build
```

**问题**: 导入错误 `part of` 不匹配
```bash
# 确保 app_database.dart 顶部有：
part 'app_database.g.dart';
```

**问题**: SQLite 版本不兼容
```bash
# build.yaml 中检查 SQLite 版本 (已设置为 3.46.0)
# 现代 Flutter 环境应该兼容
```

## 📅 下一阶段 (M2)

- 使用 Riverpod 创建 Provider 层
- 实现 Home 页面（资产列表）
- 实现 AssetForm 页面（新建/编辑资产）
- 实现 Search/Filter 功能

---
**创建日期**: 2026-03-06
**更新者**: AI Assistant
