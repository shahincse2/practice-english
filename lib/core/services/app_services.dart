import 'dart:async';

import '../audience/audience_profile.dart';
import '../firebase/firebase_bootstrap.dart';
import 'interstitial_ad_service.dart';
import 'telemetry_service.dart';

/// Starts Firebase, analytics and ads, but only for users who may have them.
/// Children get none of them. Safe to call more than once.
class AppServices {
  const AppServices._();

  static bool _started = false;

  static Future<void> start(AudienceProfile audience) async {
    if (_started || !audience.allowsThirdPartyServices) return;
    _started = true;

    unawaited(InterstitialAdService.instance.initialize(audience));

    final firebaseReady = await initializeFirebase();
    await TelemetryService.instance.initialize(firebaseReady: firebaseReady);
  }
}
