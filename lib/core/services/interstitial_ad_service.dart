import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../ads/ad_configuration.dart';
import '../ads/ad_policy.dart';
import '../audience/audience_profile.dart';
import '../audience/audience_service.dart';

class InterstitialAdService {
  InterstitialAdService._({AdPolicy policy = const AdPolicy()})
      : _policy = policy;

  static final instance = InterstitialAdService._();

  // Change to 1 to attempt an ad after every session, or keep 2 to reduce
  // interruptions. Ads are skipped whenever no ad is ready.
  static const int sessionsBetweenAds = 2;

  static const _androidTestAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const _iosTestAdUnitId =
      'ca-app-pub-3940256099942544/4411468910';

  final AdPolicy _policy;
  InterstitialAd? _ad;
  bool _initialized = false;
  bool _loading = false;
  bool _supported = false;

  AudienceProfile get _audience => AudienceService.instance.current;

  Future<void> initialize(AudienceProfile audience) async {
    _supported = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
    if (!_supported || !audience.allowsAds || _initialized) return;

    try {
      // Age-based settings must be applied before the SDK starts.
      await MobileAds.instance.updateRequestConfiguration(
        AdConfiguration.forBand(audience.band),
      );
      await MobileAds.instance.initialize();
      _initialized = true;
    } catch (error) {
      debugPrint('Mobile Ads initialization failed: $error');
    }
  }

  /// Starts loading an ad for [segment]; does nothing where ads are not
  /// allowed, so no ad request is ever made for children's content.
  void prepare({required String? segment}) {
    if (!_policy.allowsAdsFor(segment, audience: _audience)) return;

    _loadAd();
  }

  String get _adUnitId =>
      Platform.isAndroid ? _androidTestAdUnitId : _iosTestAdUnitId;

  void _loadAd() {
    if (!_supported || !_initialized || _loading || _ad != null) return;
    _loading = true;

    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _loading = false;
          _ad = ad;
        },
        onAdFailedToLoad: (error) {
          _loading = false;
          debugPrint('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  Future<void> showAfterCompletedSession(
    int completedSessions, {
    required String? segment,
  }) async {
    if (!_policy.allowsAdsFor(segment, audience: _audience)) return;
    if (!_supported || !_initialized) return;
    if (sessionsBetweenAds < 1 ||
        completedSessions % sessionsBetweenAds != 0) {
      return;
    }

    final ad = _ad;
    if (ad == null) {
      _loadAd();
      return;
    }

    _ad = null;
    final completer = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (shownAd) {
        shownAd.dispose();
        _loadAd();
        if (!completer.isCompleted) completer.complete();
      },
      onAdFailedToShowFullScreenContent: (shownAd, error) {
        debugPrint('Interstitial ad failed to show: $error');
        shownAd.dispose();
        _loadAd();
        if (!completer.isCompleted) completer.complete();
      },
    );

    try {
      ad.show();
      await completer.future;
    } catch (error) {
      ad.dispose();
      _loadAd();
      debugPrint('Could not show interstitial ad: $error');
    }
  }

  void dispose() {
    _ad?.dispose();
    _ad = null;
  }
}
