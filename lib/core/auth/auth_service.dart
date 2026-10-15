import '../../models/app_user.dart';

/// A sign-in problem with a message that is safe to show to the user.
class AuthFailure implements Exception {
  const AuthFailure(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => message;
}

/// What the app needs from authentication. Screens depend on this interface,
/// so the backend (Firebase today) can change without touching the UI.
abstract class AuthService {
  AppUser? get currentUser;

  Stream<AppUser?> get userChanges;

  Future<AppUser> signInWithEmail(String email, String password);

  Future<AppUser> registerWithEmail(String email, String password);

  Future<void> sendPasswordReset(String email);

  Future<void> signOut();

  /// Permanently deletes the account (required by the app stores).
  Future<void> deleteAccount();
}
