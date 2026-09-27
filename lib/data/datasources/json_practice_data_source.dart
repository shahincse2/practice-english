import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/practice_question.dart';
import 'practice_data_source.dart';

class JsonPracticeDataSource implements PracticeDataSource {
  const JsonPracticeDataSource();

  static const _assetPath = 'assets/data/practice_questions.json';

  @override
  Future<List<PracticeQuestion>> getQuestions({
    String? segment,
    String? level,
  }) async {
    final jsonString = await rootBundle.loadString(_assetPath);
    final jsonList = jsonDecode(jsonString) as List<dynamic>;

    final questions = jsonList
        .map((item) => PracticeQuestion.fromJson(item as Map<String, dynamic>))
        .toList();

    return questions.where((question) {
      final matchesSegment =
          segment == null || question.segment.name == segment;
      final matchesLevel = level == null || question.level.name == level;

      return matchesSegment && matchesLevel;
    }).toList();
  }
}
