import '../../models/leaderboard_page.dart';
import '../../models/leaderboard_period.dart';
import '../../models/session_submission.dart';

/// Uploads finished sessions. The app depends on this interface, not on HTTP.
abstract class SessionService {
  Future<void> submit(SessionSubmission session);
}

/// Reads the rankings.
abstract class LeaderboardService {
  Future<LeaderboardPage> load(LeaderboardPeriod period);
}
