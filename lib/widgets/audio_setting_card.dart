import 'package:flutter/material.dart';

class AudioSettingCard extends StatelessWidget {
  const AudioSettingCard({
    super.key,
    required this.title,
    required this.child,
    this.value,
  });

  final String title;
  final String? value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (value != null) Text(value!),
              ],
            ),
            child,
          ],
        ),
      ),
    );
  }
}
