import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/spacing.dart';
import '../home/presentation/providers/asset_list_provider.dart';
import '../home/presentation/providers/category_list_provider.dart';
import 'presentation/providers/backup_service_provider.dart';

class BackupRestorePage extends ConsumerStatefulWidget {
  const BackupRestorePage({super.key});

  @override
  ConsumerState<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends ConsumerState<BackupRestorePage> {
  final TextEditingController _importController = TextEditingController();

  String? _exportedJson;
  bool _isExporting = false;
  bool _isRestoring = false;

  @override
  void dispose() {
    _importController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('备份与恢复'),
        actions: [
          IconButton(
            tooltip: '返回首页',
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const _SectionHeader(
            title: '导出备份',
            subtitle: '导出当前资产和分类为 JSON 文本',
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilledButton.icon(
                    onPressed: _isExporting ? null : _exportBackup,
                    icon: _isExporting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download_outlined),
                    label: Text(_isExporting ? '导出中...' : '导出 JSON'),
                  ),
                  if (_exportedJson != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '导出内容（可复制）',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _copyToClipboard(_exportedJson!),
                          icon: const Icon(Icons.copy_outlined),
                          label: const Text('复制'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxHeight: 260),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.35),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        child: SelectableText(
                          _exportedJson!,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(height: 1.4),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const _SectionHeader(
            title: '恢复备份',
            subtitle: '粘贴 JSON 内容并执行恢复（会覆盖当前数据）',
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  TextField(
                    controller: _importController,
                    minLines: 8,
                    maxLines: 14,
                    decoration: const InputDecoration(
                      hintText: '请粘贴备份 JSON',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _isRestoring
                            ? null
                            : () => _importController.clear(),
                        icon: const Icon(Icons.clear_outlined),
                        label: const Text('清空'),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _isRestoring ? null : _confirmAndRestore,
                          icon: _isRestoring
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.restore_outlined),
                          label: Text(_isRestoring ? '恢复中...' : '校验并恢复'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '提示：恢复会先校验数据格式，再执行覆盖。若恢复失败会尝试自动回滚。',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportBackup() async {
    setState(() => _isExporting = true);

    final service = ref.read(backupServiceProvider);
    final result = await service.exportBackupJson();

    if (!mounted) {
      return;
    }

    setState(() => _isExporting = false);

    result.when(
      success: (jsonText) {
        setState(() => _exportedJson = jsonText);
        _showMessage('备份导出成功');
      },
      failure: (error) {
        _showMessage('导出失败：$error');
      },
    );
  }

  Future<void> _confirmAndRestore() async {
    final text = _importController.text.trim();
    if (text.isEmpty) {
      _showMessage('请先粘贴备份 JSON');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('确认恢复备份'),
          content: const Text('此操作会覆盖当前资产与分类数据，是否继续？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('继续恢复'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() => _isRestoring = true);

    final service = ref.read(backupServiceProvider);
    final result = await service.restoreFromJson(text);

    if (!mounted) {
      return;
    }

    setState(() => _isRestoring = false);

    result.when(
      success: (summary) {
        ref.invalidate(assetListProvider);
        ref.invalidate(categoryListProvider);
        _showMessage(
          '恢复成功：${summary.restoredCategoryCount} 个分类，${summary.restoredAssetCount} 个资产',
        );
      },
      failure: (error) {
        _showMessage('恢复失败：$error');
      },
    );
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    _showMessage('已复制到剪贴板');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

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
