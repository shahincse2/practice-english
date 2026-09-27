import '../../models/practice_question.dart';

abstract class PracticeRepository {
  Future<List<PracticeQuestion>> getQuestions({String? segment, String? level});
}
