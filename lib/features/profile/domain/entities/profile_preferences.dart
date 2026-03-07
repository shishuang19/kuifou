import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ThemePreference {
  system(
    storageValue: 'system',
    label: '跟随系统',
    themeMode: ThemeMode.system,
  ),
  dark(
    storageValue: 'dark',
    label: '深色',
    themeMode: ThemeMode.dark,
  ),
  light(
    storageValue: 'light',
    label: '浅色',
    themeMode: ThemeMode.light,
  );

  const ThemePreference({
    required this.storageValue,
    required this.label,
    required this.themeMode,
  });

  final String storageValue;
  final String label;
  final ThemeMode themeMode;

  static ThemePreference fromStorage(String? value) {
    return ThemePreference.values.firstWhere(
      (item) => item.storageValue == value,
      orElse: () => ThemePreference.dark,
    );
  }
}

enum LanguagePreference {
  zhCn(
    storageValue: 'zh_CN',
    label: '简体中文',
  ),
  enUs(
    storageValue: 'en_US',
    label: 'English',
  );

  const LanguagePreference({
    required this.storageValue,
    required this.label,
  });

  final String storageValue;
  final String label;

  Locale get locale {
    return switch (this) {
      LanguagePreference.zhCn => const Locale('zh', 'CN'),
      LanguagePreference.enUs => const Locale('en', 'US'),
    };
  }

  static LanguagePreference fromStorage(String? value) {
    return LanguagePreference.values.firstWhere(
      (item) => item.storageValue == value,
      orElse: () => LanguagePreference.zhCn,
    );
  }
}

enum DepreciationMethodPreference {
  straightLine(
    storageValue: 'straight_line',
    label: '直线折旧',
  ),
  doubleDeclining(
    storageValue: 'double_declining',
    label: '双倍余额递减',
  );

  const DepreciationMethodPreference({
    required this.storageValue,
    required this.label,
  });

  final String storageValue;
  final String label;

  int get defaultExpectedLifeDays {
    return switch (this) {
      DepreciationMethodPreference.straightLine => 1095,
      DepreciationMethodPreference.doubleDeclining => 730,
    };
  }

  static DepreciationMethodPreference fromExpectedLifeDays(int? value) {
    if (value != null && value <= 730) {
      return DepreciationMethodPreference.doubleDeclining;
    }
    return DepreciationMethodPreference.straightLine;
  }

  static DepreciationMethodPreference fromStorage(String? value) {
    return DepreciationMethodPreference.values.firstWhere(
      (item) => item.storageValue == value,
      orElse: () => DepreciationMethodPreference.straightLine,
    );
  }
}

class ProfilePreferences extends Equatable {
  final ThemePreference themePreference;
  final LanguagePreference languagePreference;
  final DepreciationMethodPreference depreciationMethodPreference;

  const ProfilePreferences({
    required this.themePreference,
    required this.languagePreference,
    required this.depreciationMethodPreference,
  });

  static const defaults = ProfilePreferences(
    themePreference: ThemePreference.dark,
    languagePreference: LanguagePreference.zhCn,
    depreciationMethodPreference: DepreciationMethodPreference.straightLine,
  );

  ProfilePreferences copyWith({
    ThemePreference? themePreference,
    LanguagePreference? languagePreference,
    DepreciationMethodPreference? depreciationMethodPreference,
  }) {
    return ProfilePreferences(
      themePreference: themePreference ?? this.themePreference,
      languagePreference: languagePreference ?? this.languagePreference,
      depreciationMethodPreference:
          depreciationMethodPreference ?? this.depreciationMethodPreference,
    );
  }

  @override
  List<Object?> get props => [
        themePreference,
        languagePreference,
        depreciationMethodPreference,
      ];
}
