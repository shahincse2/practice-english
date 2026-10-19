import 'package:flutter/material.dart';

import '../core/services/answer_sound_service.dart';
import '../core/services/practice_history_service.dart';
import '../core/services/practice_stats_service.dart';
import '../core/services/text_to_speech_service.dart';
import '../core/sessions/session_recorder.dart';
import '../data/repositories/practice_repository.dart';
import '../models/practice_question.dart';
import '../models/practice_type.dart';
import 'practice_input_group.dart';

class PracticeController {
  PracticeController(this.repository);

  final PracticeRepository repository;
  final tts = TextToSpeechService();
  final answerSound = AnswerSoundService();
  final stats = PracticeStatsService.instance;
  final history = PracticeHistoryService.instance;
  final inputs = PracticeInputGroup();
  final recorder = SessionRecorder();

  List<PracticeQuestion> questions = [];
  int index = 0;
  int wrongAttempts = 0;
  bool checked = false;
  bool correct = false;
  bool answerRevealed = false;

  List<TextEditingController> get controllers => inputs.controllers;
  List<FocusNode> get focusNodes => inputs.focusNodes;

  bool get hasQuestions => questions.isNotEmpty;
  bool get canShowAnswer => wrongAttempts >= 3 && !correct;

  /// Number of steps in the current lesson (0 when not in a lesson).
  int get lessonTotal {
    final id = question.lessonId;
    if (id == null) return 0;

    return questions.where((item) => item.lessonId == id).length;
  }

  PracticeQuestion get question => questions[index];

  Future<void> initialize({
    String? segment,
    String? level,
  }) async {
    questions = await repository.getQuestions(
      segment: segment,
      level: level,
    );

    await stats.initialize();
    await history.initialize();

    if (!hasQuestions) return;

    recorder.begin(segment: segment, level: level);
    inputs.rebuild(question.words.length);
    await answerSound.initialize();
    await tts.initialize();
    await tts.speak(question.answer);
  }

  void focusFirstInput() => inputs.focusFirst();

  void releaseRetiredInputs() => inputs.disposeRetired();

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

  bool allInputsFilled() => inputs.allFilled(question.words);

  bool isCorrectAnswer() => inputs.matches(question.words);

  String get currentInput => inputs.text;

  Future<void> checkAnswer() async {
    if (correct || answerRevealed) return;

    final value = isCorrectAnswer();
    recorder.attempt(
      question,
      correct: value,
      typedChars: currentInput.length,
    );

    if (value) {
      await answerSound.playCorrect();
    } else {
      await answerSound.playWrong();
      wrongAttempts++;
    }

    await stats.recordAttempt(question.type, value);
    await history.recordAttempt(
      question,
      currentInput,
      value,
    );

    checked = true;
    correct = value;
  }

  Future<void> revealAnswer() async {
    if (!canShowAnswer) return;

    answerRevealed = true;
    recorder.reveal(question);
    await history.markAnswerRevealed(question);
  }

  Future<void> nextQuestion() async {
    await tts.stop();

    if (index >= questions.length - 1) return;

    index++;
    wrongAttempts = 0;
    checked = false;
    correct = false;
    answerRevealed = false;
    recorder.nextQuestion();

    inputs.rebuild(question.words.length);
    await tts.speak(question.answer);
  }

  Future<void> replay() => tts.speak(question.answer);

  void dispose() {
    tts.dispose();
    answerSound.dispose();
    inputs.dispose();
  }
}
