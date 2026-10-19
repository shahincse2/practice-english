/// The user's profile as stored on the server (see `Profile` in openapi.yaml).
/// The local `UserProfile` (name, email, level...) is a separate thing.
class AccountProfile {
  const AccountProfile({
    required this.displayName,
    required this.leaderboardVisible,
    this.upazilaId,
    this.createdAt,
  });

  factory AccountProfile.fromJson(Map<String, dynamic> json) {
    return AccountProfile(
      displayName: json['displayName'] as String,
      leaderboardVisible: json['leaderboardVisible'] as bool? ?? true,
      upazilaId: json['upazilaId'] as int?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
    );
  }

  final String displayName;
  final bool leaderboardVisible;
  final int? upazilaId;
  final DateTime? createdAt;
}
