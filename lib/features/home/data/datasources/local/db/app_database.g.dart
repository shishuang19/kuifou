// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AssetsTable extends Assets with TableInfo<$AssetsTable, AssetDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _purchasePriceMeta =
      const VerificationMeta('purchasePrice');
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
      'purchase_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumn<String> purchaseDate = GeneratedColumn<String>(
      'purchase_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _warrantyEndDateMeta =
      const VerificationMeta('warrantyEndDate');
  @override
  late final GeneratedColumn<String> warrantyEndDate = GeneratedColumn<String>(
      'warranty_end_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expectedLifeDaysMeta =
      const VerificationMeta('expectedLifeDays');
  @override
  late final GeneratedColumn<int> expectedLifeDays = GeneratedColumn<int>(
      'expected_life_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('using'));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        categoryId,
        icon,
        purchasePrice,
        purchaseDate,
        warrantyEndDate,
        expectedLifeDays,
        status,
        note,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assets';
  @override
  VerificationContext validateIntegrity(Insertable<AssetDb> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
          _purchasePriceMeta,
          purchasePrice.isAcceptableOrUnknown(
              data['purchase_price']!, _purchasePriceMeta));
    } else if (isInserting) {
      context.missing(_purchasePriceMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
          _purchaseDateMeta,
          purchaseDate.isAcceptableOrUnknown(
              data['purchase_date']!, _purchaseDateMeta));
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('warranty_end_date')) {
      context.handle(
          _warrantyEndDateMeta,
          warrantyEndDate.isAcceptableOrUnknown(
              data['warranty_end_date']!, _warrantyEndDateMeta));
    }
    if (data.containsKey('expected_life_days')) {
      context.handle(
          _expectedLifeDaysMeta,
          expectedLifeDays.isAcceptableOrUnknown(
              data['expected_life_days']!, _expectedLifeDaysMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {categoryId, name},
      ];
  @override
  AssetDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      purchasePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}purchase_price'])!,
      purchaseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purchase_date'])!,
      warrantyEndDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}warranty_end_date']),
      expectedLifeDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}expected_life_days']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $AssetsTable createAlias(String alias) {
    return $AssetsTable(attachedDatabase, alias);
  }
}

