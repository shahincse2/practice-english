import 'package:flutter/material.dart';

class AudioVolumeTile extends StatelessWidget {
  const AudioVolumeTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 23, color: theme.colorScheme.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Slider(value: value, min: 0, max: 1, onChanged: onChanged),
      ],
    );
  }
}
