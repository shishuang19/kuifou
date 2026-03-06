import '../../domain/entities/asset.dart';
import '../datasources/local/db/app_database.dart';

class AssetMapper {
  AssetMapper._();

  static Asset toDomain(AssetDb dbModel) {
    return Asset(
      id: dbModel.id,
      name: dbModel.name,
      categoryId: dbModel.categoryId,
      icon: dbModel.icon,
      purchasePrice: dbModel.purchasePrice,
      purchaseDate: DateTime.parse(dbModel.purchaseDate),
      warrantyEndDate: dbModel.warrantyEndDate != null
          ? DateTime.parse(dbModel.warrantyEndDate!)
          : null,
      expectedLifeDays: dbModel.expectedLifeDays,
      status: AssetStatus.values.firstWhere(
        (s) => s.value == dbModel.status,
        orElse: () => AssetStatus.using,
      ),
      note: dbModel.note,
      createdAt: dbModel.createdAt,
      updatedAt: dbModel.updatedAt,
    );
  }
}