class AssetDb extends DataClass implements Insertable<AssetDb> {
  final String id;
  final String name;
  final String categoryId;
  final String icon;
  final double purchasePrice;
  final String purchaseDate;
  final String? warrantyEndDate;
  final int? expectedLifeDays;
  final String status;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const AssetDb(
      {required this.id,
      required this.name,
      required this.categoryId,
      required this.icon,
      required this.purchasePrice,
      required this.purchaseDate,
      this.warrantyEndDate,
      this.expectedLifeDays,
      required this.status,
      this.note,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category_id'] = Variable<String>(categoryId);
    map['icon'] = Variable<String>(icon);
    map['purchase_price'] = Variable<double>(purchasePrice);
    map['purchase_date'] = Variable<String>(purchaseDate);
    if (!nullToAbsent || warrantyEndDate != null) {
      map['warranty_end_date'] = Variable<String>(warrantyEndDate);
    }
    if (!nullToAbsent || expectedLifeDays != null) {
      map['expected_life_days'] = Variable<int>(expectedLifeDays);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  AssetsCompanion toCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: Value(id),
      name: Value(name),
      categoryId: Value(categoryId),
      icon: Value(icon),
      purchasePrice: Value(purchasePrice),
      purchaseDate: Value(purchaseDate),
      warrantyEndDate: warrantyEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(warrantyEndDate),
      expectedLifeDays: expectedLifeDays == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedLifeDays),
      status: Value(status),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory AssetDb.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetDb(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      icon: serializer.fromJson<String>(json['icon']),
      purchasePrice: serializer.fromJson<double>(json['purchasePrice']),
      purchaseDate: serializer.fromJson<String>(json['purchaseDate']),
      warrantyEndDate: serializer.fromJson<String?>(json['warrantyEndDate']),
      expectedLifeDays: serializer.fromJson<int?>(json['expectedLifeDays']),
      status: serializer.fromJson<String>(json['status']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<String>(categoryId),
      'icon': serializer.toJson<String>(icon),
      'purchasePrice': serializer.toJson<double>(purchasePrice),
      'purchaseDate': serializer.toJson<String>(purchaseDate),
      'warrantyEndDate': serializer.toJson<String?>(warrantyEndDate),
      'expectedLifeDays': serializer.toJson<int?>(expectedLifeDays),
      'status': serializer.toJson<String>(status),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  AssetDb copyWith(
          {String? id,
          String? name,
          String? categoryId,
          String? icon,
          double? purchasePrice,
          String? purchaseDate,
          Value<String?> warrantyEndDate = const Value.absent(),
          Value<int?> expectedLifeDays = const Value.absent(),
          String? status,
          Value<String?> note = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      AssetDb(
        id: id ?? this.id,
        name: name ?? this.name,
        categoryId: categoryId ?? this.categoryId,
        icon: icon ?? this.icon,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        warrantyEndDate: warrantyEndDate.present
            ? warrantyEndDate.value
            : this.warrantyEndDate,
        expectedLifeDays: expectedLifeDays.present
            ? expectedLifeDays.value
            : this.expectedLifeDays,
        status: status ?? this.status,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  AssetDb copyWithCompanion(AssetsCompanion data) {
    return AssetDb(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      icon: data.icon.present ? data.icon.value : this.icon,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      warrantyEndDate: data.warrantyEndDate.present
          ? data.warrantyEndDate.value
          : this.warrantyEndDate,
      expectedLifeDays: data.expectedLifeDays.present
          ? data.expectedLifeDays.value
          : this.expectedLifeDays,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetDb(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('icon: $icon, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('warrantyEndDate: $warrantyEndDate, ')
          ..write('expectedLifeDays: $expectedLifeDays, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      categoryId,
      icon,
      purchasePrice,
      purchaseDate,
      warrantyEndDate,
      expectedLifeDays,
      status,
      note,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetDb &&
          other.id == this.id &&
          other.name == this.name &&
          other.categoryId == this.categoryId &&
          other.icon == this.icon &&
          other.purchasePrice == this.purchasePrice &&
          other.purchaseDate == this.purchaseDate &&
          other.warrantyEndDate == this.warrantyEndDate &&
          other.expectedLifeDays == this.expectedLifeDays &&
          other.status == this.status &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class AssetsCompanion extends UpdateCompanion<AssetDb> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> categoryId;
  final Value<String> icon;
  final Value<double> purchasePrice;
  final Value<String> purchaseDate;
  final Value<String?> warrantyEndDate;
  final Value<int?> expectedLifeDays;
  final Value<String> status;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.icon = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.warrantyEndDate = const Value.absent(),
    this.expectedLifeDays = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetsCompanion.insert({
    required String id,
    required String name,
    required String categoryId,
    required String icon,
    required double purchasePrice,
    required String purchaseDate,
    this.warrantyEndDate = const Value.absent(),
    this.expectedLifeDays = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        categoryId = Value(categoryId),
        icon = Value(icon),
        purchasePrice = Value(purchasePrice),
        purchaseDate = Value(purchaseDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<AssetDb> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? categoryId,
    Expression<String>? icon,
    Expression<double>? purchasePrice,
    Expression<String>? purchaseDate,
    Expression<String>? warrantyEndDate,
    Expression<int>? expectedLifeDays,
    Expression<String>? status,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (icon != null) 'icon': icon,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (warrantyEndDate != null) 'warranty_end_date': warrantyEndDate,
      if (expectedLifeDays != null) 'expected_life_days': expectedLifeDays,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? categoryId,
      Value<String>? icon,
      Value<double>? purchasePrice,
      Value<String>? purchaseDate,
      Value<String?>? warrantyEndDate,
      Value<int?>? expectedLifeDays,
      Value<String>? status,
      Value<String?>? note,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return AssetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      icon: icon ?? this.icon,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      warrantyEndDate: warrantyEndDate ?? this.warrantyEndDate,
      expectedLifeDays: expectedLifeDays ?? this.expectedLifeDays,
      status: status ?? this.status,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<String>(purchaseDate.value);
    }
    if (warrantyEndDate.present) {
      map['warranty_end_date'] = Variable<String>(warrantyEndDate.value);
    }
    if (expectedLifeDays.present) {
      map['expected_life_days'] = Variable<int>(expectedLifeDays.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('icon: $icon, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('warrantyEndDate: $warrantyEndDate, ')
          ..write('expectedLifeDays: $expectedLifeDays, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, icon, description, sortOrder, isDefault, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryDb> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryDb extends DataClass implements Insertable<CategoryDb> {
  final String id;
  final String name;
  final String icon;
  final String description;
  final int sortOrder;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CategoryDb(
      {required this.id,
      required this.name,
      required this.icon,
      required this.description,
      required this.sortOrder,
      required this.isDefault,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['description'] = Variable<String>(description);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      description: Value(description),
      sortOrder: Value(sortOrder),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CategoryDb.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryDb(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      description: serializer.fromJson<String>(json['description']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'description': serializer.toJson<String>(description),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CategoryDb copyWith(
          {String? id,
          String? name,
          String? icon,
          String? description,
          int? sortOrder,
          bool? isDefault,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      CategoryDb(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        description: description ?? this.description,
        sortOrder: sortOrder ?? this.sortOrder,
        isDefault: isDefault ?? this.isDefault,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CategoryDb copyWithCompanion(CategoriesCompanion data) {
    return CategoryDb(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      description:
          data.description.present ? data.description.value : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryDb(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, icon, description, sortOrder, isDefault, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryDb &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesCompanion extends UpdateCompanion<CategoryDb> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<String> description;
  final Value<int> sortOrder;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    required String icon,
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDefault = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        icon = Value(icon),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CategoryDb> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? description,
    Expression<int>? sortOrder,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? icon,
      Value<String>? description,
      Value<int>? sortOrder,
      Value<bool>? isDefault,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MetricsCacheTable extends MetricsCache
    with TableInfo<$MetricsCacheTable, MetricsDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetricsCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _totalResidualValueMeta =
      const VerificationMeta('totalResidualValue');
  @override
  late final GeneratedColumn<double> totalResidualValue =
      GeneratedColumn<double>('total_residual_value', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _todayCostMeta =
      const VerificationMeta('todayCost');
  @override
  late final GeneratedColumn<double> todayCost = GeneratedColumn<double>(
      'today_cost', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _assetCountMeta =
      const VerificationMeta('assetCount');
  @override
  late final GeneratedColumn<int> assetCount = GeneratedColumn<int>(
      'asset_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _estimatedDailyCostMeta =
      const VerificationMeta('estimatedDailyCost');
  @override
  late final GeneratedColumn<double> estimatedDailyCost =
      GeneratedColumn<double>('estimated_daily_cost', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _snapshotDateMeta =
      const VerificationMeta('snapshotDate');
  @override
  late final GeneratedColumn<String> snapshotDate = GeneratedColumn<String>(
      'snapshot_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        totalResidualValue,
        todayCost,
        assetCount,
        estimatedDailyCost,
        snapshotDate,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metrics_cache';
  @override
  VerificationContext validateIntegrity(Insertable<MetricsDb> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('total_residual_value')) {
      context.handle(
          _totalResidualValueMeta,
          totalResidualValue.isAcceptableOrUnknown(
              data['total_residual_value']!, _totalResidualValueMeta));
    } else if (isInserting) {
      context.missing(_totalResidualValueMeta);
    }
    if (data.containsKey('today_cost')) {
      context.handle(_todayCostMeta,
          todayCost.isAcceptableOrUnknown(data['today_cost']!, _todayCostMeta));
    } else if (isInserting) {
      context.missing(_todayCostMeta);
    }
    if (data.containsKey('asset_count')) {
      context.handle(
          _assetCountMeta,
          assetCount.isAcceptableOrUnknown(
              data['asset_count']!, _assetCountMeta));
    } else if (isInserting) {
      context.missing(_assetCountMeta);
    }
    if (data.containsKey('estimated_daily_cost')) {
      context.handle(
          _estimatedDailyCostMeta,
          estimatedDailyCost.isAcceptableOrUnknown(
              data['estimated_daily_cost']!, _estimatedDailyCostMeta));
    } else if (isInserting) {
      context.missing(_estimatedDailyCostMeta);
    }
    if (data.containsKey('snapshot_date')) {
      context.handle(
          _snapshotDateMeta,
          snapshotDate.isAcceptableOrUnknown(
              data['snapshot_date']!, _snapshotDateMeta));
    } else if (isInserting) {
      context.missing(_snapshotDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MetricsDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetricsDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      totalResidualValue: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_residual_value'])!,
      todayCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}today_cost'])!,
      assetCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}asset_count'])!,
      estimatedDailyCost: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}estimated_daily_cost'])!,
      snapshotDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snapshot_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MetricsCacheTable createAlias(String alias) {
    return $MetricsCacheTable(attachedDatabase, alias);
  }
}

class MetricsDb extends DataClass implements Insertable<MetricsDb> {
  final int id;
  final double totalResidualValue;
  final double todayCost;
  final int assetCount;
  final double estimatedDailyCost;
  final String snapshotDate;
  final DateTime createdAt;
  const MetricsDb(
      {required this.id,
      required this.totalResidualValue,
      required this.todayCost,
      required this.assetCount,
      required this.estimatedDailyCost,
      required this.snapshotDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['total_residual_value'] = Variable<double>(totalResidualValue);
    map['today_cost'] = Variable<double>(todayCost);
    map['asset_count'] = Variable<int>(assetCount);
    map['estimated_daily_cost'] = Variable<double>(estimatedDailyCost);
    map['snapshot_date'] = Variable<String>(snapshotDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MetricsCacheCompanion toCompanion(bool nullToAbsent) {
    return MetricsCacheCompanion(
      id: Value(id),
      totalResidualValue: Value(totalResidualValue),
      todayCost: Value(todayCost),
      assetCount: Value(assetCount),
      estimatedDailyCost: Value(estimatedDailyCost),
      snapshotDate: Value(snapshotDate),
      createdAt: Value(createdAt),
    );
  }

  factory MetricsDb.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetricsDb(
      id: serializer.fromJson<int>(json['id']),
      totalResidualValue:
          serializer.fromJson<double>(json['totalResidualValue']),
      todayCost: serializer.fromJson<double>(json['todayCost']),
      assetCount: serializer.fromJson<int>(json['assetCount']),
      estimatedDailyCost:
          serializer.fromJson<double>(json['estimatedDailyCost']),
      snapshotDate: serializer.fromJson<String>(json['snapshotDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'totalResidualValue': serializer.toJson<double>(totalResidualValue),
      'todayCost': serializer.toJson<double>(todayCost),
      'assetCount': serializer.toJson<int>(assetCount),
      'estimatedDailyCost': serializer.toJson<double>(estimatedDailyCost),
      'snapshotDate': serializer.toJson<String>(snapshotDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MetricsDb copyWith(
          {int? id,
          double? totalResidualValue,
          double? todayCost,
          int? assetCount,
          double? estimatedDailyCost,
          String? snapshotDate,
          DateTime? createdAt}) =>
      MetricsDb(
        id: id ?? this.id,
        totalResidualValue: totalResidualValue ?? this.totalResidualValue,
        todayCost: todayCost ?? this.todayCost,
        assetCount: assetCount ?? this.assetCount,
        estimatedDailyCost: estimatedDailyCost ?? this.estimatedDailyCost,
        snapshotDate: snapshotDate ?? this.snapshotDate,
        createdAt: createdAt ?? this.createdAt,
      );
  MetricsDb copyWithCompanion(MetricsCacheCompanion data) {
    return MetricsDb(
      id: data.id.present ? data.id.value : this.id,
      totalResidualValue: data.totalResidualValue.present
          ? data.totalResidualValue.value
          : this.totalResidualValue,
      todayCost: data.todayCost.present ? data.todayCost.value : this.todayCost,
      assetCount:
          data.assetCount.present ? data.assetCount.value : this.assetCount,
      estimatedDailyCost: data.estimatedDailyCost.present
          ? data.estimatedDailyCost.value
          : this.estimatedDailyCost,
      snapshotDate: data.snapshotDate.present
          ? data.snapshotDate.value
          : this.snapshotDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetricsDb(')
          ..write('id: $id, ')
          ..write('totalResidualValue: $totalResidualValue, ')
          ..write('todayCost: $todayCost, ')
          ..write('assetCount: $assetCount, ')
          ..write('estimatedDailyCost: $estimatedDailyCost, ')
          ..write('snapshotDate: $snapshotDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, totalResidualValue, todayCost, assetCount,
      estimatedDailyCost, snapshotDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetricsDb &&
          other.id == this.id &&
          other.totalResidualValue == this.totalResidualValue &&
          other.todayCost == this.todayCost &&
          other.assetCount == this.assetCount &&
          other.estimatedDailyCost == this.estimatedDailyCost &&
          other.snapshotDate == this.snapshotDate &&
          other.createdAt == this.createdAt);
}

class MetricsCacheCompanion extends UpdateCompanion<MetricsDb> {
  final Value<int> id;
  final Value<double> totalResidualValue;
  final Value<double> todayCost;
  final Value<int> assetCount;
  final Value<double> estimatedDailyCost;
  final Value<String> snapshotDate;
  final Value<DateTime> createdAt;
  const MetricsCacheCompanion({
    this.id = const Value.absent(),
    this.totalResidualValue = const Value.absent(),
    this.todayCost = const Value.absent(),
    this.assetCount = const Value.absent(),
    this.estimatedDailyCost = const Value.absent(),
    this.snapshotDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MetricsCacheCompanion.insert({
    this.id = const Value.absent(),
    required double totalResidualValue,
    required double todayCost,
    required int assetCount,
    required double estimatedDailyCost,
    required String snapshotDate,
    required DateTime createdAt,
  })  : totalResidualValue = Value(totalResidualValue),
        todayCost = Value(todayCost),
        assetCount = Value(assetCount),
        estimatedDailyCost = Value(estimatedDailyCost),
        snapshotDate = Value(snapshotDate),
        createdAt = Value(createdAt);
  static Insertable<MetricsDb> custom({
    Expression<int>? id,
    Expression<double>? totalResidualValue,
    Expression<double>? todayCost,
    Expression<int>? assetCount,
    Expression<double>? estimatedDailyCost,
    Expression<String>? snapshotDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalResidualValue != null)
        'total_residual_value': totalResidualValue,
      if (todayCost != null) 'today_cost': todayCost,
      if (assetCount != null) 'asset_count': assetCount,
      if (estimatedDailyCost != null)
        'estimated_daily_cost': estimatedDailyCost,
      if (snapshotDate != null) 'snapshot_date': snapshotDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MetricsCacheCompanion copyWith(
      {Value<int>? id,
      Value<double>? totalResidualValue,
      Value<double>? todayCost,
      Value<int>? assetCount,
      Value<double>? estimatedDailyCost,
      Value<String>? snapshotDate,
      Value<DateTime>? createdAt}) {
    return MetricsCacheCompanion(
      id: id ?? this.id,
      totalResidualValue: totalResidualValue ?? this.totalResidualValue,
      todayCost: todayCost ?? this.todayCost,
      assetCount: assetCount ?? this.assetCount,
      estimatedDailyCost: estimatedDailyCost ?? this.estimatedDailyCost,
      snapshotDate: snapshotDate ?? this.snapshotDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (totalResidualValue.present) {
      map['total_residual_value'] = Variable<double>(totalResidualValue.value);
    }
    if (todayCost.present) {
      map['today_cost'] = Variable<double>(todayCost.value);
    }
    if (assetCount.present) {
      map['asset_count'] = Variable<int>(assetCount.value);
    }
    if (estimatedDailyCost.present) {
      map['estimated_daily_cost'] = Variable<double>(estimatedDailyCost.value);
    }
    if (snapshotDate.present) {
      map['snapshot_date'] = Variable<String>(snapshotDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetricsCacheCompanion(')
          ..write('id: $id, ')
          ..write('totalResidualValue: $totalResidualValue, ')
          ..write('todayCost: $todayCost, ')
          ..write('assetCount: $assetCount, ')
          ..write('estimatedDailyCost: $estimatedDailyCost, ')
          ..write('snapshotDate: $snapshotDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AssetsTable assets = $AssetsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $MetricsCacheTable metricsCache = $MetricsCacheTable(this);
  late final Index idxAssetsPurchaseDate = Index('idx_assets_purchase_date',
      'CREATE INDEX idx_assets_purchase_date ON assets (purchase_date)');
  late final Index idxAssetsCategoryId = Index('idx_assets_category_id',
      'CREATE INDEX idx_assets_category_id ON assets (category_id)');
  late final Index idxAssetsStatus = Index(
      'idx_assets_status', 'CREATE INDEX idx_assets_status ON assets (status)');
  late final Index idxAssetsDeletedAt = Index('idx_assets_deleted_at',
      'CREATE INDEX idx_assets_deleted_at ON assets (deleted_at)');
  late final Index idxCategoriesSortOrder = Index('idx_categories_sort_order',
      'CREATE INDEX idx_categories_sort_order ON categories (sort_order)');
  late final Index idxMetricsSnapshotDate = Index('idx_metrics_snapshot_date',
      'CREATE INDEX idx_metrics_snapshot_date ON metrics_cache (snapshot_date)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        assets,
        categories,
        metricsCache,
        idxAssetsPurchaseDate,
        idxAssetsCategoryId,
        idxAssetsStatus,
        idxAssetsDeletedAt,
        idxCategoriesSortOrder,
        idxMetricsSnapshotDate
      ];
}

typedef $$AssetsTableCreateCompanionBuilder = AssetsCompanion Function({
  required String id,
  required String name,
  required String categoryId,
  required String icon,
  required double purchasePrice,
  required String purchaseDate,
  Value<String?> warrantyEndDate,
  Value<int?> expectedLifeDays,
  Value<String> status,
  Value<String?> note,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$AssetsTableUpdateCompanionBuilder = AssetsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> categoryId,
  Value<String> icon,
  Value<double> purchasePrice,
  Value<String> purchaseDate,
  Value<String?> warrantyEndDate,
  Value<int?> expectedLifeDays,
  Value<String> status,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$AssetsTableFilterComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get warrantyEndDate => $composableBuilder(
      column: $table.warrantyEndDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expectedLifeDays => $composableBuilder(
      column: $table.expectedLifeDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$AssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get warrantyEndDate => $composableBuilder(
      column: $table.warrantyEndDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expectedLifeDays => $composableBuilder(
      column: $table.expectedLifeDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$AssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice, builder: (column) => column);

  GeneratedColumn<String> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => column);

  GeneratedColumn<String> get warrantyEndDate => $composableBuilder(
      column: $table.warrantyEndDate, builder: (column) => column);

  GeneratedColumn<int> get expectedLifeDays => $composableBuilder(
      column: $table.expectedLifeDays, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$AssetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AssetsTable,
    AssetDb,
    $$AssetsTableFilterComposer,
    $$AssetsTableOrderingComposer,
    $$AssetsTableAnnotationComposer,
    $$AssetsTableCreateCompanionBuilder,
    $$AssetsTableUpdateCompanionBuilder,
    (AssetDb, BaseReferences<_$AppDatabase, $AssetsTable, AssetDb>),
    AssetDb,
    PrefetchHooks Function()> {
  $$AssetsTableTableManager(_$AppDatabase db, $AssetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<double> purchasePrice = const Value.absent(),
            Value<String> purchaseDate = const Value.absent(),
            Value<String?> warrantyEndDate = const Value.absent(),
            Value<int?> expectedLifeDays = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AssetsCompanion(
            id: id,
            name: name,
            categoryId: categoryId,
            icon: icon,
            purchasePrice: purchasePrice,
            purchaseDate: purchaseDate,
            warrantyEndDate: warrantyEndDate,
            expectedLifeDays: expectedLifeDays,
            status: status,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String categoryId,
            required String icon,
            required double purchasePrice,
            required String purchaseDate,
            Value<String?> warrantyEndDate = const Value.absent(),
            Value<int?> expectedLifeDays = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> note = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AssetsCompanion.insert(
            id: id,
            name: name,
            categoryId: categoryId,
            icon: icon,
            purchasePrice: purchasePrice,
            purchaseDate: purchaseDate,
            warrantyEndDate: warrantyEndDate,
            expectedLifeDays: expectedLifeDays,
            status: status,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AssetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AssetsTable,
    AssetDb,
    $$AssetsTableFilterComposer,
    $$AssetsTableOrderingComposer,
    $$AssetsTableAnnotationComposer,
    $$AssetsTableCreateCompanionBuilder,
    $$AssetsTableUpdateCompanionBuilder,
    (AssetDb, BaseReferences<_$AppDatabase, $AssetsTable, AssetDb>),
    AssetDb,
    PrefetchHooks Function()>;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required String name,
  required String icon,
  Value<String> description,
  Value<int> sortOrder,
  Value<bool> isDefault,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> icon,
  Value<String> description,
  Value<int> sortOrder,
  Value<bool> isDefault,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    CategoryDb,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (CategoryDb, BaseReferences<_$AppDatabase, $CategoriesTable, CategoryDb>),
    CategoryDb,
    PrefetchHooks Function()> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            icon: icon,
            description: description,
            sortOrder: sortOrder,
            isDefault: isDefault,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String icon,
            Value<String> description = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            icon: icon,
            description: description,
            sortOrder: sortOrder,
            isDefault: isDefault,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    CategoryDb,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (CategoryDb, BaseReferences<_$AppDatabase, $CategoriesTable, CategoryDb>),
    CategoryDb,
    PrefetchHooks Function()>;
typedef $$MetricsCacheTableCreateCompanionBuilder = MetricsCacheCompanion
    Function({
  Value<int> id,
  required double totalResidualValue,
  required double todayCost,
  required int assetCount,
  required double estimatedDailyCost,
  required String snapshotDate,
  required DateTime createdAt,
});
typedef $$MetricsCacheTableUpdateCompanionBuilder = MetricsCacheCompanion
    Function({
  Value<int> id,
  Value<double> totalResidualValue,
  Value<double> todayCost,
  Value<int> assetCount,
  Value<double> estimatedDailyCost,
  Value<String> snapshotDate,
  Value<DateTime> createdAt,
});

class $$MetricsCacheTableFilterComposer
    extends Composer<_$AppDatabase, $MetricsCacheTable> {
  $$MetricsCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalResidualValue => $composableBuilder(
      column: $table.totalResidualValue,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get todayCost => $composableBuilder(
      column: $table.todayCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get assetCount => $composableBuilder(
      column: $table.assetCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get estimatedDailyCost => $composableBuilder(
      column: $table.estimatedDailyCost,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotDate => $composableBuilder(
      column: $table.snapshotDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$MetricsCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $MetricsCacheTable> {
  $$MetricsCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalResidualValue => $composableBuilder(
      column: $table.totalResidualValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get todayCost => $composableBuilder(
      column: $table.todayCost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get assetCount => $composableBuilder(
      column: $table.assetCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get estimatedDailyCost => $composableBuilder(
      column: $table.estimatedDailyCost,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotDate => $composableBuilder(
      column: $table.snapshotDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$MetricsCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetricsCacheTable> {
  $$MetricsCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get totalResidualValue => $composableBuilder(
      column: $table.totalResidualValue, builder: (column) => column);

  GeneratedColumn<double> get todayCost =>
      $composableBuilder(column: $table.todayCost, builder: (column) => column);

  GeneratedColumn<int> get assetCount => $composableBuilder(
      column: $table.assetCount, builder: (column) => column);

  GeneratedColumn<double> get estimatedDailyCost => $composableBuilder(
      column: $table.estimatedDailyCost, builder: (column) => column);

  GeneratedColumn<String> get snapshotDate => $composableBuilder(
      column: $table.snapshotDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MetricsCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MetricsCacheTable,
    MetricsDb,
    $$MetricsCacheTableFilterComposer,
    $$MetricsCacheTableOrderingComposer,
    $$MetricsCacheTableAnnotationComposer,
    $$MetricsCacheTableCreateCompanionBuilder,
    $$MetricsCacheTableUpdateCompanionBuilder,
    (MetricsDb, BaseReferences<_$AppDatabase, $MetricsCacheTable, MetricsDb>),
    MetricsDb,
    PrefetchHooks Function()> {
  $$MetricsCacheTableTableManager(_$AppDatabase db, $MetricsCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetricsCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetricsCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetricsCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> totalResidualValue = const Value.absent(),
            Value<double> todayCost = const Value.absent(),
            Value<int> assetCount = const Value.absent(),
            Value<double> estimatedDailyCost = const Value.absent(),
            Value<String> snapshotDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              MetricsCacheCompanion(
            id: id,
            totalResidualValue: totalResidualValue,
            todayCost: todayCost,
            assetCount: assetCount,
            estimatedDailyCost: estimatedDailyCost,
            snapshotDate: snapshotDate,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double totalResidualValue,
            required double todayCost,
            required int assetCount,
            required double estimatedDailyCost,
            required String snapshotDate,
            required DateTime createdAt,
          }) =>
              MetricsCacheCompanion.insert(
            id: id,
            totalResidualValue: totalResidualValue,
            todayCost: todayCost,
            assetCount: assetCount,
            estimatedDailyCost: estimatedDailyCost,
            snapshotDate: snapshotDate,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MetricsCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MetricsCacheTable,
    MetricsDb,
    $$MetricsCacheTableFilterComposer,
    $$MetricsCacheTableOrderingComposer,
    $$MetricsCacheTableAnnotationComposer,
    $$MetricsCacheTableCreateCompanionBuilder,
    $$MetricsCacheTableUpdateCompanionBuilder,
    (MetricsDb, BaseReferences<_$AppDatabase, $MetricsCacheTable, MetricsDb>),
    MetricsDb,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AssetsTableTableManager get assets =>
      $$AssetsTableTableManager(_db, _db.assets);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$MetricsCacheTableTableManager get metricsCache =>
      $$MetricsCacheTableTableManager(_db, _db.metricsCache);
}
