import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/services/telemetry_service.dart';

/// Opt-in switch for anonymous crash and usage reports.
class PrivacySettingsSection extends StatelessWidget {
  const PrivacySettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final telemetry = TelemetryService.instance;
    if (!telemetry.available) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Card(
        child: ValueListenableBuilder<bool>(
          valueListenable: telemetry.consent,
          builder: (context, value, _) {
            return Column(
              children: [
                SwitchListTile(
                  title: const Text('Share crash reports & usage data'),
                  subtitle: const Text(
                    'Anonymous. Never collected during Kids practice.',
                  ),
                  value: value,
                  onChanged: telemetry.setConsent,
                ),
                // Only in `flutter run --profile` builds, to verify Crashlytics.
                if (kProfileMode && value)
                  ListTile(
                    leading: const Icon(Icons.bug_report_outlined),
                    title: const Text('Send test crash (profile builds only)'),
                    onTap: telemetry.crashForTesting,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
