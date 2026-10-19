import 'package:firebase_auth/firebase_auth.dart';

/// The signed-in user's Firebase ID token (refreshed by Firebase when old).
Future<String?> firebaseIdToken() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  return user.getIdToken();
}
