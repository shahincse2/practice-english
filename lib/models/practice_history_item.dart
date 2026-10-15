import 'practice_history_attempt.dart';
import 'practice_type.dart';

class PracticeHistoryItem {
  const PracticeHistoryItem({
    required this.questionId,
    required this.type,
    required this.answer,
    required this.segment,
    required this.level,
    required this.attempts,
    required this.answerRevealed,
    required this.lastAttemptAt,
  });

  final String questionId;
  final PracticeType type;
  final String answer;
  final String segment;
  final String level;
  final List<PracticeHistoryAttempt> attempts;
  final bool answerRevealed;
  final DateTime lastAttemptAt;

  int get correctCount =>
      attempts.where((item) => item.correct).length;

  int get wrongCount =>
      attempts.where((item) => !item.correct).length;

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'type': type.name,
      'answer': answer,
      'segment': segment,
      'level': level,
      'attempts': attempts.map((item) => item.toJson()).toList(),
      'answerRevealed': answerRevealed,
      'lastAttemptAt': lastAttemptAt.toIso8601String(),
    };
  }

  factory PracticeHistoryItem.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawAttempts = json['attempts'];

    return PracticeHistoryItem(
      questionId: json['questionId'] as String,
      type: PracticeType.values.byName(
        json['type'] as String,
      ),
      answer: json['answer'] as String,
      segment: json['segment'] as String,
      level: json['level'] as String,
      attempts: rawAttempts is List
          ? rawAttempts
          .whereType<Map>()
          .map(
            (item) => PracticeHistoryAttempt.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList()
          : [],
      answerRevealed:
      json['answerRevealed'] as bool? ?? false,
      lastAttemptAt: DateTime.parse(
        json['lastAttemptAt'] as String,
      ),
    );
  }
}