import 'package:drift/drift.dart';

@DataClassName('MetricsDb')
@TableIndex(name: 'idx_metrics_snapshot_date', columns: {#snapshotDate})
class MetricsCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get totalResidualValue => real()();
  RealColumn get todayCost => real()();
  IntColumn get assetCount => integer()();
  RealColumn get estimatedDailyCost => real()();
  TextColumn get snapshotDate => text()();
  DateTimeColumn get createdAt => dateTime()();
}
