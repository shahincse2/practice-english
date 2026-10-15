import '../../models/practice_question.dart';
import 'practice_data_source.dart';

/// Combines several data sources; results keep the order of [_sources].
class CompositePracticeDataSource implements PracticeDataSource {
  const CompositePracticeDataSource(this._sources);

  final List<PracticeDataSource> _sources;

  @override
  Future<List<PracticeQuestion>> getQuestions({
    String? segment,
    String? level,
  }) async {
    final results = await Future.wait(
      _sources.map(
        (source) => source.getQuestions(segment: segment, level: level),
      ),
    );

    return [for (final questions in results) ...questions];
  }
}
