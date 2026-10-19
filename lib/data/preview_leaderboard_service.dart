import '../core/api/practice_services.dart';
import '../models/leaderboard_page.dart';
import '../models/leaderboard_period.dart';
import 'leaderboard_preview_data.dart';

/// Sample rankings, used while the online leaderboard is not connected.
class PreviewLeaderboardService implements LeaderboardService {
  const PreviewLeaderboardService();

  @override
  Future<LeaderboardPage> load(LeaderboardPeriod period) async {
    return LeaderboardPage(
      entries: leaderboardPreviewEntries[period] ?? const [],
      isPreview: true,
    );
  }
}
