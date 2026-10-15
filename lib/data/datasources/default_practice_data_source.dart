import 'composite_practice_data_source.dart';
import 'json_practice_data_source.dart';
import 'lesson_practice_data_source.dart';
import 'practice_data_source.dart';

/// The data source the app uses: guided lessons first, then single items.
///
/// Swap the order of the list to change which content comes first.
PracticeDataSource defaultPracticeDataSource() {
  return const CompositePracticeDataSource([
    LessonPracticeDataSource(),
    JsonPracticeDataSource(),
  ]);
}
