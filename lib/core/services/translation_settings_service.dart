import 'package:shared_preferences/shared_preferences.dart';

import '../../models/translation_settings.dart';

class TranslationSettingsService {
  static const _languageKey = 'translation_language_code';
  static const _showKey = 'show_translations_during_practice';

  Future<TranslationSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return TranslationSettings(
      languageCode: prefs.getString(_languageKey) ?? 'bn',
      showDuringPractice: prefs.getBool(_showKey) ?? true,
    );
  }

  Future<void> save(TranslationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, settings.languageCode);
    await prefs.setBool(_showKey, settings.showDuringPractice);
  }
}
