import 'package:flutter/material.dart';

import '../controllers/practice_controller.dart';
import 'audio_button.dart';
import 'lesson_progress.dart';
import 'practice_actions.dart';
import 'practice_header.dart';
import 'practice_inputs.dart';
import 'practice_translation_card.dart';

/// Body of the practice screen: header, audio, translation, inputs, actions.
///
/// Purely presentational: every action is reported back through callbacks.
class PracticeQuestionView extends StatelessWidget {
  const PracticeQuestionView({
    super.key,
    required this.controller,
    required this.onCheck,
    required this.onShowAnswer,
    required this.onContinue,
    required this.onSpacePressed,
  });

  final PracticeController controller;
  final VoidCallback onCheck;
  final VoidCallback onShowAnswer;
  final VoidCallback onContinue;
  final ValueChanged<int> onSpacePressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          children: [
            PracticeHeader(
              type: controller.typeTitle(),
              current: controller.index + 1,
              total: controller.questions.length,
            ),
            if (controller.question.lessonId != null) ...[
              const SizedBox(height: 12),
              LessonProgress(
                step: controller.question.step ?? 1,
                total: controller.lessonTotal,
              ),
            ],
            const SizedBox(height: 28),
            AudioButton(onPressed: controller.replay),
            const SizedBox(height: 16),
            PracticeTranslationCard(question: controller.question),
            const SizedBox(height: 24),
            PracticeInputs(
              question: controller.question,
              controllers: controller.controllers,
              focusNodes: controller.focusNodes,
              enabled: !controller.correct && !controller.answerRevealed,
              isChecked: controller.checked,
              onChanged: (_, _) {},
              onSubmitted: (_, _) => onCheck(),
              onSpacePressed: onSpacePressed,
            ),
            const SizedBox(height: 36),
            PracticeActions(
              answer: controller.question.answer,
              checked: controller.checked,
              correct: controller.correct,
              answerRevealed: controller.answerRevealed,
              canShowAnswer: controller.canShowAnswer,
              onCheck: onCheck,
              onShowAnswer: onShowAnswer,
              onContinue: onContinue,
            ),
          ],
        ),
      ),
    );
  }
}
