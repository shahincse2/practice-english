import 'package:flutter/material.dart';

import '../models/practice_history_item.dart';
import '../models/practice_type.dart';
import 'practice_history_dialog.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key, required this.items});

  final List<PracticeHistoryItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: Text('No practice activity yet')),
        ),
      );
    }

    return Card(
      child: Column(
        children: items
            .take(5)
            .map(
              (item) => ListTile(
                onTap: () => _showDetails(context, item),
                leading: const CircleAvatar(child: Icon(Icons.history_rounded)),
                title: Text(item.answer),
                subtitle: Text(
                  '${_typeName(item.type)} • ${item.level}\n'
                  '${item.attempts.length} attempts • '
                  '${item.wrongCount} Wrong • '
                  '${item.correctCount} Correct',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            )
            .toList(),
      ),
    );
  }

  void _showDetails(BuildContext context, PracticeHistoryItem item) {
    showDialog<void>(
      context: context,
      builder: (_) => PracticeHistoryDialog(item: item),
    );
  }

  String _typeName(PracticeType type) {
    switch (type) {
      case PracticeType.word:
        return 'Word';
      case PracticeType.phrase:
        return 'Phrase';
      case PracticeType.sentence:
        return 'Sentence';
    }
  }
}
