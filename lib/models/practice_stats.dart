import 'practice_type.dart';

class PracticeTypeStats {
  const PracticeTypeStats({
    this.attempts = 0,
    this.correct = 0,
    this.wrong = 0,
  });

  final int attempts;
  final int correct;
  final int wrong;

  double get accuracy {
    if (attempts == 0) return 0;
    return correct / attempts * 100;
  }

  PracticeTypeStats copyWith({int? attempts, int? correct, int? wrong}) {
    return PracticeTypeStats(
      attempts: attempts ?? this.attempts,
      correct: correct ?? this.correct,
      wrong: wrong ?? this.wrong,
    );
  }
}

class PracticeStats {
  const PracticeStats({
    this.totalAttempts = 0,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.word = const PracticeTypeStats(),
    this.phrase = const PracticeTypeStats(),
    this.sentence = const PracticeTypeStats(),
  });

  final int totalAttempts;
  final int correctAnswers;
  final int wrongAnswers;

  final PracticeTypeStats word;
  final PracticeTypeStats phrase;
  final PracticeTypeStats sentence;

  double get accuracy {
    if (totalAttempts == 0) return 0;
    return correctAnswers / totalAttempts * 100;
  }

  PracticeTypeStats forType(PracticeType type) {
    switch (type) {
      case PracticeType.word:
        return word;
      case PracticeType.phrase:
        return phrase;
      case PracticeType.sentence:
        return sentence;
    }
  }

  PracticeStats copyWith({
    int? totalAttempts,
    int? correctAnswers,
    int? wrongAnswers,
    PracticeTypeStats? word,
    PracticeTypeStats? phrase,
    PracticeTypeStats? sentence,
  }) {
    return PracticeStats(
      totalAttempts: totalAttempts ?? this.totalAttempts,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      word: word ?? this.word,
      phrase: phrase ?? this.phrase,
      sentence: sentence ?? this.sentence,
    );
  }
}
