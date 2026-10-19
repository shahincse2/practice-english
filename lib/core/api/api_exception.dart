/// An API call that failed. [message] is safe to show to the user.
class ApiException implements Exception {
  const ApiException(
    this.statusCode, {
    required this.code,
    required this.message,
  }) : detail = null;

  /// The server could not be reached (no network, timeout, blocked HTTP).
  /// [detail] is the technical reason, for the console only.
  const ApiException.network([this.detail])
      : statusCode = 0,
        code = 'network',
        message = 'Could not reach the server. Check your connection.';

  final int statusCode;
  final String code;
  final String message;
  final String? detail;

  bool get isNotFound => statusCode == 404;
  bool get isConflict => statusCode == 409;

  @override
  String toString() {
    final reason = detail == null ? '' : ' [$detail]';
    return 'ApiException($statusCode, $code): $message$reason';
  }
}
