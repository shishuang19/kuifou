import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/spacing.dart';
import '../../core/constants/app_info.dart';
import 'domain/entities/profile_preferences.dart';
import 'presentation/providers/profile_preferences_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferencesAsync = ref.watch(profilePreferencesNotifierProvider);
    final notifier = ref.read(profilePreferencesNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('个人中心')),
      body: preferencesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '设置加载失败：$error',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: notifier.load,
                    icon: const Icon(Icons.refresh),
                    label: const Text('重试'),
                  ),
                ],
              ),
            ),
          );
        },
        data: (preferences) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _ProfileSummaryCard(preferences: preferences),
              const SizedBox(height: AppSpacing.xl),
              const _SectionTitle(
                title: '偏好设置',
                subtitle: '设置会自动保存在本地设备',
              ),
              const SizedBox(height: AppSpacing.sm),
              Card(
                child: Column(
                  children: [
                    _PreferenceTile<ThemePreference>(
                      title: '主题模式',
                      value: preferences.themePreference,
                      options: ThemePreference.values,
                      labelOf: (item) => item.label,
                      onChanged: notifier.updateThemePreference,
                    ),
                    const Divider(height: 1),
                    _PreferenceTile<LanguagePreference>(
                      title: '显示语言',
                      value: preferences.languagePreference,
                      options: LanguagePreference.values,
                      labelOf: (item) => item.label,
                      onChanged: notifier.updateLanguagePreference,
                    ),
                    const Divider(height: 1),
                    _PreferenceTile<DepreciationMethodPreference>(
                      title: '默认折旧方法',
                      value: preferences.depreciationMethodPreference,
                      options: DepreciationMethodPreference.values,
                      labelOf: (item) => item.label,
                      onChanged: notifier.updateDepreciationMethodPreference,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: notifier.resetToDefaults,
                  icon: const Icon(Icons.restore),
                  label: const Text('恢复默认设置'),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const _SectionTitle(
                title: '功能入口',
                subtitle: '继续完善 M3 的管理能力',
              ),
              const SizedBox(height: AppSpacing.sm),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.category_outlined),
                      title: const Text('分类管理'),
                      subtitle: const Text('查看、编辑、删除和排序分类'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/categories'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.backup_outlined),
                      title: const Text('备份与恢复'),
                      subtitle: const Text('导出 JSON 与恢复数据'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/backup'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('常见问题'),
                      subtitle: const Text('查看关键功能说明'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text('常见问题'),
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('1. 备份恢复会覆盖当前数据吗？'),
                                  SizedBox(height: AppSpacing.xs),
                                  Text('会，恢复前会提示确认，失败时会尝试回滚。'),
                                  SizedBox(height: AppSpacing.md),
                                  Text('2. 分类为什么无法删除？'),
                                  SizedBox(height: AppSpacing.xs),
                                  Text('默认分类或被资产使用的分类不可删除。'),
                                ],
                              ),
                              actions: [
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  child: const Text('知道了'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const _SectionTitle(
                title: '关于亏否',
                subtitle: '本地优先 · 离线优先 · 隐私优先',
              ),
              const SizedBox(height: AppSpacing.sm),
              const Card(
                child: Column(
                  children: [
                    _AboutItem(title: '应用名称', value: appName),
                    Divider(height: 1),
                    _AboutItem(title: '当前版本', value: appVersion),
                    Divider(height: 1),
                    _AboutItem(title: '产品理念', value: appTagline),
                    Divider(height: 1),
                    _AboutItem(title: '版权信息', value: appCopyright),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.preferences});

  final ProfilePreferences preferences;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '设置总览',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('主题: ${preferences.themePreference.label}'),
            const SizedBox(height: AppSpacing.xs),
            Text('语言: ${preferences.languagePreference.label}'),
            const SizedBox(height: AppSpacing.xs),
            Text('折旧: ${preferences.depreciationMethodPreference.label}'),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _PreferenceTile<T> extends StatelessWidget {
  const _PreferenceTile({
    required this.title,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.onChanged,
  });

  final String title;
  final T value;
  final List<T> options;
  final String Function(T item) labelOf;
  final Future<void> Function(T item) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          DropdownButton<T>(
            value: value,
            onChanged: (next) {
              if (next == null) {
                return;
              }
              onChanged(next);
            },
            items: options
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(labelOf(item)),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _AboutItem extends StatelessWidget {
  const _AboutItem({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
