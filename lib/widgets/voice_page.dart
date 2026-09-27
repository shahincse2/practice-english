import 'package:flutter/material.dart';

class VoicePage extends StatelessWidget {
  const VoicePage({super.key, required this.voice, required this.selected});

  final Map<String, String> voice;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 68,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.record_voice_over_rounded,
            size: 54,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _friendlyName(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Text(
          _description(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: theme.colorScheme.secondary),
        ),
        const SizedBox(height: 8),
        if (selected)
          Icon(
            Icons.check_circle_rounded,
            color: theme.colorScheme.primary,
            size: 22,
          ),
      ],
    );
  }

  String _friendlyName() {
    final name = voice['name'] ?? '';
    final locale = voice['locale'] ?? '';

    if (name == 'en-US-default') return 'English (US)';
    if (name == 'en-IN-default') return 'English (India)';
    if (name == 'en-US-SMTf00') return 'English (US) Enhanced';
    if (name == 'en-IN-SMTf00') return 'English (India) Enhanced';
    if (locale == 'en-US') return 'English (US)';
    if (locale == 'en-GB') return 'English (UK)';

    return name.isEmpty ? 'English Voice' : name;
  }

  String _description() {
    final name = voice['name'] ?? '';

    if (name.contains('SMTf00')) {
      return 'Enhanced English voice';
    }

    if (name.contains('default')) {
      return 'Standard English voice';
    }

    return voice['locale'] ?? 'English voice';
  }
}
