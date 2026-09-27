import '../../models/practice_question.dart';

abstract class PracticeDataSource {
  Future<List<PracticeQuestion>> getQuestions({String? segment, String? level});
}
