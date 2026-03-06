import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/spacing.dart';
import '../../../../app/theme/radius.dart';
import '../../domain/entities/asset.dart';

class AssetListItem extends StatelessWidget {
  final Asset asset;
  final VoidCallback? onTap;

  const AssetListItem({
    super.key,
    required this.asset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(
      locale: 'zh_CN',
      symbol: '¥',
      decimalDigits: 2,
    );

    final dailyCost = asset.dailyCost;
    final residualValue = asset.residualValue;
    final depreciationRate = residualValue / asset.purchasePrice;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      color: AppColors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: AppColors.cardBorder,
          width: 1,
        ),
      ),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.bgSecondary,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      asset.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Name and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          asset.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            _StatusBadge(status: asset.status),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              '已用 ${asset.usageDays} 天',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Depreciation indicator
                  _DepreciationIndicator(rate: depreciationRate),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(
                color: AppColors.cardBorder,
                height: 1,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      label: '购入价',
                      value: numberFormat.format(asset.purchasePrice),
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      label: '每日成本',
                      value: numberFormat.format(dailyCost),
                      valueColor: AppColors.warning,
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      label: '残值',
                      value: numberFormat.format(residualValue),
                      valueColor: residualValue > 0
                          ? AppColors.success
                          : AppColors.danger,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final AssetStatus status;

  const _StatusBadge({required this.status});

  Color _getStatusColor() {
    switch (status) {
      case AssetStatus.using:
        return AppColors.success;
      case AssetStatus.idle:
        return AppColors.info;
      case AssetStatus.disposed:
        return AppColors.textHint;
    }
  }

  String _getStatusText() {
    switch (status) {
      case AssetStatus.using:
        return '使用中';
      case AssetStatus.idle:
        return '闲置';
      case AssetStatus.disposed:
        return '已处置';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        _getStatusText(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _getStatusColor(),
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _DepreciationIndicator extends StatelessWidget {
  final double rate; // 0.0 - 1.0

  const _DepreciationIndicator({required this.rate});

  @override
  Widget build(BuildContext context) {
    final percentage = (rate * 100).toInt();
    final color = rate > 0.7
        ? AppColors.success
        : rate > 0.3
            ? AppColors.warning
            : AppColors.danger;

    return Column(
      children: [
        Text(
          '$percentage%',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          width: 40,
          height: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: rate,
              backgroundColor: AppColors.bgSecondary,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
