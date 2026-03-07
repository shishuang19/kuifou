import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/radius.dart';
import '../../app/theme/spacing.dart';
import 'domain/entities/asset.dart';
import 'presentation/providers/asset_filter_provider.dart';
import 'presentation/providers/asset_list_provider.dart';
import 'presentation/providers/category_list_provider.dart';
import 'presentation/providers/dashboard_metrics_provider.dart';
import 'presentation/widgets/dashboard_metrics_card.dart';
import 'presentation/widgets/asset_list_item.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _searchController = TextEditingController();
  String _syncedSearchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _syncSearchController(String searchQuery) {
    if (_syncedSearchQuery == searchQuery) {
      return;
    }

    _searchController.value = TextEditingValue(
      text: searchQuery,
      selection: TextSelection.collapsed(offset: searchQuery.length),
    );
    _syncedSearchQuery = searchQuery;
  }

  String _statusLabel(AssetStatus status) {
    return switch (status) {
      AssetStatus.using => '使用中',
      AssetStatus.idle => '闲置',
      AssetStatus.disposed => '已处置',
    };
  }

  String _sortLabel(AssetSortOption option) {
    return switch (option) {
      AssetSortOption.purchaseDateDesc => '购买日期（新到旧）',
      AssetSortOption.purchaseDateAsc => '购买日期（旧到新）',
      AssetSortOption.priceDesc => '价格（高到低）',
      AssetSortOption.priceAsc => '价格（低到高）',
    };
  }

  Future<void> _showFilterBottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.bgSecondary,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final filterState = ref.watch(assetFilterNotifierProvider);
            final notifier = ref.read(assetFilterNotifierProvider.notifier);
            final categoriesAsync = ref.watch(categoryListProvider);

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '筛选与排序',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        TextButton(
                          onPressed: notifier.clearFilters,
                          child: const Text('清空'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      '状态',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: AssetStatus.values
                          .map(
                            (status) => ChoiceChip(
                              label: Text(_statusLabel(status)),
                              selected: filterState.status == status,
                              selectedColor: AppColors.gradientStart
                                  .withValues(alpha: 0.35),
                              onSelected: (selected) {
                                notifier.setStatus(selected ? status : null);
                              },
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      '分类',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    categoriesAsync.when(
                      data: (categories) {
                        if (categories.isEmpty) {
                          return const Text(
                            '暂无分类数据',
                            style: TextStyle(color: AppColors.textHint),
                          );
                        }

                        return Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: categories
                              .map(
                                (category) => ChoiceChip(
                                  label:
                                      Text('${category.icon} ${category.name}'),
                                  selected:
                                      filterState.categoryId == category.id,
                                  selectedColor: AppColors.gradientStart
                                      .withValues(alpha: 0.35),
                                  onSelected: (selected) {
                                    notifier.setCategoryId(
                                      selected ? category.id : null,
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        );
                      },
                      loading: () => const Center(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: AppSpacing.md),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (error, stack) => Text(
                        '分类加载失败: $error',
                        style: const TextStyle(color: AppColors.danger),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      '排序',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    DropdownButtonFormField<AssetSortOption>(
                      initialValue: filterState.sortOption,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.cardBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide:
                              const BorderSide(color: AppColors.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide:
                              const BorderSide(color: AppColors.cardBorder),
                        ),
                      ),
                      dropdownColor: AppColors.cardBg,
                      items: AssetSortOption.values
                          .map(
                            (option) => DropdownMenuItem<AssetSortOption>(
                              value: option,
                              child: Text(_sortLabel(option)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          notifier.setSortOption(value);
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('完成'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final metricsAsync = ref.watch(dashboardMetricsProvider);
    final assetsAsync = ref.watch(filteredAssetListProvider);
    final filterState = ref.watch(assetFilterNotifierProvider);
    final activeFilterCount = ref.watch(activeFilterCountProvider);

    _syncSearchController(filterState.searchQuery);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('亏否'),
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(assetListProvider);
          ref.invalidate(categoryListProvider);
          ref.invalidate(dashboardMetricsProvider);
          ref.invalidate(filteredAssetListProvider);
        },
        child: CustomScrollView(
          slivers: [
            // Dashboard metrics card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: metricsAsync.when(
                  data: (metrics) => DashboardMetricsCard(metrics: metrics),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Card(
                    color: AppColors.cardBg,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(
                        '加载失败: $error',
                        style: const TextStyle(color: AppColors.danger),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    ref
                        .read(assetFilterNotifierProvider.notifier)
                        .setSearchQuery(value);
                  },
                  decoration: InputDecoration(
                    hintText: '搜索资产名称...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: filterState.searchQuery.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              ref
                                  .read(assetFilterNotifierProvider.notifier)
                                  .setSearchQuery('');
                            },
                            icon: const Icon(Icons.clear),
                          ),
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
                      borderSide: const BorderSide(
                        color: AppColors.gradientStart,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Section header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '我的资产',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showFilterBottomSheet(context),
                      icon: const Icon(
                        Icons.filter_list,
                        size: 18,
                        color: AppColors.gradientStart,
                      ),
                      label: Text(
                        activeFilterCount == 0
                            ? '筛选'
                            : '筛选($activeFilterCount)',
                        style: const TextStyle(color: AppColors.gradientStart),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Asset list
            assetsAsync.when(
              data: (assets) {
                if (assets.isEmpty) {
                  final isFiltering = activeFilterCount > 0;

                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 80,
                            color: AppColors.textHint.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            isFiltering ? '没有匹配结果' : '还没有资产记录',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            isFiltering ? '试试调整搜索词或筛选条件' : '点击下方按钮添加你的第一件物品吧',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.textHint,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final asset = assets[index];
                      return AssetListItem(
                        asset: asset,
                        onTap: () {
                          context.go('/asset/${asset.id}/edit');
                        },
                      );
                    },
                    childCount: assets.length,
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80,
                        color: AppColors.danger.withValues(alpha: 0.7),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        '加载失败',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.danger,
                                ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        error.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/asset/new'),
        backgroundColor: AppColors.gradientStart,
        icon: const Icon(Icons.add),
        label: const Text('添加资产'),
      ),
    );
  }
}
