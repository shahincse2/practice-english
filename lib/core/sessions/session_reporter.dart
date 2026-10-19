import 'package:flutter/foundation.dart';

import '../../models/practice_segment.dart';
import '../../models/session_submission.dart';
import '../api/api_exception.dart';
import '../api/default_practice_services.dart';
import '../api/practice_services.dart';
import '../audience/audience_service.dart';
import '../auth/default_auth_service.dart';
import '../services/telemetry_service.dart';
import 'session_queue.dart';
import 'session_recorder.dart';

/// What happens when a practice session is finished: an analytics event (if
/// allowed) and, for signed-in users, an upload of the result.
class SessionReporter {
  SessionReporter._();

  static final instance = SessionReporter._();

  final _queue = const SessionQueue();
  bool _flushing = false;

  Future<void> report(SessionRecorder recorder) async {
    final segment = recorder.segment;
    await TelemetryService.instance.sessionCompleted(segment, recorder.level);

    final session = recorder.finish();
    final uid = defaultAuthService()?.currentUser?.uid;
    if (session == null || uid == null || !_mayUpload(segment)) return;

    await _queue.add(uid, session);
    await flushPending();
  }

  /// Children and Kids practice are never uploaded.
  bool _mayUpload(String? segment) {
    return AudienceService.instance.current.allowsSignIn &&
        segment != null &&
        segment != PracticeSegment.kids.name;
  }

  /// Sends the signed-in user's waiting sessions. It stops quietly on a
  /// network or sign-in problem and tries again next time.
  Future<void> flushPending() async {
    final uid = defaultAuthService()?.currentUser?.uid;
    final service = defaultSessionService();
    if (_flushing || uid == null || service == null) return;

    _flushing = true;
    try {
      for (final session in await _queue.pendingFor(uid)) {
        if (!await _send(service, session)) break;
      }
    } finally {
      _flushing = false;
    }
  }

  /// Returns false when sending should stop for now.
  Future<bool> _send(SessionService service, SessionSubmission session) async {
    try {
      await service.submit(session);
    } on ApiException catch (error) {
      debugPrint('Session upload failed: $error');
      if (!_isRejectedForGood(error)) return false;
    }

    await _queue.remove(session.clientSessionId);
    return true;
  }

  /// A session the server refuses for good must not block the others. A
  /// missing profile is not that: the session is kept until one exists.
  bool _isRejectedForGood(ApiException error) {
    return error.statusCode == 422 && error.code != 'profile_required';
  }
}
