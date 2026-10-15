import 'package:flutter/material.dart';

import '../models/practice_stats.dart';

/// "Overall Progress" card: attempts, correct answers and accuracy.
class DashboardSummaryCard extends StatelessWidget {
  const DashboardSummaryCard({super.key, required this.stats});

  final PracticeStats stats;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overall Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _summaryItem('Attempts', stats.totalAttempts.toString()),
                _summaryItem('Correct', stats.correctAnswers.toString()),
                _summaryItem(
                  'Accuracy',
                  '${stats.accuracy.toStringAsFixed(1)}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
