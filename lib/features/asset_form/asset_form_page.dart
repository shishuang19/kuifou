import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/radius.dart';
import '../../app/theme/spacing.dart';
import '../home/domain/entities/asset.dart';
import '../profile/domain/entities/profile_preferences.dart';
import '../home/presentation/providers/asset_form_provider.dart';
import '../home/presentation/providers/asset_list_provider.dart';
import '../home/presentation/providers/category_list_provider.dart';

class AssetFormPage extends ConsumerStatefulWidget {
  final String? assetId;

  const AssetFormPage({super.key, this.assetId});

  @override
  ConsumerState<AssetFormPage> createState() => _AssetFormPageState();
}

class _AssetFormPageState extends ConsumerState<AssetFormPage> {
  static const _iconOptions = <String>[
    '📱',
    '💻',
    '⌚',
    '🎧',
    '📷',
    '🎮',
    '🚗',
    '🏠',
    '📦',
  ];

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _expectedLifeController = TextEditingController();
  final _noteController = TextEditingController();

  String? _syncedFormAssetId;

  bool get _isEditing => widget.assetId != null;

  @override
  void initState() {
    super.initState();
    if (!_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(assetFormNotifierProvider.notifier).reset();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _expectedLifeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _syncControllers(AssetFormState state) {
    final syncKey = state.assetId ?? '__create__';
    if (_syncedFormAssetId == syncKey) {
      return;
    }

    _nameController.text = state.name;
    _priceController.text =
        state.purchasePrice > 0 ? state.purchasePrice.toStringAsFixed(2) : '';
    _expectedLifeController.text = state.expectedLifeDays?.toString() ?? '';
    _noteController.text = state.note ?? '';
    _syncedFormAssetId = syncKey;
  }

  InputDecoration _inputDecoration(
    String label,
    String? errorText, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      errorText: errorText,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.cardBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide:
            const BorderSide(color: AppColors.gradientStart, width: 1.5),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _statusLabel(AssetStatus status) {
    return switch (status) {
      AssetStatus.using => '使用中',
      AssetStatus.idle => '闲置',
      AssetStatus.disposed => '已处置',
    };
  }

  String _depreciationMethodLabel(DepreciationMethodPreference method) {
    return method.label;
  }

  Future<void> _pickDate({
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required void Function(DateTime value) onSelected,
  }) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (selected != null) {
      onSelected(selected);
    }
  }

  Future<void> _createDefaultCategories() async {
    final repository = ref.read(categoryRepositoryProvider);
    final defaults = [
      (name: '日常', icon: '📦'),
      (name: '电子', icon: '💻'),
      (name: '出行', icon: '🚗'),
    ];

    for (var i = 0; i < defaults.length; i++) {
      final item = defaults[i];
      await repository.createCategory(
        name: item.name,
        icon: item.icon,
        sortOrder: i,
        isDefault: true,
      );
    }

    ref.invalidate(categoryListProvider);

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已创建默认分类')),
    );
  }

  void _closePage() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go('/');
  }

