import '../../../home/domain/entities/asset.dart';

class BackupPayload {
  const BackupPayload({
    required this.schemaVersion,
    required this.exportedAt,
    required this.categories,
    required this.assets,
  });

  final int schemaVersion;
  final DateTime exportedAt;
  final List<BackupCategoryRecord> categories;
  final List<BackupAssetRecord> assets;

  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'exportedAt': exportedAt.toIso8601String(),
      'categories': categories.map((item) => item.toJson()).toList(),
      'assets': assets.map((item) => item.toJson()).toList(),
    };
  }

  static BackupPayload fromJson(Map<String, dynamic> json) {
    final schemaVersionValue = json['schemaVersion'];
    final exportedAtValue = json['exportedAt'];
    final categoriesValue = json['categories'];
    final assetsValue = json['assets'];

    if (schemaVersionValue is! int) {
      throw const FormatException('schemaVersion 必须为整数');
    }
    if (exportedAtValue is! String) {
      throw const FormatException('exportedAt 缺失或格式错误');
    }
    if (categoriesValue is! List) {
      throw const FormatException('categories 缺失或格式错误');
    }
    if (assetsValue is! List) {
      throw const FormatException('assets 缺失或格式错误');
    }

    return BackupPayload(
      schemaVersion: schemaVersionValue,
      exportedAt: DateTime.parse(exportedAtValue),
      categories: categoriesValue
          .map(
            (item) => BackupCategoryRecord.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      assets: assetsValue
          .map(
            (item) => BackupAssetRecord.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }
}

class BackupCategoryRecord {
  const BackupCategoryRecord({
    required this.id,
    required this.name,
    required this.icon,
    this.description = '',
    required this.sortOrder,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String icon;
  final String description;
  final int sortOrder;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'sortOrder': sortOrder,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static BackupCategoryRecord fromJson(Map<String, dynamic> json) {
    return BackupCategoryRecord(
      id: _readString(json, 'id'),
      name: _readString(json, 'name'),
      icon: _readString(json, 'icon'),
      description: _readNullableString(json, 'description') ?? '',
      sortOrder: _readInt(json, 'sortOrder'),
      isDefault: _readBool(json, 'isDefault'),
      createdAt: DateTime.parse(_readString(json, 'createdAt')),
      updatedAt: DateTime.parse(_readString(json, 'updatedAt')),
    );
  }
}

class BackupAssetRecord {
  const BackupAssetRecord({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.icon,
    required this.purchasePrice,
    required this.purchaseDate,
    required this.warrantyEndDate,
    required this.expectedLifeDays,
    required this.status,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String categoryId;
  final String icon;
  final double purchasePrice;
  final DateTime purchaseDate;
  final DateTime? warrantyEndDate;
  final int? expectedLifeDays;
  final AssetStatus status;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'icon': icon,
      'purchasePrice': purchasePrice,
      'purchaseDate': purchaseDate.toIso8601String(),
      'warrantyEndDate': warrantyEndDate?.toIso8601String(),
      'expectedLifeDays': expectedLifeDays,
      'status': status.value,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static BackupAssetRecord fromJson(Map<String, dynamic> json) {
    final warrantyValue = json['warrantyEndDate'];
    final expectedLifeDaysValue = json['expectedLifeDays'];
    final noteValue = json['note'];

    return BackupAssetRecord(
      id: _readString(json, 'id'),
      name: _readString(json, 'name'),
      categoryId: _readString(json, 'categoryId'),
      icon: _readString(json, 'icon'),
      purchasePrice: _readNum(json, 'purchasePrice').toDouble(),
      purchaseDate: DateTime.parse(_readString(json, 'purchaseDate')),
      warrantyEndDate: warrantyValue == null
          ? null
          : DateTime.parse(warrantyValue as String),
      expectedLifeDays:
          expectedLifeDaysValue == null ? null : expectedLifeDaysValue as int,
      status: _assetStatusFromValue(_readString(json, 'status')),
      note: noteValue == null ? null : noteValue as String,
      createdAt: DateTime.parse(_readString(json, 'createdAt')),
      updatedAt: DateTime.parse(_readString(json, 'updatedAt')),
    );
  }
}

class BackupRestoreSummary {
  const BackupRestoreSummary({
    required this.restoredCategoryCount,
    required this.restoredAssetCount,
  });

  final int restoredCategoryCount;
  final int restoredAssetCount;
}

AssetStatus _assetStatusFromValue(String value) {
  return AssetStatus.values.firstWhere(
    (item) => item.value == value,
    orElse: () => AssetStatus.using,
  );
}

String _readString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String) {
    throw FormatException('$key 缺失或格式错误');
  }
  return value;
}

int _readInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! int) {
    throw FormatException('$key 缺失或格式错误');
  }
  return value;
}

bool _readBool(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! bool) {
    throw FormatException('$key 缺失或格式错误');
  }
  return value;
}

num _readNum(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! num) {
    throw FormatException('$key 缺失或格式错误');
  }
  return value;
}

String? _readNullableString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is! String) {
    throw FormatException('$key 格式错误');
  }
  return value;
}
