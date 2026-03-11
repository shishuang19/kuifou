# 前端开发规范 (FRONTEND_GUIDELINES.md)
## 亏否 - Flutter前端规范文档

---

## 1. 目标与原则

### 1.1 核心目标
- 高一致性：UI、交互、文案统一
- 高可维护性：模块清晰，易扩展
- 高性能：流畅稳定，低功耗
- 高可用性：操作简单，反馈明确

### 1.2 开发原则
- 单一职责：每个Widget只做一件事
- 数据驱动UI：避免手动同步状态
- 组件复用优先：减少重复代码
- 视觉还原优先：严格对齐设计稿

---

## 2. 项目目录规范

```text
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── colors.dart
│       ├── typography.dart
│       └── spacing.dart
├── core/
│   ├── constants/
│   ├── extensions/
│   ├── utils/
│   ├── errors/
│   └── widgets/
│       ├── app_button.dart
│       ├── app_card.dart
│       ├── app_input.dart
│       └── app_loading.dart
├── features/
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── asset_form/
│   ├── profile/
│   ├── category/
│   └── report/
└── main.dart
```

---

## 3. 命名规范

### 3.1 文件命名
- 使用 `snake_case`
- 示例：`asset_list_page.dart`, `daily_cost_calculator.dart`

### 3.2 类命名
- 使用 `PascalCase`
- 示例：`AssetCard`, `HomeViewModel`, `AppGradientButton`

### 3.3 变量命名
- 使用 `camelCase`
- 示例：`totalResidualValue`, `selectedCategoryId`

### 3.4 常量命名
- 使用 `lowerCamelCase` + `const`
- 示例：`const maxAssetNameLength = 40;`

### 3.5 Provider命名
- 统一以 `Provider` 结尾
- 示例：`assetListProvider`, `filteredAssetsProvider`

---

## 4. UI设计Token规范

### 4.1 颜色系统

```dart
class AppColors {
  // 主背景色
  static const bgPrimary = Color(0xFF0F172A);
  static const bgSecondary = Color(0xFF1E293B);

  // 主渐变
  static const gradientStart = Color(0xFF5B3DF5);
  static const gradientEnd = Color(0xFF8C52FF);

  // 卡片色
  static const cardBg = Color(0xFF16213E);
  static const cardBorder = Color(0xFF2A3D66);

  // 文字色
  static const textPrimary = Color(0xFFF8FAFC);
  static const textSecondary = Color(0xFF94A3B8);
  static const textHint = Color(0xFF64748B);

  // 功能色
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);
  static const info = Color(0xFF60A5FA);
}
```

### 4.2 间距系统

```dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const section = 28.0;
}
```

### 4.3 圆角系统

```dart
class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const full = 999.0;
}
```

### 4.4 字体系统

```dart
class AppTextStyle {
  static const titleLarge = TextStyle(fontSize: 28, fontWeight: FontWeight.w700);
  static const titleMedium = TextStyle(fontSize: 22, fontWeight: FontWeight.w600);
  static const bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static const caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
}
```

---

## 5. 组件开发规范

### 5.1 基础组件要求
- 所有可复用组件放在 `core/widgets`
- 每个组件支持主题色适配
- 必须支持禁用、加载、错误状态
- 组件对外暴露最小必要参数

### 5.2 页面组件拆分原则

**禁止：** 单页面超过500行

**建议拆分：**
- Page：页面容器和布局
- Section：业务区块（头部、列表、筛选）
- Item：基础条目组件

### 5.3 示例：资产卡片拆分

```text
asset_card.dart                 // 外层容器
asset_card_header.dart          // 名称、分类、图标
asset_card_metrics.dart         // 价格、日成本
asset_card_footer.dart          // 日期、状态
asset_usage_days_badge.dart     // 右侧天数badge
```

---

## 6. 状态管理规范（Riverpod）

### 6.1 状态分层
- UI状态：筛选开关、输入框值
- 业务状态：资产列表、统计数据
- 异步状态：加载中、错误、空数据

