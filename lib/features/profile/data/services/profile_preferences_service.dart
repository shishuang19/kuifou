import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/profile_preferences.dart';

class ProfilePreferencesService {
  const ProfilePreferencesService();

  static const themePreferenceKey = 'profile.theme_preference';
  static const languagePreferenceKey = 'profile.language_preference';
  static const depreciationMethodPreferenceKey =
      'profile.depreciation_method_preference';

  Future<ProfilePreferences> load() async {
    final prefs = await SharedPreferences.getInstance();

    return ProfilePreferences(
      themePreference:
          ThemePreference.fromStorage(prefs.getString(themePreferenceKey)),
      languagePreference: LanguagePreference.fromStorage(
          prefs.getString(languagePreferenceKey)),
      depreciationMethodPreference: DepreciationMethodPreference.fromStorage(
        prefs.getString(depreciationMethodPreferenceKey),
      ),
    );
  }

  Future<void> save(ProfilePreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      themePreferenceKey,
      preferences.themePreference.storageValue,
    );
    await prefs.setString(
      languagePreferenceKey,
      preferences.languagePreference.storageValue,
    );
    await prefs.setString(
      depreciationMethodPreferenceKey,
      preferences.depreciationMethodPreference.storageValue,
    );
  }
}
