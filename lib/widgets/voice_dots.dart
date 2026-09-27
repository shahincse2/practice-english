import 'package:flutter/material.dart';

class VoiceDots extends StatelessWidget {
  const VoiceDots({
    super.key,
    required this.count,
    required this.currentPage,
  });

  final int count;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = theme.colorScheme.primary;
    final inactive = theme.colorScheme.outlineVariant;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
            (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentPage ? active : inactive,
          ),
        ),
      ),
    );
  }
}