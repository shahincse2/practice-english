import 'dart:async';

import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/services/interstitial_ad_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(InterstitialAdService.instance.initialize());
  runApp(const EnglishPracticeApp());
}
