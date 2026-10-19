/// One question's result inside a finished session.
class SessionItem {
  const SessionItem({
    required this.questionId,
    required this.type,
    required this.attempts,
    required this.correct,
    required this.revealed,
    required this.timeMs,
    required this.typedChars,
  });

  factory SessionItem.fromJson(Map<String, dynamic> json) {
    return SessionItem(
      questionId: json['questionId'] as String,
      type: json['type'] as String,
      attempts: json['attempts'] as int,
      correct: json['correct'] as bool,
      revealed: json['revealed'] as bool,
      timeMs: json['timeMs'] as int,
      typedChars: json['typedChars'] as int,
    );
  }

  final String questionId;
  final String type;
  final int attempts;
  final bool correct;
  final bool revealed;
  final int timeMs;
  final int typedChars;

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'type': type,
        'attempts': attempts,
        'correct': correct,
        'revealed': revealed,
        'timeMs': timeMs,
        'typedChars': typedChars,
      };
}

/// A finished practice session, ready to upload
/// (see `SessionSubmission` in openapi.yaml).
class SessionSubmission {
  const SessionSubmission({
    required this.clientSessionId,
    required this.segment,
    required this.level,
    required this.startedAt,
    required this.finishedAt,
    required this.items,
    this.lessonId,
  });

  factory SessionSubmission.fromJson(Map<String, dynamic> json) {
    return SessionSubmission(
      clientSessionId: json['clientSessionId'] as String,
      segment: json['segment'] as String,
      level: json['level'] as String,
      lessonId: json['lessonId'] as String?,
      startedAt: DateTime.parse(json['startedAt'] as String),
      finishedAt: DateTime.parse(json['finishedAt'] as String),
      items: [
        for (final item in json['items'] as List<dynamic>)
          SessionItem.fromJson(item as Map<String, dynamic>),
      ],
    );
  }

  /// Made by the app, so the server can recognise a re-sent session.
  final String clientSessionId;
  final String segment;
  final String level;
  final String? lessonId;
  final DateTime startedAt;
  final DateTime finishedAt;
  final List<SessionItem> items;

  Map<String, dynamic> toJson() => {
        'clientSessionId': clientSessionId,
        'segment': segment,
        'level': level,
        if (lessonId != null) 'lessonId': lessonId,
        'startedAt': startedAt.toUtc().toIso8601String(),
        'finishedAt': finishedAt.toUtc().toIso8601String(),
        'items': [for (final item in items) item.toJson()],
      };
}
