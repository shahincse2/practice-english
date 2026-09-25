import 'package:flutter/material.dart';

class AudioButton extends StatelessWidget {
  const AudioButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Material(
          color: theme.colorScheme.primary.withValues(alpha: 0.10),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: const SizedBox(
              width: 72,
              height: 72,
              child: Icon(Icons.volume_up_rounded, size: 32),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text('Tap to listen again', style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
