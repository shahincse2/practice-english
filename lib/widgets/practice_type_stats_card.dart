import 'package:flutter/material.dart';

import '../models/practice_stats.dart';
import '../models/practice_type.dart';

/// Accuracy and attempt breakdown for one [PracticeType].
class PracticeTypeStatsCard extends StatelessWidget {
  const PracticeTypeStatsCard({
    super.key,
    required this.title,
    required this.type,
    required this.stats,
  });

  final String title;
  final PracticeType type;
  final PracticeTypeStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(_icon(type), color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${stats.accuracy.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: stats.accuracy / 100,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _detail('Attempts', stats.attempts),
                _detail('Correct', stats.correct),
                _detail('Wrong', stats.wrong),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detail(String title, int value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 3),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  IconData _icon(PracticeType type) {
    switch (type) {
      case PracticeType.word:
        return Icons.text_fields_rounded;
      case PracticeType.phrase:
        return Icons.short_text_rounded;
      case PracticeType.sentence:
        return Icons.notes_rounded;
    }
  }
}
