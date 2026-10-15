import 'dart:async';

import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'core/services/interstitial_ad_service.dart';
import 'core/services/telemetry_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(InterstitialAdService.instance.initialize());

  final firebaseReady = await initializeFirebase();
  await TelemetryService.instance.initialize(firebaseReady: firebaseReady);

  runApp(const EnglishPracticeApp());
}
