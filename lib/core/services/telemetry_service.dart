import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The single place that decides whether analytics and crash data may be
/// collected.
///
/// Collection is opt-in (off by default) and is always off in kids mode.
/// Only Android and iOS are supported; elsewhere every call is a no-op.
class TelemetryService {
  TelemetryService._();

  static final instance = TelemetryService._();

  static const _consentKey = 'telemetry_consent';

  /// What the user chose in Settings.
  final consent = ValueNotifier<bool>(false);

  bool _ready = false;
  bool _kidsMode = false;

  static bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  bool get available => _ready;
  bool get enabled => _ready && consent.value && !_kidsMode;

  Future<void> initialize({required bool firebaseReady}) async {
    if (!firebaseReady || !isSupported) return;

    final prefs = await SharedPreferences.getInstance();
    consent.value = prefs.getBool(_consentKey) ?? false;
    _ready = true;
    await _apply();
  }

  Future<void> setConsent(bool value) async {
    consent.value = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, value);
    await _apply();
  }

  /// Kids practice must never be tracked, whatever the user chose.
  void setKidsMode(bool value) {
    if (_kidsMode == value) return;

    _kidsMode = value;
    unawaited(_apply());
  }

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    if (!enabled) return;

    try {
      await FirebaseAnalytics.instance.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (error) {
      debugPrint('Analytics event failed: $error');
    }
  }

  /// Forces a native crash to verify Crashlytics (profile builds only).
  void crashForTesting() => FirebaseCrashlytics.instance.crash();

  Future<void> sessionCompleted(String? segment, String? level) {
    return logEvent(
      'session_complete',
      parameters: {'segment': segment ?? 'all', 'level': level ?? 'all'},
    );
  }

  Future<void> _apply() async {
    if (!_ready) return;

    try {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(enabled);
      // Crashlytics stays off in debug builds to keep the reports clean.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        enabled && !kDebugMode,
      );
    } catch (error) {
      debugPrint('Could not update telemetry settings: $error');
    }
  }
}
