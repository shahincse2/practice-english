import 'leaderboard_entry.dart';

/// One screenful of rankings plus the signed-in user's own rank.
class LeaderboardPage {
  const LeaderboardPage({
    required this.entries,
    this.me,
    this.isPreview = false,
  });

  final List<LeaderboardEntry> entries;

  /// The caller's own rank; null when signed out, hidden or not ranked yet.
  final LeaderboardEntry? me;

  /// True for sample data shown while the online leaderboard is not connected.
  final bool isPreview;
}
