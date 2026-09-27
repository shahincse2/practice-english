import '../../models/practice_question.dart';
import '../datasources/practice_data_source.dart';
import 'practice_repository.dart';

class PracticeRepositoryImpl implements PracticeRepository {
  const PracticeRepositoryImpl(this._dataSource);

  final PracticeDataSource _dataSource;

  @override
  Future<List<PracticeQuestion>> getQuestions({
    String? segment,
    String? level,
  }) {
    return _dataSource.getQuestions(segment: segment, level: level);
  }
}
