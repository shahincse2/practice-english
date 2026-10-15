import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PracticeSessionService {
  PracticeSessionService._();

  static final instance = PracticeSessionService._();

  static const _key = 'practice_completed_sessions';

  final ValueNotifier<int> completedSessions = ValueNotifier(0);

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();

    completedSessions.value = prefs.getInt(_key) ?? 0;
    _initialized = true;
  }

  Future<void> recordCompletedSession() async {
    await initialize();

    final value = completedSessions.value + 1;
    completedSessions.value = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, value);
  }
}
