/// 输入验证服务
class ValidationService {
  ValidationService._();

  /// 验证资产名称
  static String? validateAssetName(String? value) {
    if (value == null || value.isEmpty) {
      return '资产名称不能为空';
    }
    if (value.length > 40) {
      return '资产名称不能超过40个字符';
    }
    return null;
  }

  /// 验证购买价格
  static String? validatePurchasePrice(double? value) {
    if (value == null || value <= 0) {
      return '购买价格必须大于0';
    }
    return null;
  }

  /// 验证购买日期
  static String? validatePurchaseDate(DateTime? value) {
    if (value == null) {
      return '购买日期不能为空';
    }
    if (value.isAfter(DateTime.now())) {
      return '购买日期不能晚于今天';
    }
    return null;
  }

  /// 验证分类ID
  static String? validateCategoryId(String? value) {
    if (value == null || value.isEmpty) {
      return '分类不能为空';
    }
    return null;
  }

  /// 验证图标
  static String? validateIcon(String? value) {
    if (value == null || value.isEmpty) {
      return '图标不能为空';
    }
    return null;
  }
}