  Future<void> _saveForm() async {
    final notifier = ref.read(assetFormNotifierProvider.notifier);

    notifier.updateName(_nameController.text.trim());
    notifier.updatePurchasePrice(
        double.tryParse(_priceController.text.trim()) ?? 0);
    notifier.updateExpectedLifeDays(
      int.tryParse(_expectedLifeController.text.trim()),
    );

    final note = _noteController.text.trim();
    notifier.updateNote(note.isEmpty ? null : note);

    final success = await notifier.save();
    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? '资产更新成功' : '资产创建成功')),
      );
      _closePage();
      return;
    }

    final generalError = ref.read(assetFormNotifierProvider).errors['general'];
    if (generalError != null && generalError.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(generalError)),
      );
    }
  }

  Widget _buildCategoryField(AssetFormState formState) {
    final notifier = ref.read(assetFormNotifierProvider.notifier);
    final categoriesAsync = ref.watch(categoryListProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '暂无分类，先创建默认分类后再选择。',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.tonalIcon(
                  onPressed: _createDefaultCategories,
                  icon: const Icon(Icons.category_outlined),
                  label: const Text('创建默认分类'),
                ),
              ],
            ),
          );
        }

        final hasSelected =
            categories.any((category) => category.id == formState.categoryId);

        return DropdownButtonFormField<String>(
          key: ValueKey(formState.categoryId),
          initialValue: hasSelected ? formState.categoryId : null,
          decoration: _inputDecoration(
            '分类',
            formState.errors['categoryId'],
          ),
          dropdownColor: AppColors.cardBg,
          items: categories
              .map(
                (category) => DropdownMenuItem<String>(
                  value: category.id,
                  child: Text('${category.icon} ${category.name}'),
                ),
              )
              .toList(),
          onChanged: formState.isLoading
              ? null
              : (value) => notifier.updateCategoryId(value ?? ''),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.danger),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '分类加载失败: $error',
                style: const TextStyle(color: AppColors.danger),
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton.tonalIcon(
                onPressed: () => ref.invalidate(categoryListProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('重试'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required String? errorText,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: InputDecorator(
        decoration: _inputDecoration(
          label,
          errorText,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (value != null && onClear != null)
                IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.clear, size: 18),
                ),
              const Padding(
                padding: EdgeInsets.only(right: AppSpacing.sm),
                child: Icon(Icons.calendar_today, size: 18),
              ),
            ],
          ),
        ),
        child: Text(
          value == null ? '请选择日期' : _formatDate(value),
          style: TextStyle(
            color: value == null ? AppColors.textHint : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildFormBody(AssetFormState formState) {
    final notifier = ref.read(assetFormNotifierProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (formState.errors['general'] != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.danger.withAlpha(30),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.danger),
              ),
              child: Text(
                formState.errors['general']!,
                style: const TextStyle(color: AppColors.danger),
              ),
            ),
          Text(
            '基础信息',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _nameController,
            enabled: !formState.isLoading,
            onChanged: notifier.updateName,
            decoration: _inputDecoration('资产名称', formState.errors['name']),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildCategoryField(formState),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _priceController,
            enabled: !formState.isLoading,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              notifier.updatePurchasePrice(double.tryParse(value) ?? 0);
            },
            decoration: _inputDecoration(
              '购买价格 (元)',
              formState.errors['purchasePrice'],
            ),
          ),
          const SizedBox(height: AppSpacing.section),
          Text(
            '展示图标',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _iconOptions
                .map(
                  (icon) => ChoiceChip(
                    label: Text(icon, style: const TextStyle(fontSize: 18)),
                    selected: formState.icon == icon,
                    selectedColor: AppColors.gradientStart.withAlpha(80),
                    side: const BorderSide(color: AppColors.cardBorder),
                    onSelected: formState.isLoading
                        ? null
                        : (_) => notifier.updateIcon(icon),
                  ),
                )
                .toList(),
          ),
          if (formState.errors['icon'] != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                formState.errors['icon']!,
                style: const TextStyle(color: AppColors.danger, fontSize: 12),
              ),
            ),
          const SizedBox(height: AppSpacing.section),
          Text(
            '使用信息',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDateField(
            label: '购买日期',
            value: formState.purchaseDate,
            errorText: formState.errors['purchaseDate'],
            onTap: formState.isLoading
                ? () {}
                : () => _pickDate(
                      initialDate: formState.purchaseDate,
                      firstDate: DateTime(2000, 1, 1),
                      lastDate: DateTime.now(),
                      onSelected: notifier.updatePurchaseDate,
                    ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDateField(
            label: '保修到期 (可选)',
            value: formState.warrantyEndDate,
            errorText: null,
            onTap: formState.isLoading
                ? () {}
                : () => _pickDate(
                      initialDate: formState.warrantyEndDate ?? DateTime.now(),
                      firstDate: DateTime(2000, 1, 1),
                      lastDate: DateTime(2100, 12, 31),
                      onSelected: notifier.updateWarrantyEndDate,
                    ),
            onClear: formState.isLoading
                ? null
                : () => notifier.updateWarrantyEndDate(null),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<DepreciationMethodPreference>(
            key: ValueKey(formState.depreciationMethod),
            initialValue: formState.depreciationMethod,
            decoration: _inputDecoration('折旧方法', null),
            dropdownColor: AppColors.cardBg,
            items: DepreciationMethodPreference.values
                .map(
                  (method) => DropdownMenuItem<DepreciationMethodPreference>(
                    value: method,
                    child: Text(_depreciationMethodLabel(method)),
                  ),
                )
                .toList(),
            onChanged: formState.isLoading
                ? null
                : (value) {
                    if (value == null) {
                      return;
                    }

                    notifier.updateDepreciationMethod(value);
                    _expectedLifeController.text =
                        value.defaultExpectedLifeDays.toString();
                  },
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '已根据折旧方法预填寿命天数，可手动修改',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _expectedLifeController,
            enabled: !formState.isLoading,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              notifier.updateExpectedLifeDays(int.tryParse(value));
            },
            decoration: _inputDecoration('预估寿命天数 (可选)', null),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<AssetStatus>(
            key: ValueKey(formState.status),
            initialValue: formState.status,
            decoration: _inputDecoration('状态', null),
            dropdownColor: AppColors.cardBg,
            items: AssetStatus.values
                .map(
                  (status) => DropdownMenuItem<AssetStatus>(
                    value: status,
                    child: Text(_statusLabel(status)),
                  ),
                )
                .toList(),
            onChanged: formState.isLoading
                ? null
                : (value) {
                    if (value != null) {
                      notifier.updateStatus(value);
                    }
                  },
          ),
          const SizedBox(height: AppSpacing.section),
          Text(
            '备注',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _noteController,
            enabled: !formState.isLoading,
            maxLines: 3,
            onChanged: notifier.updateNote,
            decoration: _inputDecoration('输入备注信息 (可选)', null),
          ),
          const SizedBox(height: AppSpacing.section),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: formState.isLoading ? null : _closePage,
                  child: const Text('取消'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: formState.isLoading ? null : _saveForm,
                  icon: formState.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(formState.isLoading ? '保存中...' : '保存'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(assetFormNotifierProvider);
    _syncControllers(formState);

    if (_isEditing) {
      final assetAsync = ref.watch(assetByIdProvider(widget.assetId!));

      assetAsync.whenData((asset) {
        if (asset != null && formState.assetId != asset.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(assetFormNotifierProvider.notifier).loadAsset(asset);
          });
        }
      });

      return Scaffold(
        backgroundColor: AppColors.bgPrimary,
        appBar: AppBar(
          title: const Text('编辑资产'),
          backgroundColor: AppColors.bgPrimary,
          elevation: 0,
        ),
        body: assetAsync.when(
          data: (asset) {
            if (asset == null) {
              return Center(
                child: Text(
                  '未找到该资产',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }
            return _buildFormBody(formState);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                '加载资产失败: $error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.danger),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('添加资产'),
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
      ),
      body: _buildFormBody(formState),
    );
  }
}
