import 'package:drift/drift.dart';

@DataClassName('MetricsDb')
class MetricsCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get totalResidualValue => real()();
  RealColumn get todayCost => real()();
  IntColumn get assetCount => integer()();
  RealColumn get estimatedDailyCost => real()();
  TextColumn get snapshotDate => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Index> get indexes => [
        Index('idx_metrics_snapshot_date', {snapshotDate}),
      ];
}
