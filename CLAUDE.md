# CLAUDE.md

本文件是本仓库 AI 会话的操作手册。每次新会话必须先读本文件，再读 `progress.txt`。

## 0. Read Order (Mandatory)
1. `CLAUDE.md`
2. `progress.txt`
3. 任务涉及的规范文档：`PRD.md` / `APP_FLOW.md` / `TECH_STACK.md` / `FRONTEND_GUIDELINES.md` / `BACKEND_STRUCTURE.md` / `IMPLEMENTATION_PLAN.md`

## 1. 项目快照
- 产品名：亏否
- 类型：个人资产折旧管理 APP（仅个人使用）
- 核心定位：Local First、Offline First、Privacy First
- 当前状态：规范文档已建立，工程代码尚未启动

## 2. 非谈判约束（Non-negotiables）
- 默认本地存储可用，核心功能不依赖网络。
- V1 不实现复杂账号体系，不依赖远程后端。
- 资产计算逻辑必须可追溯，禁止“黑箱”计算。
- 每完成一个功能，必须更新 `progress.txt`。
- 进入新会话、新终端、切换分支时，先读取 `progress.txt` 再行动。
- 每个阶段开发必须在独立分支完成并提交（建议命名：`phase/mX-<topic>`），避免直接在 `main` 累积阶段改动。

## 3. 技术栈摘要（V1）
- Flutter 3.24+
- 状态管理：Riverpod 2.x
- 路由：go_router 14.x+
- 本地数据库：SQLite + drift
- 轻量存储：SharedPreferences / Hive
- 网络层：dio（仅预留）
- 序列化：json_serializable
- 图表：fl_chart
- 日志：logger

## 4. 目标目录结构（实施基线）
```text
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme/
├── core/
│   ├── constants/
│   ├── extensions/
│   ├── utils/
│   ├── errors/
│   └── widgets/
├── features/
│   ├── home/
│   ├── asset_form/
│   ├── profile/
│   ├── category/
│   └── report/
└── main.dart
```

## 5. 命名规范（必须遵守）
- 文件名：`snake_case`（例：`asset_list_page.dart`）
- 类名：`PascalCase`（例：`AssetCard`）
- 变量名：`camelCase`（例：`totalResidualValue`）
- 常量：`const + lowerCamelCase`（例：`const maxAssetNameLength = 40;`）
- Provider：统一以 `Provider` 结尾（例：`assetListProvider`）

## 6. 组件模式与前端规则
- 页面拆分：`Page -> Section -> Item`
- 单页面建议不超过 500 行
- 可复用组件放 `core/widgets`
- 组件必须考虑禁用、加载、错误状态
- 禁止在 `build` 中做重计算/IO
- 禁止 UI 层直接操作数据库
- 使用 `AsyncValue` 统一处理 loading/error/data

## 7. 设计系统令牌（Design Tokens）
```dart
class AppColors {
  static const bgPrimary = Color(0xFF0F172A);
  static const bgSecondary = Color(0xFF1E293B);
  static const gradientStart = Color(0xFF5B3DF5);
  static const gradientEnd = Color(0xFF8C52FF);
  static const cardBg = Color(0xFF16213E);
  static const cardBorder = Color(0xFF2A3D66);
  static const textPrimary = Color(0xFFF8FAFC);
  static const textSecondary = Color(0xFF94A3B8);
  static const textHint = Color(0xFF64748B);
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);
  static const info = Color(0xFF60A5FA);
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const section = 28.0;
}

class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const full = 999.0;
}
```

## 8. 后端（本地后端）结构模式
- 分层：`Application -> Domain -> Data -> Local Storage`
- Domain：实体、仓储接口、UseCase、业务服务
- Data：Repository 实现、Mapper、DataSource
- Storage：SQLite（drift）+ 文件备份 + KV

核心实体（最低要求）：
- `Asset`
- `Category`
- `DashboardMetrics`

## 9. Allowed / Forbidden
Allowed:
- 在现有规范范围内进行实现与重构
- 为可读性增加少量必要注释
- 先补测试再改高风险逻辑
- 更新 `progress.txt` 记录状态变更

Forbidden:
- 未说明情况下更改核心业务公式
- 引入与 V1 范围冲突的远程依赖
- 绕过文档规范自行定义命名风格
- 提交未验证的数据库迁移
- 修改完成后不更新 `progress.txt`

## 10. 质量门禁（DoD）
- lint/format 通过
- 关键路径可运行：新增资产 -> 列表显示 -> 统计更新
- 错误路径可回退：保存失败、恢复失败
- 数据结构与文档一致
- `progress.txt` 已更新（完成项 / 进行中 / 下一步）

## 11. 会话执行模板（AI）
1. 读取 `CLAUDE.md` + `progress.txt`
2. 明确当前任务属于哪个里程碑（M0~M5）
3. 创建/切换到当前阶段分支（`phase/mX-<topic>`）
4. 执行最小可交付改动
5. 运行必要验证（lint/test/手工检查）
6. 更新 `progress.txt`
7. 输出变更摘要与下一步建议

## 12. 文档映射
- 产品规则：`PRD.md`
- 页面与流程：`APP_FLOW.md`
- 技术选型：`TECH_STACK.md`
- 前端规范：`FRONTEND_GUIDELINES.md`
- 后端结构：`BACKEND_STRUCTURE.md`
- 项目排期：`IMPLEMENTATION_PLAN.md`

---
Last Updated: 2026-03-07
Owner: S.S.
