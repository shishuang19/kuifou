/// 折旧计算服务
/// 
/// 核心逻辑：
/// - 使用天数最小为1（防止除零）  
/// - 每日成本 = 购买价格 / 使用天数
/// - 当前残值 = 购买价格 - (每日成本 × 使用天数)
class DepreciationService {
  DepreciationService._();

  /// 计算使用天数
  static int calculateUsageDays(DateTime purchaseDate) {
    final diff = DateTime.now().difference(purchaseDate).inDays;
    return diff < 1 ? 1 : diff;
  }

  /// 计算每日成本
  static double calculateDailyCost(
    double purchasePrice,
    DateTime purchaseDate,
  ) {
    final usageDays = calculateUsageDays(purchaseDate);
    return purchasePrice / usageDays;
  }

  /// 计算当前残值
  static double calculateResidualValue(
    double purchasePrice,
    DateTime purchaseDate,
  ) {
    final usageDays = calculateUsageDays(purchaseDate);
    final dailyCost = calculateDailyCost(purchasePrice, purchaseDate);
    return purchasePrice - (dailyCost * usageDays);
  }

  /// 按预期寿命计算每日成本（高级模式）
  static double calculateDailyCostByExpectedLife(
    double purchasePrice,
    int expectedLifeDays,
  ) {
    if (expectedLifeDays <= 0) {
      throw ArgumentError('expectedLifeDays must be greater than 0');
    }
    return purchasePrice / expectedLifeDays;
  }
}
