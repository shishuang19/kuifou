import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/profile_preferences_service.dart';
import '../../domain/entities/profile_preferences.dart';

final profilePreferencesServiceProvider =
    Provider<ProfilePreferencesService>((ref) {
  return const ProfilePreferencesService();
});

final profilePreferencesNotifierProvider = StateNotifierProvider<
    ProfilePreferencesNotifier, AsyncValue<ProfilePreferences>>((ref) {
  final notifier = ProfilePreferencesNotifier(
    service: ref.watch(profilePreferencesServiceProvider),
  );
  notifier.load();
  return notifier;
});

final appThemeModeProvider = Provider<ThemeMode>((ref) {
  final preference = ref.watch(profilePreferencesNotifierProvider).valueOrNull;
  return preference?.themePreference.themeMode ?? ThemeMode.dark;
});

final appLocaleProvider = Provider<Locale>((ref) {
  final preference = ref.watch(profilePreferencesNotifierProvider).valueOrNull;
  return (preference?.languagePreference ?? LanguagePreference.zhCn).locale;
});

final defaultDepreciationMethodPreferenceProvider =
    Provider<DepreciationMethodPreference>((ref) {
  final preference = ref.watch(profilePreferencesNotifierProvider).valueOrNull;
  return preference?.depreciationMethodPreference ??
      DepreciationMethodPreference.straightLine;
});

class ProfilePreferencesNotifier
    extends StateNotifier<AsyncValue<ProfilePreferences>> {
  ProfilePreferencesNotifier({
    required ProfilePreferencesService service,
  })  : _service = service,
        super(const AsyncValue.loading());

  final ProfilePreferencesService _service;

  Future<void> load() async {
    try {
      final preferences = await _service.load();
      state = AsyncValue.data(preferences);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateThemePreference(ThemePreference value) async {
    await _saveWith((current) => current.copyWith(themePreference: value));
  }

  Future<void> updateLanguagePreference(LanguagePreference value) async {
    await _saveWith((current) => current.copyWith(languagePreference: value));
  }

  Future<void> updateDepreciationMethodPreference(
    DepreciationMethodPreference value,
  ) async {
    await _saveWith(
      (current) => current.copyWith(depreciationMethodPreference: value),
    );
  }

  Future<void> resetToDefaults() async {
    try {
      state = const AsyncValue.data(ProfilePreferences.defaults);
      await _service.save(ProfilePreferences.defaults);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _saveWith(
    ProfilePreferences Function(ProfilePreferences current) updater,
  ) async {
    try {
      final current = state.valueOrNull ?? await _service.load();
      final updated = updater(current);
      state = AsyncValue.data(updated);
      await _service.save(updated);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
