# 技术栈文档 (TECH_STACK.md)
## 亏否 - 个人资产管理APP技术选型

---

## 1. 技术架构概览

### 1.1 架构原则
- **本地优先（Local First）**：核心功能无需网络
- **单机运行（Single User）**：仅个人使用，不依赖多用户系统
- **隐私优先（Privacy First）**：数据默认本地存储
- **离线可用（Offline First）**：所有核心功能离线可访问

### 1.2 推荐技术方案

```
移动端应用层: Flutter 3.24+
状态管理: Riverpod 2.x
本地数据库: SQLite (drift)
本地KV存储: Hive / SharedPreferences
图表引擎: fl_chart
导航管理: go_router
网络请求: dio
数据序列化: json_serializable
日志监控: logger + crashlytics (可选)
```

---

## 2. 前端技术选型

### 2.1 核心框架

#### Flutter
**版本：** 3.24+

**选择理由：**
- 跨平台（iOS + Android）一次开发
- UI渲染性能优秀（60fps）
- 适合自定义深色主题和渐变视觉
- 生态成熟，插件丰富

### 2.2 状态管理

#### Riverpod
**版本：** 2.x

**选择理由：**
- 编译时安全，避免运行时错误
- 易于测试
- 支持响应式数据流
- 比Provider更强大的依赖注入能力

**使用场景：**
- 资产列表状态管理
- 筛选条件状态
- 用户配置状态
- 统计数据状态

### 2.3 路由管理

#### go_router
**版本：** 14.x+

**路由结构：**
- `/` - 首页
- `/add` - 添加页面
- `/edit/:id` - 编辑页面
- `/profile` - 个人中心
- `/category` - 分类管理
- `/report` - 年度报告

---

## 3. 数据存储技术

### 3.1 主数据库

#### SQLite + drift ORM
**用途：** 核心业务数据存储

**存储内容：**
- 资产信息
- 分类信息
- 用户设置
- 统计缓存

**选择理由：**
- 关系型数据支持复杂查询
- 本地性能优秀
- drift提供类型安全SQL
- 支持数据迁移

### 3.2 轻量存储

#### SharedPreferences / Hive
**用途：** 轻量配置数据

**存储内容：**
- 主题配置
- 引导页状态
- 最近筛选条件
- 用户偏好设置

### 3.3 文件存储

**用途：** 数据备份/恢复

**格式：** JSON

**目录结构：**
```
/app_data/
  /backup/
    - backup_2026_03_06.json
    - backup_2026_03_01.json
  /icons/
    - custom_icon_001.png
```

---

## 4. 后端策略（可选）

### 4.1 V1.0 无后端模式

**默认方案：**
- 不使用服务器
- 纯本地存储
- 导出文件备份

**优点：**
- 开发成本低
- 隐私性高
- 无服务器维护成本
- 离线可用

### 4.2 V2.0 可选云同步

如需云同步可采用：
- **BaaS方案：** Supabase / Firebase
- **同步策略：** 手动同步优先，自动同步可选
- **冲突处理：** 时间戳 + 用户确认

---

## 5. UI与设计系统技术

### 5.1 设计系统

#### Flutter Theme + 自定义Design Tokens

**核心Token：**
```dart
class AppColors {
  static const primaryGradientStart = Color(0xFF6366F1);
  static const primaryGradientEnd = Color(0xFF8B5CF6);
  static const backgroundDark = Color(0xFF1A1A2E);
  static const cardDark = Color(0xFF16213E);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9CA3AF);
}
```

### 5.2 图标方案

- Material Icons（基础）
- Emoji（业务图标）
- 自定义PNG/SVG（高级功能）

### 5.3 动画方案

- 页面切换：`PageRouteBuilder`
- 列表动画：`AnimatedList`
- 卡片交互：`AnimatedContainer`
- 按钮反馈：`ScaleTransition`

---

## 6. 开发工具链

### 6.1 IDE与辅助工具

- **IDE：** VS Code / Android Studio
- **Dart SDK：** latest stable
- **Flutter DevTools：** 性能分析
- **Figma：** UI设计稿管理

### 6.2 代码质量工具

- **静态分析：** `flutter_lints`
- **格式化：** `dart format`
- **提交规范：** `conventional commits`
- **Git Hooks：** `pre-commit` (lint + test)

### 6.3 自动化工具

- **CI/CD：** GitHub Actions
- **构建：** Fastlane（可选）
- **发布：** TestFlight / Google Play Internal Test

---

## 7. 第三方依赖建议

### 7.1 核心依赖包

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  go_router: ^14.2.0
  drift: ^2.20.0
  sqlite3_flutter_libs: ^0.5.24
  path_provider: ^2.1.4
  shared_preferences: ^2.3.2
  json_annotation: ^4.9.0
  intl: ^0.19.0
  fl_chart: ^0.69.0
  dio: ^5.7.0
  logger: ^2.4.0
  uuid: ^4.5.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.12
  drift_dev: ^2.20.0
  json_serializable: ^6.8.0
  mocktail: ^1.0.4
```

### 7.2 可选依赖包

- `encrypt`：本地数据加密
- `local_auth`：生物识别解锁
- `image_picker`：自定义图标上传
- `share_plus`：数据文件分享
- `video_player`：激励广告视频（如有）

---

## 8. 性能指标与技术目标

### 8.1 启动性能
- 冷启动 < 2秒
- 热启动 < 800ms

### 8.2 运行性能
- 页面滑动帧率 >= 55fps
- 列表首屏渲染 < 300ms
- 数据查询响应 < 100ms

### 8.3 存储性能
- 单条资产写入 < 50ms
- 1000条资产查询 < 200ms
- 备份导出（1000条）< 2秒

---

## 9. 测试技术栈

### 9.1 单元测试
- `flutter_test`
- `mocktail`

**覆盖目标：**
- 计算逻辑覆盖率 > 90%
- 数据层覆盖率 > 80%

### 9.2 Widget测试
- 表单验证
- 列表渲染
- 交互逻辑

### 9.3 集成测试
- 添加物品完整流程
- 备份恢复流程
- 筛选排序流程

---

## 10. 安全与隐私技术

### 10.1 数据安全
- 本地数据库可选AES加密
- 备份文件可选密码保护
- 敏感信息脱敏显示

### 10.2 隐私合规
- 不收集个人隐私数据（V1）
- 不上传资产数据到云端（默认）
- 提供完整数据删除能力

---

## 11. 版本演进技术路线

### V1.0（MVP）
- Flutter + SQLite
- 本地存储
- 基础资产管理

### V1.5
- 数据备份恢复完善
- 年度报告功能
- 分类管理增强

### V2.0
- 可选云同步
- 多设备数据迁移
- 高级统计分析

---

## 12. 技术风险与应对

| 风险 | 影响 | 应对方案 |
|------|------|---------|
| 本地数据丢失 | 高 | 强化备份提醒，自动备份 |
| 数据库迁移失败 | 高 | 严格版本管理，迁移测试 |
| 大数据量卡顿 | 中 | 分页+缓存+索引优化 |
| 跨平台样式差异 | 中 | 统一设计系统，真机测试 |
| 第三方依赖不稳定 | 低 | 版本锁定，定期更新 |

---

**文档版本：** v1.0  
**最后更新：** 2026-03-06  
**技术负责人：** S.S.
