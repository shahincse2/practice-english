
import 'package:flutter/material.dart';

import '../models/practice_stats.dart';

class ProfileLearningOverview extends StatelessWidget {
  const ProfileLearningOverview({
    super.key,
    required this.stats,
    required this.completedSessions,
  });

  final PracticeStats stats;
  final int completedSessions;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row(
              context,
              'Practice Completed',
              completedSessions.toString(),
            ),
            _row(context, 'Total Attempts', '${stats.totalAttempts}'),
            _row(context, 'Correct Answers', '${stats.correctAnswers}'),
            _row(context, 'Wrong Answers', '${stats.wrongAnswers}'),
            _row(
              context,
              'Accuracy',
              '${stats.accuracy.toStringAsFixed(2)}%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Text(
        value,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
