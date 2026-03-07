# M3 进度：Profile / Category / Backup 高级能力

本阶段完成了亏否应用在个人中心、分类管理、备份恢复上的核心能力建设，并补齐了偏好设置与业务表单的联动。

## 阶段目标
- 完成 Profile 页面从占位到可用设置中心
- 完成 Category 管理（CRUD、删除保护、排序）
- 完成 Backup/Restore 的本地 JSON 备份恢复基础能力
- 打通偏好设置对 App 和表单默认值的影响
- 为分类扩展 description 字段并完成数据库迁移

## 已实现

### 1. Profile & Settings 基础
- 新增 `ProfilePreferences` 领域模型与枚举：
  - `ThemePreference`
  - `LanguagePreference`
  - `DepreciationMethodPreference`
- 新增 `ProfilePreferencesService`：
  - 基于 `SharedPreferences` 的本地持久化
  - 统一 key 前缀 `profile.*`
- 新增 `profilePreferencesNotifierProvider`：
  - 统一管理 loading/error/data 生命周期
- App 级接入：
  - `MaterialApp.router` 接入 `themeMode` 与 `locale`
  - 增加 `flutter_localizations` delegates 与 `supportedLocales`
- `ProfilePage` 完整实现：
  - 偏好设置（主题/语言/默认折旧方法）
  - 恢复默认设置
  - 功能入口（分类管理、备份恢复、FAQ）
  - 关于信息（版本、理念、版权）

### 2. Category 管理能力
- 新增 `CategoryPage` 与 `categoryManagementNotifierProvider`
- 完成分类 CRUD：新增、编辑、删除
- 删除保护：
  - 默认分类不可删除
  - 被资产引用的分类不可删除
- 排序能力：
  - 先实现 move up/down
  - 后续升级为拖拽排序（`ReorderableListView`）
- 展示增强：
  - 分类使用计数
  - 汇总卡片
  - 默认分类标识

### 3. Category Description 与迁移
- 领域模型新增 `Category.description`
- 仓储接口 `createCategory/updateCategory` 支持 `description`
- Drift 表结构新增 `categories.description` 列（默认空字符串）
- `AppDatabase.schemaVersion` 升级至 `2`
- 新增 v1 -> v2 迁移策略（`addColumn`）
- 数据流更新：
  - Mapper、RepositoryImpl、Web 内存仓储同步支持 description
  - 分类表单支持 description 输入与校验
  - 分类列表支持 description 展示

### 4. Backup / Restore 基础
- 新增备份领域模型：
  - `BackupPayload`
  - `BackupCategoryRecord`
  - `BackupAssetRecord`
  - `BackupRestoreSummary`
- 新增 `BackupService`：
  - `exportBackupJson()` 导出 JSON
  - `restoreFromJson()` 校验并恢复
  - schema/version/reference 校验
  - 恢复失败时回滚尝试
- 新增 `BackupRestorePage`：
  - 导出 JSON 与复制
  - 粘贴 JSON 并确认恢复
  - 恢复过程反馈

### 5. 偏好与业务表单联动
- 语言偏好驱动 `appLocaleProvider`
- 默认折旧方法驱动资产创建表单初始值：
  - 默认 `depreciationMethod`
  - 默认 `expectedLifeDays`
- `AssetFormPage` 增加折旧方法选择并自动回填寿命天数

### 6. 路由与导航扩展
- 新增路由：
  - `/categories`
  - `/backup`
- `ProfilePage` 内入口联动：
  - 分类管理
  - 备份与恢复

## 测试与验证
- Provider 测试新增/更新：
  - `test/providers/profile_preferences_provider_test.dart`
  - `test/providers/category_management_provider_test.dart`
  - `test/providers/backup_service_test.dart`
  - `test/providers/asset_form_provider_test.dart`
- Widget 测试新增/更新：
  - `test/widgets/profile_page_widget_test.dart`
  - `test/widgets/category_page_widget_test.dart`
  - `test/widgets/backup_restore_page_widget_test.dart`
- 关键验证结果：
  - `flutter test test/app_smoke_test.dart test/providers/ test/widgets/ test/integration/`: `+36` all passed
  - `flutter analyze`: no issues found
  - `flutter build web --release`: success

## 当前结论
- M3 已完成以下核心交付：
  - Profile 设置中心
  - Category 管理与排序（含拖拽）
  - Backup/Restore 基础 JSON 能力
  - 偏好设置与表单默认值联动
  - Category description 端到端支持与数据库迁移
- M3 剩余项聚焦在备份文件工作流增强：
  - 导出分享（share sheet）
  - 文件选择导入（file picker）
  - 可选完整性/加密方案

## 分支与提交流程（后续阶段）
从本阶段起，执行“每阶段一个分支”的提交策略：
- 分支命名建议：`phase/mX-<short-topic>`
- 建议流程：
  1. 从 `main` 切分支
  2. 在阶段分支内完成开发与验证
  3. 提交阶段版本
  4. 再合并回 `main`

---

**创建日期**: 2026-03-07
**状态**: M3（核心完成，备份文件工作流待收尾）
