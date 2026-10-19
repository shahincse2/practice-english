/// Where the API lives. Set it when running or building the app:
/// `--dart-define=API_BASE_URL=http://192.168.0.10:4010`.
///
/// Left empty, the app works without the API (sign-in still works, but no
/// server profile or leaderboard).
class ApiConfig {
  const ApiConfig._();

  static const baseUrl = String.fromEnvironment('API_BASE_URL');

  static bool get isConfigured => baseUrl.isNotEmpty;
}
