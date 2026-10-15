/// The signed-in user as the rest of the app sees it (no Firebase types).
class AppUser {
  const AppUser({required this.uid, this.email, this.displayName});

  final String uid;
  final String? email;
  final String? displayName;
}
