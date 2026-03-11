# 亏否

个人资产折旧管理应用（仅个人使用）。

定位：`Local First`、`Offline First`、`Privacy First`。

## 当前状态
- M1 数据层：完成
- M2 核心 UI + Provider：完成（含 Web 运行能力）
- M3 高级功能：核心完成（Profile / Category / Backup 基础），备份文件工作流待收尾

详细进度请查看：
- `progress.txt`
- `M1_DATA_LAYER_PROGRESS.md`
- `M2_PROVIDER_LAYER_CORE_UI_PROGRESS.md`
- `M3_ADVANCED_FEATURES_PROGRESS.md`

## 已实现功能
- 资产管理：新增、编辑、列表展示、状态管理
- 首页总览：资产统计、每日成本、残值等指标
- 搜索筛选：按关键词、分类、状态、排序
- 分类管理：CRUD、删除保护、拖拽排序、描述字段
- 个人中心：主题、语言、默认折旧方式、关于信息
- 备份恢复（基础）：JSON 导出、粘贴恢复、基础校验与回滚尝试

## 技术栈
- 前端框架：Flutter `>=3.24.0`
- 语言：Dart `>=3.4.0`
- 状态管理：Riverpod 2.x
- 路由：go_router
- 本地数据库：SQLite + drift
- 本地配置：SharedPreferences
- 网络层（预留）：dio
- 图表：fl_chart
- 日志：logger

## 快速开始

### 1. 环境准备
- 安装 Flutter SDK（建议 stable，版本 `>=3.24.0`）
- 检查开发环境：

```bash
flutter doctor
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 生成代码（drift / riverpod）

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. 运行应用

Web（推荐快速查看）：

```bash
flutter run -d chrome
```

Web（建议固定端口，避免开发期因端口变化导致看起来像“重启丢数据”）：

```bash
flutter run -d chrome --web-port 53793
```

macOS（如本机环境已配置）：

```bash
flutter run -d macos
```

一键打包命令
```bash
flutter clean && flutter pub get && flutter build macos --release && \
ditto -c -k --sequesterRsrc --keepParent \
"build/macos/Build/Products/Release/kuifou.app" \
"build/macos/Build/Products/Release/kuifou-macos.zip" && \
hdiutil create -volname "kuifou" \
-srcfolder "build/macos/Build/Products/Release/kuifou.app" \
-ov -format UDZO \
"build/macos/Build/Products/Release/kuifou-macos.dmg"
```
## 常用开发命令

```bash
# 静态检查
flutter analyze

# 全量测试
flutter test

# 关键路径测试（当前项目常用）
flutter test test/app_smoke_test.dart test/providers/ test/widgets/ test/integration/

# Web 发布构建
flutter build web --release
```

说明：Web 本地数据基于浏览器 `IndexedDB`，按 `origin`（协议+域名+端口）隔离。
如果每次 `flutter run` 使用不同端口，会像切到新站点，读不到上次的数据。

## 项目结构

```text
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── home/
│   ├── asset_form/
│   ├── category/
│   ├── profile/
│   └── report/
└── main.dart

test/
├── app_smoke_test.dart
├── integration/
├── providers/
└── widgets/
```

## 开发流程约定
- 每次新会话先读：`CLAUDE.md` -> `progress.txt`
- 每完成一个功能都更新 `progress.txt`
- 每个阶段在独立分支开发并提交：
   - 命名建议：`phase/mX-<topic>`
   - 示例：`phase/m3-foundation`

## 文档入口
- `CLAUDE.md`：AI 会话与协作操作手册
- `progress.txt`：最新进度与下一步任务
- `PRD.md`：产品需求
- `APP_FLOW.md`：页面与流程
- `TECH_STACK.md`：技术选型
- `FRONTEND_GUIDELINES.md`：前端规范
- `BACKEND_STRUCTURE.md`：后端（本地后端）结构规范
- `IMPLEMENTATION_PLAN.md`：里程碑实施计划

## License

暂未单独声明许可证，默认保留所有权利。


