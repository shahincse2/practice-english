import '../../data/preview_leaderboard_service.dart';
import 'api_practice_service.dart';
import 'default_api_client.dart';
import 'practice_services.dart';

/// Uploads sessions, or null when the API is not available.
SessionService? defaultSessionService() {
  final client = defaultApiClient();

  return client == null ? null : ApiPracticeService(client);
}

/// Real rankings when the API is available, sample data otherwise.
LeaderboardService defaultLeaderboardService() {
  final client = defaultApiClient();
  if (client == null) return const PreviewLeaderboardService();

  return ApiPracticeService(client);
}
