import 'package:flutter/material.dart';

import '../app/app.dart';
import '../models/app_theme_mode.dart';

class ThemeMenu extends StatelessWidget {
  const ThemeMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = EnglishPracticeApp.themeController;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return PopupMenuButton<AppThemeMode>(
          icon: const Icon(Icons.brightness_6_rounded),
          onSelected: controller.setMode,
          itemBuilder: (_) {
            return AppThemeMode.values.map((mode) {
              final selected = mode == controller.mode;

              return PopupMenuItem(
                value: mode,
                child: Row(
                  children: [
                    Icon(_icon(mode), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(mode.label),
                    ),
                    if (selected)
                      const Icon(
                        Icons.check_rounded,
                        size: 20,
                      ),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }

  IconData _icon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return Icons.brightness_auto_rounded;
      case AppThemeMode.light:
        return Icons.light_mode_rounded;
      case AppThemeMode.dark:
        return Icons.dark_mode_rounded;
    }
  }
}