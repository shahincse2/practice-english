import 'package:firebase_core/firebase_core.dart';

import 'auth_service.dart';
import 'firebase_auth_service.dart';

/// The auth backend the app uses, or null when Firebase did not start.
AuthService? defaultAuthService() {
  if (Firebase.apps.isEmpty) return null;

  return FirebaseAuthService();
}
