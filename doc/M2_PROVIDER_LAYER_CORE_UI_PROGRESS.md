# M2 进度：Provider Layer & Core UI

本阶段完成了亏否应用的状态管理骨架和首页核心 UI，重点是将 M1 的数据层能力接入 Riverpod，并提供可复用的展示组件。

## 阶段目标
- 建立 Riverpod Provider 层，承接数据库与仓储能力
- 完成 HomePage 核心界面（统计面板 + 资产列表）
- 完成 AssetFormPage（创建/编辑）并打通核心路由
- 完成搜索与筛选（名称/分类/状态/排序）

## 已实现

### 1. Provider Layer（状态管理层）
- `asset_list_provider.dart`
  - 提供 `appDatabaseProvider`、`assetRepositoryProvider`
  - 提供 `assetListProvider`、`assetsByCategoryProvider`、`assetsByStatusProvider`
- `category_list_provider.dart`
  - 提供 `categoryRepositoryProvider`、`categoryListProvider`、`categoryByIdProvider`
- `dashboard_metrics_provider.dart`
  - 基于资产列表计算首页指标：
  - `totalResidualValue`、`todayCost`、`assetCount`、`estimatedDailyCost`
- `asset_form_provider.dart`
  - 定义 `AssetFormState` 与 `AssetFormNotifier`
  - 提供字段更新、校验、保存（新增/编辑）能力

### 2. Provider 代码生成
- 通过 `riverpod_annotation` + `riverpod_generator` 生成 `.g.dart` 文件
- 已生成：
  - `asset_list_provider.g.dart`
  - `category_list_provider.g.dart`
  - `dashboard_metrics_provider.g.dart`
  - `asset_form_provider.g.dart`

### 3. Core UI Components（核心组件）
- `dashboard_metrics_card.dart`
  - 首页统计卡片（4 指标展示）
  - 使用渐变背景与统一数值格式
- `asset_list_item.dart`
  - 单资产卡片展示
  - 包含状态徽章、折旧进度、关键金额信息

### 4. HomePage 集成
- `home_page.dart` 从 `StatelessWidget` 重构为 `ConsumerWidget`
- 接入 `dashboardMetricsProvider` 和 `assetListProvider`
- 完成以下状态展示：
  - loading
  - error
  - empty
  - data
- 支持下拉刷新（`ref.invalidate(...)`）

### 5. AssetFormPage（创建/编辑）
- `asset_form_page.dart` 从占位页升级为完整表单页
  - 字段：名称、分类、图标、购买价格、购买日期、保修日期、寿命天数、状态、备注
  - 校验：对接 `AssetFormNotifier` 的 `errors` 显示字段错误与通用错误
  - 交互：保存、取消、日期选择、图标选择
- 分类空状态处理：支持一键创建默认分类（`日常`、`电子`、`出行`）
- 编辑能力：通过 `assetByIdProvider` 加载并回填资产数据

### 6. 路由与页面联动
- 路由新增：
  - `/asset/new`（新增资产）
  - `/asset/:id/edit`（编辑资产）
  - `/add` 重定向到 `/asset/new`（兼容旧入口）
- 首页联动：
  - FAB -> `/asset/new`
  - 资产卡片点击 -> `/asset/:id/edit`

### 7. 架构与依赖调整
- `ProviderScope` 由 `main.dart` 移入 `app.dart`，保证测试与运行入口一致
- 扩展仓储更新接口：`AssetRepository.updateAsset(...)` 新增 `status` 参数支持
- 依赖更新：
  - 新增 `riverpod_annotation: ^2.6.1`
  - 新增 `riverpod_generator: ^2.6.5`
  - `build_runner` 调整为 `^2.5.4`（兼容 riverpod_generator）

### 8. Search & Filter（搜索与筛选）
- 新增 `asset_filter_provider.dart`：
  - `AssetFilterNotifier`（搜索词/分类/状态/排序）
  - `activeFilterCountProvider`
  - `filteredAssetListProvider`
