import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/radius.dart';
import '../../app/theme/spacing.dart';
import '../home/domain/entities/asset.dart';
import '../home/domain/entities/category.dart';
import '../home/presentation/providers/asset_list_provider.dart';
import 'presentation/providers/category_management_provider.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryManagementNotifierProvider);
    final assetsAsync = ref.watch(assetListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('分类管理'),
        actions: [
          IconButton(
            tooltip: '返回首页',
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('新增分类'),
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(
          message: '分类加载失败：$error',
          onRetry: () {
            ref.read(categoryManagementNotifierProvider.notifier).refresh();
          },
        ),
        data: (categories) {
          if (categories.isEmpty) {
            return _EmptyState(
              onCreate: () => _openCreateDialog(context, ref),
            );
          }

          final usageMap = _buildUsageMap(assetsAsync.valueOrNull ?? []);

          return ReorderableListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              96,
            ),
            buildDefaultDragHandles: false,
            onReorder: (oldIndex, newIndex) {
              _reorder(context, ref, oldIndex: oldIndex, newIndex: newIndex);
            },
            header: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummaryCard(
                    categoryCount: categories.length,
                    inUseCount: categories
                        .where((item) => (usageMap[item.id] ?? 0) > 0)
                        .length,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '按住右侧拖拽手柄可调整分类顺序',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            children: categories
                .asMap()
                .entries
                .map(
                  (entry) => Padding(
                    key: ValueKey(entry.value.id),
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _CategoryItemCard(
                      category: entry.value,
                      usageCount: usageMap[entry.value.id] ?? 0,
                      dragIndex: entry.key,
                      onEdit: () => _openEditDialog(context, ref, entry.value),
                      onDelete: () =>
                          _confirmAndDelete(context, ref, entry.value),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  Map<String, int> _buildUsageMap(List<Asset> assets) {
    final usageMap = <String, int>{};
    for (final asset in assets) {
      usageMap[asset.categoryId] = (usageMap[asset.categoryId] ?? 0) + 1;
    }
    return usageMap;
  }

  Future<void> _openCreateDialog(BuildContext context, WidgetRef ref) async {
    final form = await _showCategoryFormDialog(
      context,
      title: '新增分类',
      confirmText: '创建',
    );

    if (form == null) {
      return;
    }

    final notifier = ref.read(categoryManagementNotifierProvider.notifier);
    final message = await notifier.createCategory(
      name: form.name,
      icon: form.icon,
      description: form.description,
    );

    if (!context.mounted) {
      return;
    }

    _showMessage(context, message ?? '分类创建成功');
  }

  Future<void> _openEditDialog(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) async {
    final form = await _showCategoryFormDialog(
      context,
      title: '编辑分类',
      confirmText: '保存',
      initialName: category.name,
      initialIcon: category.icon,
      initialDescription: category.description,
    );

    if (form == null) {
      return;
    }

    final notifier = ref.read(categoryManagementNotifierProvider.notifier);
    final message = await notifier.updateCategory(
      id: category.id,
      name: form.name,
      icon: form.icon,
      description: form.description,
    );

    if (!context.mounted) {
      return;
    }

    _showMessage(context, message ?? '分类已更新');
  }

  Future<void> _confirmAndDelete(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('删除分类'),
          content: Text('确定删除 ${category.icon} ${category.name} 吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    final message = await ref
        .read(categoryManagementNotifierProvider.notifier)
        .deleteCategory(category.id);

    if (!context.mounted) {
      return;
    }

    _showMessage(context, message ?? '分类已删除');
  }

  Future<void> _reorder(
    BuildContext context,
    WidgetRef ref, {
    required int oldIndex,
    required int newIndex,
  }) async {
    final message = await ref
        .read(categoryManagementNotifierProvider.notifier)
        .reorderCategory(oldIndex: oldIndex, newIndex: newIndex);

    if (!context.mounted || message == null) {
      return;
    }

    _showMessage(context, message);
  }

  Future<_CategoryFormData?> _showCategoryFormDialog(
    BuildContext context, {
    required String title,
    required String confirmText,
    String initialName = '',
    String initialIcon = '📦',
    String initialDescription = '',
  }) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: initialName);
    final iconController = TextEditingController(text: initialIcon);
    final descriptionController =
        TextEditingController(text: initialDescription);

    final result = await showDialog<_CategoryFormData>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '分类名称',
                    hintText: '例如：数码设备',
                  ),
                  maxLength: 20,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return '请输入分类名称';
                    }
                    if (text.length > 20) {
                      return '分类名称不能超过20个字符';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: iconController,
                  decoration: const InputDecoration(
                    labelText: '图标',
                    hintText: '例如：💻',
                  ),
                  maxLength: 2,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return '请输入图标';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: '描述 (可选)',
                    hintText: '例如：手机、电脑、相机等数码设备',
                  ),
                  maxLength: 120,
                  minLines: 2,
                  maxLines: 3,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.length > 120) {
                      return '分类描述不能超过120个字符';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  children: _suggestedIcons
                      .map(
                        (icon) => ActionChip(
                          label: Text(icon),
                          onPressed: () => iconController.text = icon,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                Navigator.of(dialogContext).pop(
                  _CategoryFormData(
                    name: nameController.text.trim(),
                    icon: iconController.text.trim(),
                    description: descriptionController.text.trim(),
                  ),
                );
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    iconController.dispose();
    descriptionController.dispose();

    return result;
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

const _suggestedIcons = <String>[
  '💻',
  '📱',
  '🎧',
  '📷',
  '🚲',
  '🏋️',
  '🪑',
  '📦',
  '⌚',
];

class _CategoryFormData {
  const _CategoryFormData({
    required this.name,
    required this.icon,
    required this.description,
  });

  final String name;
  final String icon;
  final String description;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.categoryCount, required this.inUseCount});

  final int categoryCount;
  final int inUseCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Expanded(
              child: _SummaryItem(
                label: '分类总数',
                value: '$categoryCount',
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: _SummaryItem(
                label: '已被使用',
                value: '$inUseCount',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _CategoryItemCard extends StatelessWidget {
  const _CategoryItemCard({
    required this.category,
    required this.usageCount,
    required this.dragIndex,
    required this.onEdit,
    required this.onDelete,
  });

  final Category category;
  final int usageCount;
  final int dragIndex;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.bgSecondary,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(
                category.icon,
                style: const TextStyle(fontSize: 22),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          category.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      if (category.isDefault) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.info.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: const Text('默认'),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '排序 ${category.sortOrder} · 关联 $usageCount 个资产',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (category.description.trim().isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      category.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              tooltip: '编辑',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: '删除',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
            ReorderableDragStartListener(
              index: dragIndex,
              child: const Padding(
                padding: EdgeInsets.only(left: AppSpacing.xs),
                child: Icon(Icons.drag_handle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.category_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '还没有分类',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '先创建一个分类，后续新增资产时就能直接选择。',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('创建第一个分类'),
            ),
          ],
        ),
      ),
    );
  }
}