### 6.2 Provider类型建议
- `Provider`：纯计算依赖
- `StateProvider`：简单可变状态
- `NotifierProvider`：复杂业务状态
- `FutureProvider`：一次性异步加载
- `StreamProvider`：实时数据流

### 6.3 异步状态处理

统一使用 `AsyncValue` 渲染：
- loading：骨架屏
- error：错误卡片+重试
- data：正常渲染

---

## 7. 表单规范

### 7.1 输入字段规则
- 商品名称：1-40字符
- 购买价格：>0，保留2位小数
- 购买时间：不可晚于今天

### 7.2 校验时机
- 输入中：轻量校验（格式）
- 失焦时：字段级校验
- 点击保存：全量校验

### 7.3 错误提示规范
- 文案简短明确
- 与字段就近显示
- 颜色统一 danger 红
- 首次错误时触发轻震动（可选）

---

## 8. 列表与性能规范

### 8.1 列表渲染
- 使用 `ListView.builder`
- 每个Item提供稳定 `Key`
- 超过50条时启用分页或虚拟化

### 8.2 图片/图标加载
- 本地图标优先缓存
- 网络图片（如有）使用占位图
- 失败降级到默认图标

### 8.3 重绘优化
- 使用 `const` 构造
- 大组件拆分为小组件
- 避免在 `build` 中执行计算逻辑

---

## 9. 动画与交互规范

### 9.1 动画原则
- 动画应服务于信息表达
- 单次时长建议 150ms~300ms
- 避免页面多处同时复杂动画

### 9.2 推荐动画场景
- 页面进入：淡入+上移
- 卡片点击：轻微缩放（0.98）
- 列表新增：顶部插入动画
- 保存成功：按钮状态切换

### 9.3 触觉反馈
- 关键操作：轻触反馈
- 删除/危险操作：中等反馈
- 成功保存：轻反馈

---

## 10. 主题与暗色适配

### 10.1 主题策略
- 默认深色主题
- 保留浅色主题扩展能力
- 禁止硬编码颜色

### 10.2 主题切换要求
- 切换无闪屏
- 用户选择持久化
- 所有组件同步响应

---

## 11. 无障碍与可用性

### 11.1 可访问性
- 文字最小12sp
- 点击区域最小44x44
- 颜色对比度符合WCAG AA
- 关键图标提供语义标签

### 11.2 可用性
- 关键按钮固定底部（如保存）
- 页面支持下拉刷新
- 错误状态可一键重试

---

## 12. 国际化规范

### 12.1 文案管理
- 禁止硬编码中文字符串
- 使用 `intl` + ARB 文件
- 文案Key命名：`page_section_action`

### 12.2 日期货币格式
- 日期：`yyyy-MM-dd`
- 货币：`¥1,234.56`
- 天数：`125天`

---

## 13. 日志与错误处理

### 13.1 日志级别
- debug：开发调试信息
- info：关键操作日志
- warning：可恢复异常
- error：影响业务的错误

### 13.2 错误展示策略
- 用户可理解文案
- 不暴露技术细节
- 提供下一步操作（重试/返回）

---

## 14. 测试规范

### 14.1 单元测试
- 业务计算函数必须测试
- 表单校验规则必须测试

### 14.2 Widget测试
- 首页列表渲染
- 添加页面必填验证
- 筛选交互

### 14.3 Golden测试（可选）
- 关键页面视觉回归
- 深色主题核心页面截图对比

---

## 15. 代码评审清单

每次提交前检查：
- 是否遵守目录结构
- 是否存在硬编码颜色/文案
- 是否有未处理的异步错误
- 是否影响已有性能指标
- 是否补充必要测试

---

## 16. 禁止事项

- 禁止在UI层直接操作数据库
- 禁止在build中发起网络请求
- 禁止复制粘贴大段重复组件
- 禁止提交debug print到生产环境
- 禁止页面逻辑与样式强耦合

---

## 17. 交付标准

页面达到以下标准才可交付：
- 与设计稿一致（允许轻微像素误差）
- 无明显卡顿与布局跳动
- 表单校验完整
- 异常流程可用
- 通过最小测试集

---

**文档版本：** v1.0  
**最后更新：** 2026-03-06  
**维护者：** S.S.
