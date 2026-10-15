import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/practice_question.dart';
import 'practice_data_source.dart';

class JsonPracticeDataSource implements PracticeDataSource {
  const JsonPracticeDataSource();

  static const _questionsPath = 'assets/data/practice_questions.json';
  static const _translationsPath = 'assets/data/practice_translations.json';

  @override
  Future<List<PracticeQuestion>> getQuestions({
    String? segment,
    String? level,
  }) async {
    final questionsJson = await rootBundle.loadString(_questionsPath);
    final rawQuestions = jsonDecode(questionsJson) as List<dynamic>;
    final translationsJson = await rootBundle.loadString(_translationsPath);
    final rawTranslations =
        jsonDecode(translationsJson) as Map<String, dynamic>;

    final questions = rawQuestions.map((item) {
      final question = item as Map<String, dynamic>;
      final translation = rawTranslations[question['id']];
      return PracticeQuestion.fromJson({
        ...question,
        'translations':
            translation is Map<String, dynamic> ? translation : <String, String>{},
      });
    }).toList();

    return questions.where((question) {
      final matchesSegment =
          segment == null || question.segment.name == segment;
      final matchesLevel = level == null || question.level.name == level;
      return matchesSegment && matchesLevel;
    }).toList();
  }
}
