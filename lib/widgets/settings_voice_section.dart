import 'package:flutter/material.dart';

import 'voice_carousel.dart';

/// "Voice" block of the settings screen: title, voice carousel and
/// the "Use this voice" button (or an empty message).
class SettingsVoiceSection extends StatelessWidget {
  const SettingsVoiceSection({
    super.key,
    required this.voices,
    required this.selectedName,
    required this.onPageChanged,
    required this.onPreview,
    required this.onUseVoice,
  });

  final List<Map<String, String>> voices;
  final String? selectedName;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<Map<String, String>> onPreview;
  final VoidCallback onUseVoice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(
          child: Text(
            'Voice',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 12),
        if (voices.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('No English voices found')),
          )
        else ...[
          VoiceCarousel(
            voices: voices,
            selectedName: selectedName,
            onPageChanged: onPageChanged,
            onPreview: onPreview,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: onUseVoice,
              child: const Text('Use this voice'),
            ),
          ),
        ],
      ],
    );
  }
}

/// Index of the voice named [name] in [voices], or 0 when it is not found.
int selectedVoiceIndex(List<Map<String, String>> voices, String? name) {
  final index = voices.indexWhere((voice) => voice['name'] == name);
  return index >= 0 ? index : 0;
}
