class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.displayName,
    required this.points,
    this.streakDays = 0,
    this.isCurrentUser = false,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: json['rank'] as int,
      displayName: json['displayName'] as String,
      points: json['points'] as int,
      streakDays: json['streakDays'] as int? ?? 0,
      isCurrentUser: json['isCurrentUser'] as bool? ?? false,
    );
  }

  final int rank;
  final String displayName;
  final int points;
  final int streakDays;
  final bool isCurrentUser;
}
