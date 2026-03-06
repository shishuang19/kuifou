# 后端结构文档 (BACKEND_STRUCTURE.md)
## 亏否 - 本地优先后端架构设计

---

## 1. 架构定位

### 1.1 后端定义（本项目）
本项目为个人使用APP，V1采用**本地后端架构**，即：
- 业务逻辑层（UseCase / Service）
- 本地数据层（Repository + DAO）
- 本地持久化层（SQLite + 文件系统）

不依赖远程服务器即可完整运行。

### 1.2 架构目标
- 离线可用
- 数据安全可控
- 易于扩展云同步
- 支持未来多端迁移

---

## 2. 分层架构

```text
Application Layer (应用层)
  -> Domain Layer (领域层)
    -> Data Layer (数据层)
      -> Local Storage Layer (SQLite/File/KV)
```

### 2.1 Application Layer
负责：
- 页面调用入口
- 请求参数组织
- 异常映射为用户可读信息

示例：
- `AssetController`
- `ProfileController`

### 2.2 Domain Layer
负责：
- 核心业务规则
- 折旧计算逻辑
- 统计汇总逻辑

示例：
- `CreateAssetUseCase`
- `CalculateDailyCostUseCase`
- `GenerateYearReportUseCase`

### 2.3 Data Layer
负责：
- Repository接口实现
- DTO ↔ Entity 映射
- 数据源路由（DB / Cache / File）

示例：
- `AssetRepositoryImpl`
- `CategoryRepositoryImpl`

### 2.4 Storage Layer
负责：
- SQLite持久化
- 文件备份读写
- 轻量配置存储

---

## 3. 模块结构设计

```text
backend/
├── domain/
│   ├── entities/
│   │   ├── asset.dart
│   │   ├── category.dart
│   │   ├── user_profile.dart
│   │   └── daily_metrics.dart
│   ├── repositories/
│   │   ├── asset_repository.dart
│   │   ├── category_repository.dart
│   │   └── backup_repository.dart
│   ├── usecases/
│   │   ├── add_asset_usecase.dart
│   │   ├── update_asset_usecase.dart
│   │   ├── delete_asset_usecase.dart
│   │   ├── list_assets_usecase.dart
│   │   ├── calculate_asset_metrics_usecase.dart
│   │   ├── generate_dashboard_metrics_usecase.dart
│   │   ├── backup_data_usecase.dart
│   │   └── restore_data_usecase.dart
│   └── services/
│       ├── depreciation_service.dart
│       └── validation_service.dart
├── data/
│   ├── models/
│   │   ├── asset_model.dart
│   │   ├── category_model.dart
│   │   └── backup_model.dart
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── db/
│   │   │   │   ├── app_database.dart
│   │   │   │   ├── dao/
│   │   │   │   │   ├── asset_dao.dart
│   │   │   │   │   ├── category_dao.dart
│   │   │   │   │   └── metrics_dao.dart
│   │   │   │   └── migrations/
│   │   │   ├── kv/
│   │   │   │   └── settings_store.dart
│   │   │   └── file/
│   │   │       ├── backup_file_store.dart
│   │   │       └── icon_file_store.dart
│   ├── mappers/
│   │   ├── asset_mapper.dart
│   │   └── category_mapper.dart
│   └── repositories/
│       ├── asset_repository_impl.dart
│       ├── category_repository_impl.dart
│       └── backup_repository_impl.dart
└── shared/
    ├── errors/
    ├── result/
    ├── logger/
    └── constants/
```

---

## 4. 核心领域实体

### 4.1 Asset（资产）

字段定义：
- `id: String` (UUID)
- `name: String`
- `categoryId: String`
- `icon: String`
- `purchasePrice: Decimal`
- `purchaseDate: Date`
- `warrantyEndDate: Date?`
- `expectedLifeDays: Int?`
- `status: AssetStatus` (using/idle/disposed)
- `note: String?`
- `createdAt: DateTime`
- `updatedAt: DateTime`

派生字段（运行时计算或缓存）：
- `usageDays`
- `dailyCost`
- `residualValue`

### 4.2 Category（分类）
- `id`
- `name`
- `icon`
- `sortOrder`
- `isDefault`

### 4.3 DashboardMetrics（首页统计）
- `totalResidualValue`
- `todayCost`
- `assetCount`
- `estimatedDailyCost`
- `snapshotDate`

---

## 5. 数据库设计（SQLite）

### 5.1 表结构

#### assets
| 字段 | 类型 | 约束 |
|------|------|------|
| id | TEXT | PK |
| name | TEXT | NOT NULL |
| category_id | TEXT | NOT NULL, FK |
| icon | TEXT | NOT NULL |
| purchase_price | REAL | NOT NULL |
| purchase_date | TEXT | NOT NULL |
| warranty_end_date | TEXT | NULL |
| expected_life_days | INTEGER | NULL |
| status | TEXT | NOT NULL DEFAULT 'using' |
| note | TEXT | NULL |
| created_at | TEXT | NOT NULL |
| updated_at | TEXT | NOT NULL |
| deleted_at | TEXT | NULL (软删除) |

#### categories
| 字段 | 类型 | 约束 |
|------|------|------|
| id | TEXT | PK |
| name | TEXT | NOT NULL, UNIQUE |
| icon | TEXT | NOT NULL |
| sort_order | INTEGER | NOT NULL DEFAULT 0 |
| is_default | INTEGER | NOT NULL DEFAULT 0 |
| created_at | TEXT | NOT NULL |
| updated_at | TEXT | NOT NULL |

