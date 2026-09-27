import 'package:shared_preferences/shared_preferences.dart';

import '../../models/app_theme_mode.dart';

class ThemeSettingsService {
  static const _key = 'app_theme_mode';

  Future<AppThemeMode> load() async {
    final prefs = await SharedPreferences.getInstance();

    return AppThemeModeX.fromStorage(
      prefs.getString(_key),
    );
  }

  Future<void> save(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _key,
      mode.storageValue,
    );
  }
}