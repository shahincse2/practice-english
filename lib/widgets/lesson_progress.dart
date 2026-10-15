import 'package:flutter/material.dart';

/// "Step 3 of 15" bar shown for questions that belong to a guided lesson.
class LessonProgress extends StatelessWidget {
  const LessonProgress({super.key, required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step $step of $total', style: theme.textTheme.labelMedium),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: total == 0 ? 0 : step / total,
          minHeight: 6,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }
}
