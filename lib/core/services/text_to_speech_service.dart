import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  TextToSpeechService() : _tts = FlutterTts();

  final FlutterTts _tts;

  bool _initialized = false;

  Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.42);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);

      _initialized = true;
      return true;
    } catch (_) {
      return false;
    }
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