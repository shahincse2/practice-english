import 'package:flutter/material.dart';

class AnswerResult extends StatelessWidget {
  const AnswerResult({super.key, required this.correct});

  final bool correct;

  @override
  Widget build(BuildContext context) {
    if (correct) {
      return const Icon(
        Icons.check_circle_rounded,
        color: Colors.green,
        size: 36,
      );
    }

    return Column(
      children: [
        const Icon(Icons.cancel_rounded, color: Colors.red, size: 32),
        const SizedBox(height: 8),
        Text(
          'Try again',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
