import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/practice_stats.dart';
import '../../models/practice_type.dart';

class PracticeStatsService {
  PracticeStatsService._();

  static final instance = PracticeStatsService._();

  static const _totalKey = 'stats_total_attempts';
  static const _correctKey = 'stats_correct_answers';
  static const _wrongKey = 'stats_wrong_answers';
  static const _typeKey = 'stats_type_data';

  final ValueNotifier<PracticeStats> stats = ValueNotifier(
    const PracticeStats(),
  );

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    final typeData = _decodeTypeData(prefs.getString(_typeKey));

    stats.value = PracticeStats(
      totalAttempts: prefs.getInt(_totalKey) ?? 0,
      correctAnswers: prefs.getInt(_correctKey) ?? 0,
      wrongAnswers: prefs.getInt(_wrongKey) ?? 0,
      word: _readTypeStats(typeData, PracticeType.word),
      phrase: _readTypeStats(typeData, PracticeType.phrase),
      sentence: _readTypeStats(typeData, PracticeType.sentence),
    );
  }

  Future<void> recordAttempt(PracticeType type, bool correct) async {
    final current = stats.value;
    final currentType = current.forType(type);

    final updatedType = currentType.copyWith(
      attempts: currentType.attempts + 1,
      correct: currentType.correct + (correct ? 1 : 0),
      wrong: currentType.wrong + (correct ? 0 : 1),
    );

    final updated = _updateType(current, type, updatedType).copyWith(
      totalAttempts: current.totalAttempts + 1,
      correctAnswers: current.correctAnswers + (correct ? 1 : 0),
      wrongAnswers: current.wrongAnswers + (correct ? 0 : 1),
    );

    stats.value = updated;

    await _save(updated);
  }

  PracticeStats _updateType(
    PracticeStats stats,
    PracticeType type,
    PracticeTypeStats value,
  ) {
    switch (type) {
      case PracticeType.word:
        return stats.copyWith(word: value);
      case PracticeType.phrase:
        return stats.copyWith(phrase: value);
      case PracticeType.sentence:
        return stats.copyWith(sentence: value);
    }
  }

  Future<void> _save(PracticeStats value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_totalKey, value.totalAttempts);
    await prefs.setInt(_correctKey, value.correctAnswers);
    await prefs.setInt(_wrongKey, value.wrongAnswers);

    final data = {
      'word': _typeMap(value.word),
      'phrase': _typeMap(value.phrase),
      'sentence': _typeMap(value.sentence),
    };

    await prefs.setString(_typeKey, jsonEncode(data));
  }

  Map<String, int> _typeMap(PracticeTypeStats value) {
    return {
      'attempts': value.attempts,
      'correct': value.correct,
      'wrong': value.wrong,
    };
  }

  Map<String, dynamic> _decodeTypeData(String? value) {
    if (value == null || value.isEmpty) return {};

    try {
      final decoded = jsonDecode(value);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}

    return {};
  }

  PracticeTypeStats _readTypeStats(
    Map<String, dynamic> data,
    PracticeType type,
  ) {
    final value = data[type.name];

    if (value is! Map) {
      return const PracticeTypeStats();
    }

    return PracticeTypeStats(
      attempts: value['attempts'] as int? ?? 0,
      correct: value['correct'] as int? ?? 0,
      wrong: value['wrong'] as int? ?? 0,
    );
  }
}
