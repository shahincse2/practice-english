import 'package:flutter/material.dart';

import '../models/app_theme_mode.dart';

class ThemeSettingCard extends StatelessWidget {
  const ThemeSettingCard({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final AppThemeMode value;
  final ValueChanged<AppThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            RadioGroup<AppThemeMode>(
              groupValue: value,
              onChanged: (mode) {
                if (mode != null) {
                  onChanged(mode);
                }
              },
              child: Column(
                children: AppThemeMode.values.map(
                      (mode) {
                    return RadioListTile<AppThemeMode>(
                      value: mode,
                      title: Text(mode.label),
                      contentPadding: EdgeInsets.zero,
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}