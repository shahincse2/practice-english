import 'practice_type.dart';

class PracticeQuestion {
  const PracticeQuestion({required this.type, required this.answer});

  final PracticeType type;
  final String answer;

  List<String> get words => answer.trim().split(RegExp(r'\s+'));
}
