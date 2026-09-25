import 'package:flutter/material.dart';

import '../models/practice_question.dart';
import 'word_input.dart';

class PracticeInputs extends StatelessWidget {
  const PracticeInputs({
    super.key,
    required this.question,
    required this.controllers,
    required this.focusNodes,
    required this.enabled,
    required this.isChecked,
    required this.onChanged,
    required this.onSubmitted,
    required this.onSpacePressed,
  });

  final PracticeQuestion question;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final bool enabled;
  final bool isChecked;
  final void Function(int index, String value) onChanged;
  final void Function(int index, String value) onSubmitted;
  final void Function(int index) onSpacePressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 14,
      runSpacing: 18,
      children: List.generate(
        question.words.length,
        (index) => WordInput(
          controller: controllers[index],
          focusNode: focusNodes[index],
          target: question.words[index],
          enabled: enabled,
          isChecked: isChecked,
          onChanged: (value) => onChanged(index, value),
          onSubmitted: (value) => onSubmitted(index, value),
          onSpacePressed: () => onSpacePressed(index),
        ),
      ),
    );
  }
}
