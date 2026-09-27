import 'package:audioplayers/audioplayers.dart';

import 'audio_settings_service.dart';

class AnswerSoundService {
  final AudioPlayer _correctPlayer = AudioPlayer();
  final AudioPlayer _wrongPlayer = AudioPlayer();
  final AudioPlayer _cheeringPlayer = AudioPlayer();

  Future<void> initialize() async {
    final settings = await AudioSettingsService().load();

    await _correctPlayer.setReleaseMode(ReleaseMode.stop);
    await _wrongPlayer.setReleaseMode(ReleaseMode.stop);
    await _cheeringPlayer.setReleaseMode(ReleaseMode.stop);

    await _correctPlayer.setVolume(settings.correctVolume);
    await _wrongPlayer.setVolume(settings.wrongVolume);
  }

  Future<void> setCorrectVolume(double volume) {
    return _correctPlayer.setVolume(volume);
  }

  Future<void> setWrongVolume(double volume) {
    return _wrongPlayer.setVolume(volume);
  }

  Future<void> playCorrect() async {
    await _correctPlayer.stop();
    await _correctPlayer.play(AssetSource('sounds/correct.mp3'));
  }

  Future<void> playWrong() async {
    await _wrongPlayer.stop();
    await _wrongPlayer.play(AssetSource('sounds/wrong.mp3'));
  }

  Future<void> playCheering() async {
    await _cheeringPlayer.stop();
    await _cheeringPlayer.play(AssetSource('sounds/cheering.mp3'));
  }

  Future<void> dispose() async {
    await _correctPlayer.dispose();
    await _wrongPlayer.dispose();
    await _cheeringPlayer.dispose();
  }
}
