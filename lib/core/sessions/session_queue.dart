import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/session_submission.dart';

/// Sessions waiting to be uploaded. They are kept on the device, so they
/// survive being offline or closing the app. Each entry remembers which
/// account it belongs to, so one user's sessions never reach another account.
class SessionQueue {
  const SessionQueue();

  static const _key = 'pending_sessions';
  static const _maxPending = 50;

  Future<void> add(String uid, SessionSubmission session) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = [...?prefs.getStringList(_key)];
    entries.add(jsonEncode({'uid': uid, 'session': session.toJson()}));

    final start = entries.length > _maxPending
        ? entries.length - _maxPending
        : 0;
    await prefs.setStringList(_key, entries.sublist(start));
  }

  /// The waiting sessions of [uid], oldest first.
  Future<List<SessionSubmission>> pendingFor(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = <SessionSubmission>[];

    for (final raw in prefs.getStringList(_key) ?? const <String>[]) {
      final entry = _decode(raw);
      if (entry == null || entry['uid'] != uid) continue;

      sessions.add(
        SessionSubmission.fromJson(entry['session'] as Map<String, dynamic>),
      );
    }
    return sessions;
  }

  Future<void> remove(String clientSessionId) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = prefs.getStringList(_key) ?? const <String>[];

    final kept = entries.where((raw) {
      final session = _decode(raw)?['session'] as Map<String, dynamic>?;
      return session != null && session['clientSessionId'] != clientSessionId;
    }).toList();
    await prefs.setStringList(_key, kept);
  }

  Map<String, dynamic>? _decode(String raw) {
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } on FormatException {
      return null;
    }
  }
}
