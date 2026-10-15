import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/practice_question.dart';
import '../lesson_parser.dart';
import 'practice_data_source.dart';

/// Reads guided lessons (word -> phrase -> sentence steps) from assets.
class LessonPracticeDataSource implements PracticeDataSource {
  const LessonPracticeDataSource({this.parser = const LessonParser()});

  static const _lessonsPath = 'assets/data/practice_lessons.json';

  final LessonParser parser;

  @override
  Future<List<PracticeQuestion>> getQuestions({
    String? segment,
    String? level,
  }) async {
    final raw = await rootBundle.loadString(_lessonsPath);
    final questions = parser.parse(jsonDecode(raw) as Map<String, dynamic>);

    return questions.where((question) {
      final matchesSegment =
          segment == null || question.segment.name == segment;
      final matchesLevel = level == null || question.level.name == level;
      return matchesSegment && matchesLevel;
    }).toList();
  }
}
