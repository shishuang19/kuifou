import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/dashboard_metrics.dart';
import 'asset_list_provider.dart';

part 'dashboard_metrics_provider.g.dart';

const _uuid = Uuid();

// Dashboard metrics provider (computed from assets)
@riverpod
Future<DashboardMetrics> dashboardMetrics(DashboardMetricsRef ref) async {
  final assets = await ref.watch(assetListProvider.future);
  
  if (assets.isEmpty) {
    return DashboardMetrics(
      id: _uuid.v4(),
      totalResidualValue: 0.0,
      todayCost: 0.0,
      assetCount: 0,
      estimatedDailyCost: 0.0,
      snapshotDate: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }
  
  double totalResidualValue = 0.0;
  double totalDailyCost = 0.0;
  
  for (final asset in assets) {
    totalResidualValue += asset.residualValue;
    totalDailyCost += asset.dailyCost;
  }
  
  final now = DateTime.now();
  
  return DashboardMetrics(
    id: _uuid.v4(),
    totalResidualValue: totalResidualValue,
    todayCost: totalDailyCost,
    assetCount: assets.length,
    estimatedDailyCost: totalDailyCost,
    snapshotDate: now,
    createdAt: now,
  );
}
