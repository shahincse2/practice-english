import 'package:flutter/material.dart';

import '../models/audio_settings.dart';
import 'audio_setting_card.dart';

class SettingsAudioSection extends StatelessWidget {
  const SettingsAudioSection({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
    required this.onCorrectVolumeChanged,
    required this.onWrongVolumeChanged,
  });

  final AudioSettings settings;
  final Future<void> Function(AudioSettings settings, {bool previewSpeech})
  onSettingsChanged;
  final ValueChanged<double> onCorrectVolumeChanged;
  final ValueChanged<double> onWrongVolumeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AudioSettingCard(
          title: 'Speech Speed',
          value: settings.speechRate.toStringAsFixed(2),
          child: Slider(
            value: settings.speechRate,
            min: 0.2,
            max: 0.8,
            divisions: 12,
            onChanged: (value) {
              onSettingsChanged(
                settings.copyWith(speechRate: value),
                previewSpeech: true,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        AudioSettingCard(
          title: 'Volume',
          child: Column(
            children: [
              _slider(
                'Speech',
                settings.speechVolume,
                (value) => onSettingsChanged(
                  settings.copyWith(speechVolume: value),
                  previewSpeech: true,
                ),
              ),
              _slider(
                'Correct Sound',
                settings.correctVolume,
                onCorrectVolumeChanged,
              ),
              _slider(
                'Wrong Sound',
                settings.wrongVolume,
                onWrongVolumeChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _slider(String title, double value, ValueChanged<double> onChanged) {
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
