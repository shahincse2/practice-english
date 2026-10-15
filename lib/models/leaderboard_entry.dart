class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.displayName,
    required this.points,
    this.streakDays = 0,
    this.isCurrentUser = false,
  });

  final int rank;
  final String displayName;
  final int points;
  final int streakDays;
  final bool isCurrentUser;
}
