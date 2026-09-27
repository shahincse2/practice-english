import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFF2F6B4F);
  static const background = Color(0xFFF7F9F7);
  static const text = Color(0xFF1F2933);
  static const secondaryText = Color(0xFF667085);

  static ThemeData light() {
    return _base(
      Brightness.light,
      background,
      text,
      secondaryText,
    );
  }

  static ThemeData dark() {
    return _base(
      Brightness.dark,
      const Color(0xFF121715),
      Colors.white,
      const Color(0xFFB8C1BC),
    );
  }

  static ThemeData _base(
      Brightness brightness,
      Color background,
      Color text,
      Color secondaryText,
      ) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: brightness,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        elevation: 0,
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: text,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: secondaryText,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}