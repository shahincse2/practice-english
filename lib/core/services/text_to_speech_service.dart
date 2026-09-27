import 'package:flutter_tts/flutter_tts.dart';

import '../../models/audio_settings.dart';
import 'audio_settings_service.dart';

class TextToSpeechService {
  TextToSpeechService() : _tts = FlutterTts();

  final FlutterTts _tts;
  final AudioSettingsService _settingsService = AudioSettingsService();

  bool _initialized = false;

  Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      final settings = await _settingsService.load();

      await _tts.setLanguage(settings.voiceLocale);
      await _tts.setSpeechRate(settings.speechRate);
      await _tts.setVolume(settings.speechVolume);
      await _tts.setPitch(1.0);

      if (settings.voiceName != null) {
        await _setVoice(settings.voiceName!, settings.voiceLocale);
      }

      _initialized = true;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _setVoice(String name, String locale) async {
    await _tts.setVoice({'name': name, 'locale': locale});
  }

  Future<List<Map<String, String>>> getEnglishVoices() async {
    try {
      await initialize();

      final result = await _tts.getVoices;
      if (result is! List) return [];

      final voices = result
          .whereType<Map>()
          .map(
            (voice) => voice.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            ),
          )
          .toList();

      return voices.where(_isEnglish).toList();
    } catch (_) {
      return [];
    }
  }

  bool _isEnglish(Map<String, String> voice) {
    final locale = (voice['locale'] ?? '').toLowerCase();

    return locale == 'en' ||
        locale.startsWith('en-') ||
        locale.startsWith('eng-');
  }

  Future<void> previewVoice({
    required String name,
    required String locale,
  }) async {
    try {
      await initialize();
      await _tts.stop();
      await _tts.setLanguage(locale);
      await _setVoice(name, locale);
      await _tts.speak('Hello, this is a sample of my voice.');
    } catch (_) {}
  }

  Future<void> applySettings(AudioSettings settings) async {
    try {
      await initialize();
      await _tts.stop();

      await _tts.setLanguage(settings.voiceLocale);
      await _tts.setSpeechRate(settings.speechRate);
      await _tts.setVolume(settings.speechVolume);

      if (settings.voiceName != null) {
        await _setVoice(settings.voiceName!, settings.voiceLocale);
      }
    } catch (_) {}
  }

  Future<bool> speak(String text) async {
    try {
      if (!_initialized) {
        final ready = await initialize();
        if (!ready) return false;
      }

      await _tts.stop();
      await _tts.speak(text);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }

  Future<void> dispose() async {
    await stop();
  }
}
