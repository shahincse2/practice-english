import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/audience/audience_service.dart';
import 'core/services/app_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudienceService.instance.load();

  // Firebase, analytics and ads start only once the age is known, and never
  // for children (see AudienceProfile).
  final audience = AudienceService.instance.profile.value;
  if (audience != null) await AppServices.start(audience);

  runApp(const EnglishPracticeApp());
}
