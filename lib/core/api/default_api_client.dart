import 'package:firebase_core/firebase_core.dart';

import '../auth/firebase_token_provider.dart';
import 'api_client.dart';
import 'api_config.dart';

ApiClient? _shared;

/// The one API client of the app, or null when the API is not available: no
/// address configured, or Firebase did not start (for example for children).
ApiClient? defaultApiClient() {
  if (!ApiConfig.isConfigured || Firebase.apps.isEmpty) return null;

  return _shared ??= ApiClient(
    baseUrl: ApiConfig.baseUrl,
    tokenProvider: firebaseIdToken,
  );
}
