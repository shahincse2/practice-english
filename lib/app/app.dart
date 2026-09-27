import 'package:flutter/material.dart';

import '../controllers/theme_controller.dart';
import '../models/app_theme_mode.dart';
import '../screens/main_navigation_screen.dart';
import 'app_theme.dart';

class EnglishPracticeApp extends StatelessWidget {
  const EnglishPracticeApp({super.key});

  static final _themeController = ThemeController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (_, __) {
        return MaterialApp(
          title: 'English Practice',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: _themeMode,
          home: const MainNavigationScreen(),
        );
      },
    );
  }

  ThemeMode get _themeMode {
    switch (_themeController.mode) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  static ThemeController get themeController => _themeController;
}
