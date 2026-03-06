# M1 进度：数据层实现

本阶段完成了亏否应用的本地数据层骨架，包括：

## 已实现  

### 1. Domain Layer（领域层）
- **Entities**:
  - `Asset`: 资产实体，包含购买价格、使用天数、每日成本、残值自动计算
  - `Category`: 分类实体
  - `DashboardMetrics`: 首页统计指标
  
- **Repositories (Interfaces)**:
  - `AssetRepository`: CRUD 接口  
  - `CategoryRepository`: CRUD 接口

- **Services**:
  - `DepreciationService`: 折旧计算（使用天数、每日成本、残值）
  - `ValidationService`: 输入验证（名称、价格、日期等）

### 2. Data Layer（数据层）

#### Database (SQLite + Drift ORM)
- **Tables**:
  - `assets`: 资产表（含软删除、索引）
  - `categories`: 分类表（含排序字段）
  - `metrics_cache`: 统计缓存表

- **AppDatabase**: drift 数据库定义，包含 DAO 方法

#### Repositories Implementation
- `AssetRepositoryImpl`: 资产 CRUD 完整实现
- `CategoryRepositoryImpl`: 分类 CRUD 完整实现

#### Mappers
- `AssetMapper`: DB entity → Domain entity 转换
- `CategoryMapper`: DB entity → Domain entity 转换

### 3. Core Layer（核心层）
- `AppException`: 自定义异常体系（Validation, Storage, NotFound, Conflict）
- `Result<T>`: 统一的 Success/Failure 返回类型

## 下一步

1. **需要 Flutter SDK**：本地需要安装 Flutter 3.24+ 以运行代码生成
   ```bash
   flutter pub get
   flutter pub run build_runner build
   ```

2. **M2 前端开发**：
   - 页面实现（Home / AssetForm / Profile）
   - Riverpod Provider 绑定
   - UI 交互与状态管理

3. **CI 配置**：GitHub Actions 自动化 lint/test/build

## 文件树
```
lib/
├── core/errors/
│   ├── app_exception.dart
│   └── result.dart
└── features/home/
    ├── domain/
    │   ├── entities/
    │   │   ├── asset.dart
    │   │   ├── category.dart
    │   │   └── dashboard_metrics.dart
    │   ├── repositories/
    │   │   ├── asset_repository.dart
    │   │   └── category_repository.dart
    │   └── services/
    │       ├── depreciation_service.dart
    │       └── validation_service.dart
    └── data/
        ├── datasources/local/db/
        │   ├── app_database.dart
        │   └── tables/
        │       ├── assets_table.dart
        │       ├── categories_table.dart
        │       └── metrics_cache_table.dart
        ├── mappers/
        │   ├── asset_mapper.dart
        │   └── category_mapper.dart
        └── repositories/
            ├── asset_repository_impl.dart
            └── category_repository_impl.dart
```

**提交哈希**: [待提交]  
**创建日期**: 2026-03-06
