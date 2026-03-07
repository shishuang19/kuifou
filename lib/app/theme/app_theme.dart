import 'package:flutter/material.dart';

import 'colors.dart';
import 'typography.dart';

class AppTheme {
  const AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF3F4F6),
    colorScheme: const ColorScheme.light(
      primary: AppColors.gradientStart,
      secondary: AppColors.gradientEnd,
      surface: Color(0xFFFFFFFF),
      error: AppColors.danger,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bgPrimary,
    textTheme: AppTypography.textTheme,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.gradientStart,
      secondary: AppColors.gradientEnd,
      surface: AppColors.cardBg,
      error: AppColors.danger,
    ),
  );
}
