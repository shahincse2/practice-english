import 'package:flutter/material.dart';

import '../core/audience/audience_band.dart';
import '../core/audience/audience_profile.dart';
import '../core/audience/audience_service.dart';
import '../core/services/app_services.dart';
import '../widgets/birth_date_fields.dart';

/// Neutral age screen, shown once on first launch.
///
/// It asks for a month and year of birth without mentioning any age limit or
/// what each answer unlocks. Only the resulting age band is kept.
class AgeGateScreen extends StatefulWidget {
  const AgeGateScreen({super.key});

  @override
  State<AgeGateScreen> createState() => _AgeGateScreenState();
}

class _AgeGateScreenState extends State<AgeGateScreen> {
  int? _month;
  int? _year;
  bool _busy = false;

  bool get _ready => _month != null && _year != null && !_busy;

  Future<void> _continue() async {
    final month = _month;
    final year = _year;
    if (month == null || year == null || _busy) return;

    setState(() => _busy = true);

    final band = AudienceBand.fromBirth(
      year: year,
      month: month,
      now: DateTime.now(),
    );

    try {
      // Start the services first so they are ready when the home screen opens.
      await AppServices.start(AudienceProfile(band));
    } catch (error) {
      debugPrint('Starting services failed: $error');
    }
    await AudienceService.instance.answer(band);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.record_voice_over_rounded,
                    size: 56,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Before we start',
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Please enter your month and year of birth. We use it '
                    'only to set up the right experience for you, and we do '
                    'not store your date of birth.',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  BirthDateFields(
                    enabled: !_busy,
                    onMonthChanged: (value) => setState(() => _month = value),
                    onYearChanged: (value) => setState(() => _year = value),
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: _ready ? _continue : null,
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
