import 'package:flutter/material.dart';

import 'answer_result.dart';

/// Buttons and result area shown under the typing inputs.
class PracticeActions extends StatelessWidget {
  const PracticeActions({
    super.key,
    required this.answer,
    required this.checked,
    required this.correct,
    required this.answerRevealed,
    required this.canShowAnswer,
    required this.onCheck,
    required this.onShowAnswer,
    required this.onContinue,
  });

  final String answer;
  final bool checked;
  final bool correct;
  final bool answerRevealed;
  final bool canShowAnswer;
  final VoidCallback onCheck;
  final VoidCallback onShowAnswer;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    if (answerRevealed) {
      return Column(
        children: [
          _answerCard(),
          const SizedBox(height: 20),
          _continueButton(),
        ],
      );
    }

    return Column(
      children: [
        if (!correct) _checkButton(),
        if (canShowAnswer) ...[
          const SizedBox(height: 12),
          _showAnswerButton(),
        ],
        if (checked) ...[
          const SizedBox(height: 24),
          AnswerResult(correct: correct),
        ],
      ],
    );
  }

  Widget _checkButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: onCheck,
        child: const Text('Check Answer'),
      ),
    );
  }

  Widget _showAnswerButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onShowAnswer,
        icon: const Icon(Icons.lightbulb_rounded),
        label: const Text('Show Answer'),
      ),
    );
  }

  Widget _answerCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Correct Answer',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              answer,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _continueButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(onPressed: onContinue, child: const Text('Continue')),
    );
  }
}
