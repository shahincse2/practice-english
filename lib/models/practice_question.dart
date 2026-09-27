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
  });

  factory PracticeQuestion.fromJson(Map<String, dynamic> json) {
    return PracticeQuestion(
      id: json['id'] as String,
      segment: PracticeSegment.values.byName(json['segment'] as String),
      level: PracticeLevel.values.byName(json['level'] as String),
      type: PracticeType.values.byName(json['type'] as String),
      answer: json['answer'] as String,
    );
  }

  final String id;
  final PracticeSegment segment;
  final PracticeLevel level;
  final PracticeType type;
  final String answer;

  List<String> get words {
    return answer.trim().split(RegExp(r'\s+'));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'segment': segment.name,
      'level': level.name,
      'type': type.name,
      'answer': answer,
    };
  }
}
