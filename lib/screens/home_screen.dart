import 'package:flutter/material.dart';

import 'practice_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _startPractice(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PracticeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              Center(
                child: Icon(
                  Icons.record_voice_over_rounded,
                  size: 72,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: 28),

              Text(
                'English Practice',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                'Listen carefully and type what you hear.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              _InstructionCard(theme: theme),

              const Spacer(),

              FilledButton(
                onPressed: () => _startPractice(context),
                child: const Text('Start Practice'),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _InstructionCard extends StatelessWidget {
  const _InstructionCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.primary.withValues(alpha: 0.08),
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'How it works',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            Text(
              'Listen  →  Type  →  Check  →  Continue',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
