import 'package:flutter/material.dart';

import '../models/practice_history_item.dart';

class PracticeHistoryDialog extends StatelessWidget {
  const PracticeHistoryDialog({super.key, required this.item});

  final PracticeHistoryItem item;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Practice Details'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Correct Answer',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(item.answer, style: const TextStyle(fontSize: 17)),
              const SizedBox(height: 16),
              Text(
                '${item.attempts.length} Attempts • '
                '${item.correctCount} Correct • '
                '${item.wrongCount} Wrong',
              ),
              if (item.answerRevealed)
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text('Answer Revealed'),
                ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 8),
              ...List.generate(
                item.attempts.length,
                (index) => _attempt(
                  context,
                  index + 1,
                  item.answer,
                  item.attempts[index].input,
                  item.attempts[index].correct,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _attempt(
    BuildContext context,
    int number,
    String answer,
    String input,
    bool correct,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attempt $number',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          _coloredAnswer(context, answer, input),
          const SizedBox(height: 4),
          Text(
            correct ? 'Correct' : 'Wrong',
            style: TextStyle(
              color: correct
                  ? Colors.green
                  : Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _coloredAnswer(BuildContext context, String answer, String input) {
    final theme = Theme.of(context);
    final expected = answer.trim().split(RegExp(r'\s+'));
    final actual = input.trim().split(RegExp(r'\s+'));
    final spans = <TextSpan>[];

    for (var i = 0; i < actual.length; i++) {
      final word = actual[i];
      final isWrong =
          i >= expected.length ||
          word.toLowerCase() != expected[i].toLowerCase();

      spans.add(
        TextSpan(
          text: word,
          style: TextStyle(
            color: isWrong
                ? theme.colorScheme.error
                : theme.colorScheme.onSurface,
            fontWeight: isWrong ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      );

      if (i < actual.length - 1) {
        spans.add(const TextSpan(text: ' '));
      }
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface),
        children: spans,
      ),
    );
  }
}
