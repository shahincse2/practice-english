import 'package:flutter/material.dart';

import '../core/services/answer_sound_service.dart';
import '../core/services/audio_settings_service.dart';
import '../core/services/text_to_speech_service.dart';
import '../models/audio_settings.dart';
import '../widgets/settings_audio_section.dart';
import '../widgets/theme_menu.dart';
import '../widgets/voice_carousel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _store = AudioSettingsService();
  final _tts = TextToSpeechService();
  final _sounds = AnswerSoundService();

  AudioSettings _settings = const AudioSettings();
  List<Map<String, String>> _voices = [];
  int _currentVoiceIndex = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = await _store.load();

    await _tts.initialize();
    await _sounds.initialize();

    final voices = await _tts.getEnglishVoices();

    if (!mounted) return;

    final selectedIndex = voices.indexWhere(
      (voice) => voice['name'] == settings.voiceName,
    );

    setState(() {
      _settings = settings;
      _voices = voices;
      _currentVoiceIndex = selectedIndex >= 0 ? selectedIndex : 0;
      _loading = false;
    });
  }

  Future<void> _preview(Map<String, String> voice) {
    return _tts.previewVoice(
      name: voice['name'] ?? '',
      locale: voice['locale'] ?? 'en-US',
    );
  }

  Future<void> _selectCurrentVoice() async {
    if (_voices.isEmpty) return;

    final voice = _voices[_currentVoiceIndex];

    final settings = _settings.copyWith(
      voiceName: voice['name'],
      voiceLocale: voice['locale'] ?? 'en-US',
    );

    await _store.save(settings);
    await _tts.applySettings(settings);

    if (mounted) {
      setState(() => _settings = settings);
    }
  }

  Future<void> _update(
    AudioSettings settings, {
    bool previewSpeech = false,
  }) async {
    setState(() => _settings = settings);

    await _store.save(settings);
    await _tts.applySettings(settings);

    if (previewSpeech) {
      await _tts.speak('Hello, this is a sample of my voice.');
    }
  }

  Future<void> _changeCorrectVolume(double value) async {
    final settings = _settings.copyWith(correctVolume: value);

    setState(() => _settings = settings);
    await _store.save(settings);
    await _sounds.setCorrectVolume(value);
    await _sounds.playCorrect();
  }

  Future<void> _changeWrongVolume(double value) async {
    final settings = _settings.copyWith(wrongVolume: value);

    setState(() => _settings = settings);
    await _store.save(settings);
    await _sounds.setWrongVolume(value);
    await _sounds.playWrong();
  }

  @override
  void dispose() {
    _tts.dispose();
    _sounds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: const [ThemeMenu()],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          const Center(
            child: Text(
              'Voice',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          if (_voices.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No English voices found')),
            )
          else ...[
            VoiceCarousel(
              voices: _voices,
              selectedName: _settings.voiceName,
              onPageChanged: (index) {
                _currentVoiceIndex = index;
              },
              onPreview: _preview,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _selectCurrentVoice,
                child: const Text('Use this voice'),
              ),
            ),
          ],
          const SizedBox(height: 20),
          SettingsAudioSection(
            settings: _settings,
            onSettingsChanged: _update,
            onCorrectVolumeChanged: _changeCorrectVolume,
            onWrongVolumeChanged: _changeWrongVolume,
          ),
        ],
      ),
    );
  }
}
