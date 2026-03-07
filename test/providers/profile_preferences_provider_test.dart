import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kuifou/features/profile/data/services/profile_preferences_service.dart';
import 'package:kuifou/features/profile/domain/entities/profile_preferences.dart';
import 'package:kuifou/features/profile/presentation/providers/profile_preferences_provider.dart';

Future<ProfilePreferences> waitForPreferences(
    ProviderContainer container) async {
  final current = container.read(profilePreferencesNotifierProvider);
  if (current.hasValue && current.valueOrNull != null) {
    return current.value!;
  }

  final completer = Completer<ProfilePreferences>();
  late final ProviderSubscription<AsyncValue<ProfilePreferences>> subscription;

  subscription = container.listen(
    profilePreferencesNotifierProvider,
    (previous, next) {
      if (next.hasValue && next.valueOrNull != null && !completer.isCompleted) {
        completer.complete(next.value!);
      }
    },
    fireImmediately: true,
  );

  try {
    return await completer.future.timeout(const Duration(seconds: 2));
  } finally {
    subscription.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfilePreferencesProvider', () {
    test('loads default preferences when storage is empty', () async {
      SharedPreferences.setMockInitialValues({});

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final preferences = await waitForPreferences(container);

      expect(preferences.themePreference, ThemePreference.dark);
      expect(preferences.languagePreference, LanguagePreference.zhCn);
      expect(
        preferences.depreciationMethodPreference,
        DepreciationMethodPreference.straightLine,
      );
    });

    test('persists updated preferences to local storage', () async {
      SharedPreferences.setMockInitialValues({});

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await waitForPreferences(container);

      final notifier =
          container.read(profilePreferencesNotifierProvider.notifier);
      await notifier.updateThemePreference(ThemePreference.light);
      await notifier.updateLanguagePreference(LanguagePreference.enUs);
      await notifier.updateDepreciationMethodPreference(
        DepreciationMethodPreference.doubleDeclining,
      );

      final reloadedContainer = ProviderContainer();
      addTearDown(reloadedContainer.dispose);

      final reloaded = await waitForPreferences(reloadedContainer);

      expect(reloaded.themePreference, ThemePreference.light);
      expect(reloaded.languagePreference, LanguagePreference.enUs);
      expect(
        reloaded.depreciationMethodPreference,
        DepreciationMethodPreference.doubleDeclining,
      );
    });

    test('resetToDefaults writes default values', () async {
      SharedPreferences.setMockInitialValues({
        ProfilePreferencesService.themePreferenceKey: 'light',
        ProfilePreferencesService.languagePreferenceKey: 'en_US',
        ProfilePreferencesService.depreciationMethodPreferenceKey:
            'double_declining',
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await waitForPreferences(container);
      await container
          .read(profilePreferencesNotifierProvider.notifier)
          .resetToDefaults();

      final values = await SharedPreferences.getInstance();
      expect(
        values.getString(ProfilePreferencesService.themePreferenceKey),
        ThemePreference.dark.storageValue,
      );
      expect(
        values.getString(ProfilePreferencesService.languagePreferenceKey),
        LanguagePreference.zhCn.storageValue,
      );
      expect(
        values.getString(
            ProfilePreferencesService.depreciationMethodPreferenceKey),
        DepreciationMethodPreference.straightLine.storageValue,
      );
    });
    test('appLocaleProvider follows selected language preference', () async {
      SharedPreferences.setMockInitialValues({});

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await waitForPreferences(container);

      expect(container.read(appLocaleProvider), const Locale('zh', 'CN'));

      await container
          .read(profilePreferencesNotifierProvider.notifier)
          .updateLanguagePreference(LanguagePreference.enUs);

      expect(container.read(appLocaleProvider), const Locale('en', 'US'));
    });
  });
}
