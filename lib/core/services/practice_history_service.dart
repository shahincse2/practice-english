import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/practice_history_attempt.dart';
import '../../models/practice_history_item.dart';
import '../../models/practice_question.dart';

class PracticeHistoryService {
  PracticeHistoryService._();

  static final instance = PracticeHistoryService._();

  static const _key = 'practice_history';
  static const _maxItems = 20;

  final ValueNotifier<List<PracticeHistoryItem>> history =
  ValueNotifier([]);

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);

    if (value != null) {
      try {
        final decoded = jsonDecode(value);

        if (decoded is List) {
          history.value = decoded
              .whereType<Map>()
              .map(
                (item) => PracticeHistoryItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
              .toList();
        }
      } catch (_) {
        history.value = [];
      }
    }

    _initialized = true;
  }

  Future<void> recordAttempt(
      PracticeQuestion question,
      String input,
      bool correct,
      ) async {
    await initialize();

    final id = _questionId(question);
    final items = [...history.value];
    final index = items.indexWhere(
          (item) => item.questionId == id,
    );
    final attempt = PracticeHistoryAttempt(
      input: input,
      correct: correct,
      timestamp: DateTime.now(),
    );

    if (index < 0) {
      items.insert(
        0,
        PracticeHistoryItem(
          questionId: id,
          type: question.type,
          answer: question.answer,
          segment: question.segment.name,
          level: question.level.name,
          attempts: [attempt],
          answerRevealed: false,
          lastAttemptAt: attempt.timestamp,
        ),
      );
    } else {
      final item = items[index];
      items[index] = PracticeHistoryItem(
        questionId: item.questionId,
        type: item.type,
        answer: item.answer,
        segment: item.segment,
        level: item.level,
        attempts: [...item.attempts, attempt],
        answerRevealed: item.answerRevealed,
        lastAttemptAt: attempt.timestamp,
      );
    }

    items.sort(
          (a, b) => b.lastAttemptAt.compareTo(a.lastAttemptAt),
    );

    history.value = items.take(_maxItems).toList();
    await _save();
  }

  Future<void> markAnswerRevealed(
      PracticeQuestion question,
      ) async {
    await initialize();

    final id = _questionId(question);
    final items = [...history.value];
    final index = items.indexWhere(
          (item) => item.questionId == id,
    );

    if (index < 0) return;

    final item = items[index];

    items[index] = PracticeHistoryItem(
      questionId: item.questionId,
      type: item.type,
      answer: item.answer,
      segment: item.segment,
      level: item.level,
      attempts: item.attempts,
      answerRevealed: true,
      lastAttemptAt: item.lastAttemptAt,
    );

    history.value = items;
    await _save();
  }

  String _questionId(PracticeQuestion question) {
    return '${question.segment.name}:'
        '${question.level.name}:${question.id}';
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _key,
      jsonEncode(
        history.value.map((item) => item.toJson()).toList(),
      ),
    );
  }
}