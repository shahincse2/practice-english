import 'package:flutter/material.dart';

import '../core/audience/audience_profile.dart';
import '../core/audience/audience_service.dart';
import '../screens/age_gate_screen.dart';
import '../screens/main_navigation_screen.dart';

/// Shows the age screen until it has been answered, then the app.
class AudienceGate extends StatelessWidget {
  const AudienceGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AudienceProfile?>(
      valueListenable: AudienceService.instance.profile,
      builder: (context, profile, _) {
        if (profile == null) return const AgeGateScreen();

        return const MainNavigationScreen();
      },
    );
  }
}
