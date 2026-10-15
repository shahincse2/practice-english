

class PracticeHistoryAttempt {
  const PracticeHistoryAttempt({
    required this.input,
    required this.correct,
    required this.timestamp,
  });

  final String input;
  final bool correct;
  final DateTime timestamp;

  Map<String, dynamic> toJson() {
    return {
      'input': input,
      'correct': correct,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PracticeHistoryAttempt.fromJson(
      Map<String, dynamic> json,
      ) {
    return PracticeHistoryAttempt(
      input: json['input'] as String? ?? '',
      correct: json['correct'] as bool? ?? false,
      timestamp: DateTime.parse(
        json['timestamp'] as String,
      ),
    );
  }
}