import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

/// Gives the current sign-in token, or null when nobody is signed in.
typedef TokenProvider = Future<String?> Function();

/// Small JSON-over-HTTP client for the English Practice API.
///
/// It knows nothing about Firebase: the token comes from [tokenProvider].
class ApiClient {
  ApiClient({
    required String baseUrl,
    this.tokenProvider,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 15),
  })  : _baseUrl = baseUrl.endsWith('/')
            ? baseUrl.substring(0, baseUrl.length - 1)
            : baseUrl,
        _http = httpClient ?? http.Client();

  final String _baseUrl;
  final TokenProvider? tokenProvider;
  final Duration timeout;
  final http.Client _http;

  Future<Object?> get(String path, {Map<String, String>? query}) {
    return _send('GET', path, query: query);
  }

  Future<Object?> put(String path, Object body) {
    return _send('PUT', path, body: body);
  }

  Future<Object?> post(String path, Object body) {
    return _send('POST', path, body: body);
  }

  Future<void> delete(String path) async {
    await _send('DELETE', path);
  }

  Future<Object?> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
  }) async {
    final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: query);
    final request = http.Request(method, uri)
      ..headers['Accept'] = 'application/json';

    final token = await tokenProvider?.call();
    if (token != null) request.headers['Authorization'] = 'Bearer $token';

    if (body != null) {
      request.headers['Content-Type'] = 'application/json; charset=utf-8';
      request.body = jsonEncode(body);
    }

    try {
      final streamed = await _http.send(request).timeout(timeout);
      final response = await http.Response.fromStream(streamed);
      return _decode(response);
    } on TimeoutException {
      throw ApiException.network('timed out after ${timeout.inSeconds}s: $uri');
    } on http.ClientException catch (error) {
      throw ApiException.network('${error.message} ($uri)');
    }
  }

  Object? _decode(http.Response response) {
    final text = utf8.decode(response.bodyBytes);
    final json = text.isEmpty ? null : _tryDecode(text);
    final status = response.statusCode;

    if (status >= 200 && status < 300) return json;

    final problem = json is Map<String, dynamic> ? json : const {};
    throw ApiException(
      status,
      code: problem['code'] as String? ?? 'http_$status',
      message: problem['message'] as String? ?? 'Request failed ($status).',
    );
  }

  Object? _tryDecode(String text) {
    try {
      return jsonDecode(text);
    } on FormatException {
      return null;
    }
  }
}
