import 'package:flutter/material.dart';

/// Shown when the selected segment/level has no questions.
class PracticeEmptyState extends StatelessWidget {
  const PracticeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: Center(
        child: FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Choose Again'),
        ),
      ),
    );
  }
}
