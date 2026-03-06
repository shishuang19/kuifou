import 'package:equatable/equatable.dart';

class DashboardMetrics extends Equatable {
  final String id;
  final double totalResidualValue;
  final double todayCost;
  final int assetCount;
  final double estimatedDailyCost;
  final DateTime snapshotDate;
  final DateTime createdAt;

  const DashboardMetrics({
    required this.id,
    required this.totalResidualValue,
    required this.todayCost,
    required this.assetCount,
    required this.estimatedDailyCost,
    required this.snapshotDate,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        totalResidualValue,
        todayCost,
        assetCount,
        estimatedDailyCost,
        snapshotDate,
        createdAt,
      ];
}
