import '../../models/account_profile.dart';

/// The server-side profile of the signed-in user. Screens depend on this
/// interface, not on HTTP, so the backend can change without touching the UI.
abstract class AccountProfileService {
  /// The profile, or null when none was created yet.
  Future<AccountProfile?> getProfile();

  Future<AccountProfile> saveProfile({
    required String displayName,
    required bool leaderboardVisible,
    required bool confirmedAge13Plus,
    int? upazilaId,
  });

  /// Deletes the profile and everything stored with it. A profile that is
  /// already gone counts as deleted.
  Future<void> deleteProfile();
}
