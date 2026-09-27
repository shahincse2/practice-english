import 'package:flutter/material.dart';

import '../core/services/answer_sound_service.dart';
import 'practice_screen.dart';

class CompleteScreen extends StatefulWidget {
  const CompleteScreen({super.key});

  @override
  State<CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen> {
  final AnswerSoundService _answerSound = AnswerSoundService();

  @override
  void initState() {
    super.initState();
    _playCheering();
  }

  Future<void> _playCheering() async {
    await _answerSound.initialize();
    await _answerSound.playCheering();
  }

  void _practiceAgain() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PracticeScreen()),
    );
  }

  @override
  void dispose() {
    _answerSound.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 72,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Practice Complete',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'You completed this practice session.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _practiceAgain,
                    child: const Text('Practice Again'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