- HomePage 新增：
  - 搜索输入框（按资产名过滤）
  - 筛选底部弹窗（状态、分类、排序）
  - 筛选数量徽标
  - 空状态区分（无数据 vs 无匹配结果）

## 关键问题与修复记录
- 修复 `No ProviderScope found`：将 `ProviderScope` 放到 `KuifouApp` 内
- 修复首页标题断言失败：测试文本由 `首页` 更新为 `亏否`
- 修复导入路径深度错误、类型不匹配、缺失参数等编译问题

## 验证结果
- `flutter pub run build_runner build --delete-conflicting-outputs`：通过（最新写入 34 outputs）
- `flutter pub run build_runner build --delete-conflicting-outputs`：通过（搜索筛选改动后写入 16 outputs）
- `flutter test`：通过（当前测试全部通过）

## 测试进展（M2）
- Widget 测试已新增：
  - `test/widgets/dashboard_metrics_card_test.dart`
  - `test/widgets/asset_list_item_test.dart`
  - `test/widgets/home_page_widget_test.dart`
- Integration 测试已新增：
  - `test/integration/home_page_integration_test.dart`
- Provider 测试已新增：
  - `test/providers/asset_filter_provider_test.dart`
  - `test/providers/asset_form_provider_test.dart`
  - `test/providers/asset_list_provider_test.dart`
  - `test/providers/dashboard_metrics_provider_test.dart`
- 覆盖点：
  - Dashboard 指标卡渲染
  - 资产列表项展示与点击回调
  - HomePage 搜索、筛选弹窗、空状态与列表状态
  - 搜索/筛选/排序逻辑
  - 表单校验失败与新增/编辑成功路径
  - 资产列表与仪表盘指标 provider 逻辑
- 当前 `flutter test`：`+21: All tests passed!`

## Git 记录
- `8f69fe3` feat(M2): implement state management layer and core UI components
- `64c094f` docs(M2): update progress with provider layer completion

## 当前结论
- M2 的 Provider Layer、Core UI、AssetFormPage、Search/Filter、Widget/Integration/Provider 测试已完成
- M2 当前可进入提交与发布收尾阶段

## 涉及文件
- `lib/features/home/presentation/providers/asset_list_provider.dart`
- `lib/features/home/presentation/providers/asset_list_provider.g.dart`
- `lib/features/home/presentation/providers/category_list_provider.dart`
- `lib/features/home/presentation/providers/category_list_provider.g.dart`
- `lib/features/home/presentation/providers/dashboard_metrics_provider.dart`
- `lib/features/home/presentation/providers/dashboard_metrics_provider.g.dart`
- `lib/features/home/presentation/providers/asset_form_provider.dart`
- `lib/features/home/presentation/providers/asset_form_provider.g.dart`
- `lib/features/home/presentation/providers/asset_filter_provider.dart`
- `lib/features/home/presentation/providers/asset_filter_provider.g.dart`
- `lib/features/asset_form/asset_form_page.dart`
- `lib/features/home/presentation/widgets/dashboard_metrics_card.dart`
- `lib/features/home/presentation/widgets/asset_list_item.dart`
- `lib/features/home/home_page.dart`
- `lib/app/router.dart`
- `lib/app/app.dart`
- `lib/main.dart`
- `pubspec.yaml`
- `pubspec.lock`
- `test/app_smoke_test.dart`
- `test/widgets/dashboard_metrics_card_test.dart`
- `test/widgets/asset_list_item_test.dart`
- `test/widgets/home_page_widget_test.dart`
- `test/integration/home_page_integration_test.dart`
- `test/providers/asset_filter_provider_test.dart`
- `test/providers/asset_form_provider_test.dart`
- `test/providers/asset_list_provider_test.dart`
- `test/providers/dashboard_metrics_provider_test.dart`

---

**创建日期**: 2026-03-06
**状态**: M2（部分完成，持续推进）
