import 'package:flutter/material.dart';

class PracticeHeader extends StatelessWidget {
  const PracticeHeader({
    super.key,
    required this.type,
    required this.current,
    required this.total,
  });

  final String type;
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          type,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        Text('$current / $total', style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