#### metrics_cache
| 字段 | 类型 | 约束 |
|------|------|------|
| id | INTEGER | PK AUTOINCREMENT |
| total_residual_value | REAL | NOT NULL |
| today_cost | REAL | NOT NULL |
| asset_count | INTEGER | NOT NULL |
| estimated_daily_cost | REAL | NOT NULL |
| snapshot_date | TEXT | NOT NULL |
| created_at | TEXT | NOT NULL |

### 5.2 索引建议
- `idx_assets_purchase_date`
- `idx_assets_category_id`
- `idx_assets_status`
- `idx_assets_deleted_at`
- `idx_categories_sort_order`

---

## 6. Repository接口定义

### 6.1 AssetRepository

```text
Future<Result<Asset>> createAsset(CreateAssetInput input)
Future<Result<Asset>> updateAsset(String id, UpdateAssetInput input)
Future<Result<void>> deleteAsset(String id)
Future<Result<List<Asset>>> listAssets(AssetQuery query)
Future<Result<Asset?>> getAssetById(String id)
Future<Result<DashboardMetrics>> getDashboardMetrics(Date date)
```

### 6.2 CategoryRepository

```text
Future<Result<List<Category>>> listCategories()
Future<Result<Category>> createCategory(CreateCategoryInput input)
Future<Result<Category>> updateCategory(String id, UpdateCategoryInput input)
Future<Result<void>> deleteCategory(String id)
```

### 6.3 BackupRepository

```text
Future<Result<String>> exportBackup(BackupScope scope)
Future<Result<void>> importBackup(String filePath)
Future<Result<List<BackupMeta>>> listBackups()
```

---

## 7. 核心业务服务

### 7.1 折旧计算服务 `DepreciationService`

职责：
- 计算使用天数
- 计算每日成本
- 计算残值
- 处理边界日期

规则：
- 使用天数最小为1，防止除零
- 支持按预期寿命计算（高级模式）
- 默认线性折旧

### 7.2 统计汇总服务 `MetricsService`

职责：
- 聚合所有资产统计
- 按筛选条件统计
- 生成日报快照

---

## 8. 任务调度与后台更新

### 8.1 调度触发时机
- App启动时
- App回到前台时
- 每日零点后首次打开时
- 资产数据变更后

### 8.2 更新任务
1. 读取有效资产
2. 更新派生指标
3. 刷新首页统计缓存
4. 通知UI刷新

---

## 9. 备份与恢复结构

### 9.1 备份文件格式

```json
{
  "version": "1.0.0",
  "backupTime": "2026-03-06T20:56:00+08:00",
  "device": "android",
  "assets": [],
  "categories": [],
  "settings": {},
  "checksum": "sha256:xxxx"
}
```

### 9.2 恢复流程安全策略
- 文件结构校验
- 版本兼容校验
- 校验码验证
- 先临时导入，成功后替换正式库
- 失败时自动回滚

---

## 10. 错误体系设计

### 10.1 错误分类
- `ValidationError`：输入参数不合法
- `NotFoundError`：资源不存在
- `StorageError`：本地读写失败
- `ConflictError`：数据冲突
- `BackupFormatError`：备份文件格式错误

### 10.2 错误返回规范
统一返回 `Result<T>`：
- `Result.success(data)`
- `Result.failure(error)`

UI层只处理业务语义，不直接暴露技术堆栈。

---

## 11. 数据迁移策略

### 11.1 数据库版本管理
- 每次Schema变更增加version
- 提供向前迁移脚本
- 禁止破坏性迁移直接上线

### 11.2 迁移流程
1. 检测旧版本
2. 执行迁移脚本
3. 数据一致性校验
4. 写入新版本标记

---

## 12. 安全策略

### 12.1 本地数据保护
- 可选数据库加密
- 备份文件可选加密
- 关键字段最小化存储

### 12.2 隐私策略
- 默认无网络上传
- 无埋点或仅匿名本地埋点
- 提供一键清除全部数据

---

## 13. 云同步扩展预留（V2）

### 13.1 同步接口草案

```text
POST   /sync/push
GET    /sync/pull?since=timestamp
POST   /backup/upload
GET    /backup/download/:id
```

### 13.2 冲突处理策略
- Last Write Wins（默认）
- 高价值字段可弹窗让用户选择
- 保留冲突日志供追溯

---

## 14. 可观测性与日志

### 14.1 日志内容
- 关键操作（新增/编辑/删除）
- 备份恢复过程
- 异常堆栈
- 性能耗时（慢查询）

### 14.2 日志存储
- 开发环境：控制台
- 生产环境：本地滚动日志文件（限制大小）

---

## 15. 测试策略（后端层）

### 15.1 单元测试
- DepreciationService
- ValidationService
- UseCase层

### 15.2 集成测试
- Repository + SQLite联调
- 备份导入导出闭环
- 数据迁移脚本

### 15.3 回归测试重点
- 时间相关计算
- 软删除逻辑
- 筛选排序正确性

---

## 16. 交付检查清单

上线前需满足：
- 数据库schema与迁移脚本齐全
- 关键UseCase单测通过
- 备份恢复验证通过
- 异常路径可回滚
- 性能指标达标

---

**文档版本：** v1.0  
**最后更新：** 2026-03-06  
**维护者：** S.S.
