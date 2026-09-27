import 'package:flutter/material.dart';

import '../data/practice_catalog.dart';
import '../models/practice_level.dart';
import '../models/practice_segment.dart';
import '../widgets/practice_selection_card.dart';
import 'practice_screen.dart';

class PracticeLevelScreen extends StatelessWidget {
  const PracticeLevelScreen({
    super.key,
    required this.segment,
    required this.questionCounts,
  });

  final PracticeSegment segment;
  final Map<String, int> questionCounts;

  int _questionCount(PracticeLevel level) {
    return questionCounts['${segment.name}:${level.name}'] ?? 0;
  }

  void _selectLevel(BuildContext context, PracticeLevel level) {
    final count = _questionCount(level);

    if (count == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No questions are available for this level.'),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            PracticeScreen(segment: segment.name, level: level.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final levels = PracticeCatalog.levels[segment] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(PracticeCatalog.segmentName(segment))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Choose a level', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text('Select a level to start your practice.'),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: levels.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.55,
            ),
            itemBuilder: (context, index) {
              final level = levels[index];

              return PracticeSelectionCard(
                title: PracticeCatalog.levelName(level),
                subtitle: '${_questionCount(level)} questions',
                onTap: () => _selectLevel(context, level),
              );
            },
          ),
        ],
      ),
    );
  }
}
