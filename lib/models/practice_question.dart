import 'practice_level.dart';
import 'practice_segment.dart';
import 'practice_type.dart';

class PracticeQuestion {
  const PracticeQuestion({
    required this.id,
    required this.segment,
    required this.level,
    required this.type,
    required this.answer,
    this.translations = const {},
    this.lessonId,
    this.step,
    this.image,
  });

  factory PracticeQuestion.fromJson(Map<String, dynamic> json) {
    final rawTranslations =
        json['translations'] as Map<String, dynamic>? ?? {};
    return PracticeQuestion(
      id: json['id'] as String,
      segment: PracticeSegment.values.byName(json['segment'] as String),
      level: PracticeLevel.values.byName(json['level'] as String),
      type: PracticeType.values.byName(json['type'] as String),
      answer: json['answer'] as String,
      translations: rawTranslations.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      lessonId: json['lessonId'] as String?,
      step: json['step'] as int?,
      image: json['image'] as String?,
    );
  }

  final String id;
  final PracticeSegment segment;
  final PracticeLevel level;
  final PracticeType type;
  final String answer;
  final Map<String, String> translations;

  /// Set only for steps that belong to a guided lesson.
  final String? lessonId;
  final int? step;
  final String? image;

  List<String> get words => answer.trim().split(RegExp(r'\s+'));

  Map<String, dynamic> toJson() => {
        'id': id,
        'segment': segment.name,
        'level': level.name,
        'type': type.name,
        'answer': answer,
        'translations': translations,
        if (lessonId != null) 'lessonId': lessonId,
        if (step != null) 'step': step,
        if (image != null) 'image': image,
      };
}
