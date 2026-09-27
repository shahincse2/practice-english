import 'package:shared_preferences/shared_preferences.dart';

import '../../models/audio_settings.dart';

class AudioSettingsService {
  static const _voiceName = 'voice_name';
  static const _voiceLocale = 'voice_locale';
  static const _speechRate = 'speech_rate';
  static const _speechVolume = 'speech_volume';
  static const _correctVolume = 'correct_volume';
  static const _wrongVolume = 'wrong_volume';

  Future<AudioSettings> load() async {
    final prefs = await SharedPreferences.getInstance();

    return AudioSettings(
      voiceName: prefs.getString(_voiceName),
      voiceLocale: prefs.getString(_voiceLocale) ?? 'en-US',
      speechRate: prefs.getDouble(_speechRate) ?? 0.42,
      speechVolume: prefs.getDouble(_speechVolume) ?? 1.0,
      correctVolume: prefs.getDouble(_correctVolume) ?? 1.0,
      wrongVolume: prefs.getDouble(_wrongVolume) ?? 1.0,
    );
  }

  Future<void> save(AudioSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_voiceLocale, settings.voiceLocale);
    await prefs.setDouble(_speechRate, settings.speechRate);
    await prefs.setDouble(_speechVolume, settings.speechVolume);
    await prefs.setDouble(_correctVolume, settings.correctVolume);
    await prefs.setDouble(_wrongVolume, settings.wrongVolume);

    if (settings.voiceName == null) {
      await prefs.remove(_voiceName);
    } else {
      await prefs.setString(_voiceName, settings.voiceName!);
    }
  }
}