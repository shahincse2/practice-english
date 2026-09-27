import 'package:flutter/material.dart';

import '../core/services/answer_sound_service.dart';
import '../core/services/text_to_speech_service.dart';
import '../data/repositories/practice_repository.dart';
import '../models/practice_question.dart';
import '../models/practice_type.dart';

class PracticeController {
  PracticeController(this.repository);

  final PracticeRepository repository;
  final TextToSpeechService tts = TextToSpeechService();
  final AnswerSoundService answerSound = AnswerSoundService();

  List<PracticeQuestion> questions = [];
  int index = 0;
  bool checked = false;
  bool correct = false;

  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];

  bool get hasQuestions => questions.isNotEmpty;

  PracticeQuestion get question => questions[index];

  Future<void> initialize({String? segment, String? level}) async {
    questions = await repository.getQuestions(segment: segment, level: level);

    if (!hasQuestions) return;

    _createInputs();
    await answerSound.initialize();
    await tts.initialize();
    await tts.speak(question.answer);
  }

  void _createInputs() {
    _disposeInputs();

    controllers = List.generate(
      question.words.length,
      (_) => TextEditingController(),
    );

    focusNodes = List.generate(question.words.length, (_) => FocusNode());
  }

  void focusFirstInput() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNodes.isEmpty) return;
      focusNodes.first.requestFocus();
    });
  }

  String typeTitle() {
    switch (question.type) {
      case PracticeType.word:
        return 'WORD';
      case PracticeType.phrase:
        return 'PHRASE';
      case PracticeType.sentence:
        return 'SENTENCE';
    }
  }

  bool allInputsFilled() {
    for (var i = 0; i < question.words.length; i++) {
      if (controllers[i].text.length != question.words[i].length) {
        return false;
      }
    }
    return true;
  }

  bool isCorrectAnswer() {
    for (var i = 0; i < question.words.length; i++) {
      final expected = question.words[i].toLowerCase();
      final actual = controllers[i].text.trim().toLowerCase();

      if (expected != actual) return false;
    }
    return true;
  }

  Future<void> checkAnswer() async {
    final value = isCorrectAnswer();

    if (value) {
      await answerSound.playCorrect();
    } else {
      await answerSound.playWrong();
    }

    checked = true;
    correct = value;
  }

  Future<void> nextQuestion() async {
    await tts.stop();

    if (index >= questions.length - 1) return;

    index++;
    checked = false;
    correct = false;
    _createInputs();

    await tts.speak(question.answer);
  }

  Future<void> replay() {
    return tts.speak(question.answer);
  }

  void dispose() {
    tts.dispose();
    answerSound.dispose();
    _disposeInputs();
  }

  void _disposeInputs() {
    for (final controller in controllers) {
      controller.dispose();
    }

    for (final node in focusNodes) {
      node.dispose();
    }

    controllers = [];
    focusNodes = [];
  }
}
