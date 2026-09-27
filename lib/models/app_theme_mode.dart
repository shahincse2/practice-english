enum AppThemeMode {
  system,
  light,
  dark,
}

extension AppThemeModeX on AppThemeMode {
  String get label {
    switch (this) {
      case AppThemeMode.system:
        return 'System Default';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }

  String get storageValue => name;

  static AppThemeMode fromStorage(String? value) {
    return AppThemeMode.values.firstWhere(
          (mode) => mode.name == value,
      orElse: () => AppThemeMode.system,
    );
  }
}