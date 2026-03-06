import 'package:drift/drift.dart';
import '../entities/asset.dart';

@DataClassName('AssetDb')
class Assets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get categoryId => text()();
  TextColumn get icon => text()();
  RealColumn get purchasePrice => real()();
  TextColumn get purchaseDate => text()();
  TextColumn get warrantyEndDate => text().nullable()();
  IntColumn get expectedLifeDays => integer().nullable()();
  TextColumn get status => text().withDefault(const Constant('using'))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {categoryId, name},
      ];

  @override
  List<Index> get indexes => [
        Index('idx_assets_purchase_date', {purchaseDate}),
        Index('idx_assets_category_id', {categoryId}),
        Index('idx_assets_status', {status}),
        Index('idx_assets_deleted_at', {deletedAt}),
      ];
}
