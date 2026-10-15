import '../models/practice_level.dart';
import '../models/practice_question.dart';
import '../models/practice_segment.dart';
import '../models/practice_type.dart';

/// Flattens lesson JSON into ordered [PracticeQuestion]s, one per step.
///
/// The existing practice flow keeps working unchanged because every
/// step is just a normal question; the file order is the learning order.
class LessonParser {
  const LessonParser();

  List<PracticeQuestion> parse(Map<String, dynamic> json) {
    final lessons = json['lessons'] as List<dynamic>? ?? const [];

    return [
      for (final lesson in lessons)
        ..._parseLesson(lesson as Map<String, dynamic>),
    ];
  }

  List<PracticeQuestion> _parseLesson(Map<String, dynamic> lesson) {
    final lessonId = lesson['lessonId'] as String;
    final segment = PracticeSegment.values.byName(lesson['segment'] as String);
    final level = PracticeLevel.values.byName(lesson['level'] as String);
    final steps = lesson['steps'] as List<dynamic>;

    return [
      for (var i = 0; i < steps.length; i++)
        _parseStep(
          steps[i] as Map<String, dynamic>,
          lessonId: lessonId,
          segment: segment,
          level: level,
          number: i + 1,
        ),
    ];
  }

  PracticeQuestion _parseStep(
    Map<String, dynamic> step, {
    required String lessonId,
    required PracticeSegment segment,
    required PracticeLevel level,
    required int number,
  }) {
    final translations = step['translations'] as Map<String, dynamic>? ?? {};

    return PracticeQuestion(
      id: '${lessonId}_s${number.toString().padLeft(2, '0')}',
      segment: segment,
      level: level,
      type: PracticeType.values.byName(step['type'] as String),
      answer: (step['answer'] as String).trim(),
      translations: translations.map(
        (key, value) => MapEntry(key, value.toString().trim()),
      ),
      lessonId: lessonId,
      step: number,
      image: step['image'] as String?,
    );
  }
}
