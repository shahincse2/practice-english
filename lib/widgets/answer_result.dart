import 'package:flutter/material.dart';

class AnswerResult extends StatelessWidget {
  const AnswerResult({super.key, required this.correct});

  final bool correct;

  @override
  Widget build(BuildContext context) {
    final color = correct ? Colors.green : Colors.red;
    final icon = correct ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final text = correct ? 'Correct!' : 'Try again';

    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
