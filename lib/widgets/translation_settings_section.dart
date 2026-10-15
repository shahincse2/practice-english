import 'package:flutter/material.dart';

import '../core/services/translation_settings_service.dart';
import '../models/translation_settings.dart';

class TranslationSettingsSection extends StatefulWidget {
  const TranslationSettingsSection({super.key});

  @override
  State<TranslationSettingsSection> createState() =>
      _TranslationSettingsSectionState();
}

class _TranslationSettingsSectionState
    extends State<TranslationSettingsSection> {
  final _service = TranslationSettingsService();
  TranslationSettings _settings = const TranslationSettings();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = await _service.load();
    if (!mounted) return;
    setState(() {
      _settings = settings;
      _loading = false;
    });
  }

  Future<void> _save(TranslationSettings settings) async {
    setState(() => _settings = settings);
    await _service.save(settings);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: LinearProgressIndicator(),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Translation', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _settings.languageCode,
              decoration: const InputDecoration(
                labelText: 'Translation language',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'bn', child: Text('বাংলা (Available)')),
                DropdownMenuItem(
                  value: 'hi',
                  enabled: false,
                  child: Text('हिन्दी (Coming soon)'),
                ),
                DropdownMenuItem(
                  value: 'ar',
                  enabled: false,
                  child: Text('العربية (Coming soon)'),
                ),
                DropdownMenuItem(
                  value: 'es',
                  enabled: false,
                  child: Text('Español (Coming soon)'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                _save(_settings.copyWith(languageCode: value));
              },
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Show translations during practice'),
              subtitle: const Text(
                'Display the meaning of the current word or sentence.',
              ),
              value: _settings.showDuringPractice,
              onChanged: (value) {
                _save(_settings.copyWith(showDuringPractice: value));
              },
            ),
            const Text(
              'More translation languages can be enabled when their data is added.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
