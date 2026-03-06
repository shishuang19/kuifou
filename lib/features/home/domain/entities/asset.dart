import 'package:equatable/equatable.dart';

enum AssetStatus {
  using('using'),
  idle('idle'),
  disposed('disposed');

  final String value;
  const AssetStatus(this.value);
}

class Asset extends Equatable {
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

  const Asset({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.icon,
    required this.purchasePrice,
    required this.purchaseDate,
    this.warrantyEndDate,
    this.expectedLifeDays,
    this.status = AssetStatus.using,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 计算使用天数（最少1天，防止除零）
  int get usageDays {
    final diff = DateTime.now().difference(purchaseDate).inDays;
    return diff < 1 ? 1 : diff;
  }

  /// 每日成本（元）
  double get dailyCost {
    return purchasePrice / usageDays;
  }

  /// 当前残值（元）
  double get residualValue {
    return purchasePrice - (dailyCost * usageDays);
  }

  @override
  List<Object?> get props => [
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
      ];
}
