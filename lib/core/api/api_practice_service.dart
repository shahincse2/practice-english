import '../../models/leaderboard_entry.dart';
import '../../models/leaderboard_page.dart';
import '../../models/leaderboard_period.dart';
import '../../models/session_submission.dart';
import 'api_client.dart';
import 'practice_services.dart';

class ApiPracticeService implements SessionService, LeaderboardService {
  const ApiPracticeService(this._client);

  final ApiClient _client;

  @override
  Future<void> submit(SessionSubmission session) async {
    await _client.post('/v1/sessions', session.toJson());
  }

  @override
  Future<LeaderboardPage> load(LeaderboardPeriod period) async {
    final json = await _client.get(
      '/v1/leaderboard',
      query: {'period': period.name},
    ) as Map<String, dynamic>;

    final me = json['me'] as Map<String, dynamic>?;

    return LeaderboardPage(
      entries: [
        for (final entry in json['entries'] as List<dynamic>)
          LeaderboardEntry.fromJson(entry as Map<String, dynamic>),
      ],
      me: me == null ? null : LeaderboardEntry.fromJson(me),
    );
  }
}
