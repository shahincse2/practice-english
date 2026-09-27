import 'package:flutter/material.dart';

import '../core/services/answer_sound_service.dart';
import '../core/services/audio_settings_service.dart';
import '../core/services/text_to_speech_service.dart';
import '../models/audio_settings.dart';
import '../widgets/audio_setting_card.dart';
import '../widgets/voice_carousel.dart';

class AudioSettingsScreen extends StatefulWidget {
  const AudioSettingsScreen({super.key});

  @override
  State<AudioSettingsScreen> createState() => _AudioSettingsScreenState();
}

class _AudioSettingsScreenState extends State<AudioSettingsScreen> {
  final _store = AudioSettingsService();
  final _tts = TextToSpeechService();
  final _sounds = AnswerSoundService();
  final _pageController = PageController();

  AudioSettings _settings = const AudioSettings();
  List<Map<String, String>> _voices = [];
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

    setState(() {
      _settings = settings;
      _voices = voices;
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

    final index = _pageController.page?.round() ?? 0;
    final voice = _voices[index];

    final settings = _settings.copyWith(
      voiceName: voice['name'],
      voiceLocale: voice['locale'] ?? 'en-US',
    );

    await _store.save(settings);
    await _tts.applySettings(settings);

    if (mounted) setState(() => _settings = settings);
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
    _pageController.dispose();
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
      appBar: AppBar(title: const Text('Audio Settings')),
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
              controller: _pageController,
              voices: _voices,
              selectedName: _settings.voiceName,
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
          _speedSection(),
          const SizedBox(height: 16),
          _volumeSection(),
        ],
      ),
    );
  }

  Widget _speedSection() {
    return AudioSettingCard(
      title: 'Speech Speed',
      value: _settings.speechRate.toStringAsFixed(2),
      child: Slider(
        value: _settings.speechRate,
        min: 0.2,
        max: 0.8,
        divisions: 12,
        onChanged: (value) {
          _update(_settings.copyWith(speechRate: value), previewSpeech: true);
        },
      ),
    );
  }

  Widget _volumeSection() {
    return AudioSettingCard(
      title: 'Volume',
      child: Column(
        children: [
          _speechSlider(),
          _soundSlider(
            'Correct Sound',
            _settings.correctVolume,
            _changeCorrectVolume,
          ),
          _soundSlider(
            'Wrong Sound',
            _settings.wrongVolume,
            _changeWrongVolume,
          ),
        ],
      ),
    );
  }

  Widget _speechSlider() {
    return _soundSlider('Speech', _settings.speechVolume, (value) {
      _update(_settings.copyWith(speechVolume: value), previewSpeech: true);
    });
  }

  Widget _soundSlider(
    String title,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title),
          trailing: Text('${(value * 100).round()}%'),
        ),
        Slider(value: value, onChanged: onChanged),
      ],
    );
  }
}
