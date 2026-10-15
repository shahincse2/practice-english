import 'package:flutter/material.dart';

import '../core/services/translation_settings_service.dart';
import '../models/practice_question.dart';
import '../models/translation_settings.dart';

class PracticeTranslationCard extends StatefulWidget {
  const PracticeTranslationCard({super.key, required this.question});

  final PracticeQuestion question;

  @override
  State<PracticeTranslationCard> createState() =>
      _PracticeTranslationCardState();
}

class _PracticeTranslationCardState extends State<PracticeTranslationCard> {
  final _service = TranslationSettingsService();
  late Future<TranslationSettings> _settings;

  @override
  void initState() {
    super.initState();
    _settings = _service.load();
  }

  @override
  void didUpdateWidget(covariant PracticeTranslationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      _settings = _service.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TranslationSettings>(
      future: _settings,
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.showDuringPractice) {
          return const SizedBox.shrink();
        }

        final language = snapshot.data!.languageCode;
        final translation = widget.question.translations[language];
        final theme = Theme.of(context);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.translate_rounded,
                        color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      language == 'bn' ? 'বাংলা অর্থ' : 'Translation',
                      style: theme.textTheme.titleSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  translation?.trim().isNotEmpty == true
                      ? translation!
                      : 'এই ভাষায় অনুবাদ এখনো পাওয়া যায়নি।',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
