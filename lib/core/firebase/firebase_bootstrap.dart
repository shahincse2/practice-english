import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';
import '../services/telemetry_service.dart';

/// Starts Firebase. Returns false (the app keeps running) if it fails.
Future<bool> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    debugPrint('Firebase initialization failed: $error');
    return false;
  }

  if (TelemetryService.isSupported) _forwardErrorsToCrashlytics();
  return true;
}

/// Hands uncaught errors to Crashlytics. Nothing is actually sent unless the
/// user opted in (see [TelemetryService]).
void _forwardErrorsToCrashlytics() {
  final crashlytics = FirebaseCrashlytics.instance;
  final previousHandler = FlutterError.onError;

  FlutterError.onError = (details) {
    previousHandler?.call(details);
    crashlytics.recordFlutterFatalError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    crashlytics.recordError(error, stack, fatal: true);
    // In debug, let the error print to the console as usual.
    return !kDebugMode;
  };
}
