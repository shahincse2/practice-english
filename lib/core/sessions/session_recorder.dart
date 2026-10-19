import 'dart:math';

import '../../models/practice_question.dart';
import '../../models/session_submission.dart';

class _Progress {
  _Progress(this.question);

  final PracticeQuestion question;
  int attempts = 0;
  int typedChars = 0;
  int timeMs = 0;
  bool correct = false;
  bool revealed = false;
}

/// Collects what happened in one practice session so it can be uploaded.
class SessionRecorder {
  final _progress = <String, _Progress>{};

  String? _segment;
  String? _level;
  DateTime? _startedAt;
  DateTime _questionStartedAt = DateTime.now();

  String? get segment => _segment;
  String? get level => _level;

  void begin({required String? segment, required String? level}) {
    _segment = segment;
    _level = level;
    _startedAt = DateTime.now();
    _questionStartedAt = _startedAt!;
    _progress.clear();
  }

  /// Call when the next question appears, so each one is timed on its own.
  void nextQuestion() => _questionStartedAt = DateTime.now();

  void attempt(
    PracticeQuestion question, {
    required bool correct,
    required int typedChars,
  }) {
    final progress = _of(question);
    progress.attempts++;
    progress.typedChars = typedChars;

    if (correct) {
      progress.correct = true;
      progress.timeMs = _elapsedMs();
    }
  }

  void reveal(PracticeQuestion question) {
    final progress = _of(question);
    progress.revealed = true;
    progress.timeMs = _elapsedMs();
  }

  /// The finished session, or null when there is nothing to upload.
  SessionSubmission? finish() {
    final segment = _segment;
    final level = _level;
    final startedAt = _startedAt;
    if (segment == null || level == null || startedAt == null) return null;
    if (_progress.isEmpty) return null;

    final lessonIds = {for (final p in _progress.values) p.question.lessonId};

    return SessionSubmission(
      clientSessionId: _newId(),
      segment: segment,
      level: level,
      lessonId: lessonIds.length == 1 ? lessonIds.first : null,
      startedAt: startedAt,
      finishedAt: DateTime.now(),
      items: [
        for (final p in _progress.values)
          SessionItem(
            questionId: p.question.id,
            type: p.question.type.name,
            attempts: p.attempts,
            correct: p.correct,
            revealed: p.revealed,
            timeMs: p.timeMs,
            typedChars: p.typedChars,
          ),
      ],
    );
  }

  _Progress _of(PracticeQuestion question) {
    return _progress.putIfAbsent(question.id, () => _Progress(question));
  }

  int _elapsedMs() {
    return DateTime.now().difference(_questionStartedAt).inMilliseconds;
  }

  /// A random version-4 UUID.
  static String _newId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    final hex = [for (final b in bytes) b.toRadixString(16).padLeft(2, '0')];
    final id = hex.join();
    return '${id.substring(0, 8)}-${id.substring(8, 12)}-'
        '${id.substring(12, 16)}-${id.substring(16, 20)}-${id.substring(20)}';
  }
}
