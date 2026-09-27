import 'package:flutter/foundation.dart';

import '../core/services/theme_settings_service.dart';
import '../models/app_theme_mode.dart';

class ThemeController extends ChangeNotifier {
  ThemeController() {
    _load();
  }

  final _service = ThemeSettingsService();

  AppThemeMode _mode = AppThemeMode.system;
  bool _ready = false;

  AppThemeMode get mode => _mode;
  bool get ready => _ready;

  Future<void> _load() async {
    _mode = await _service.load();
    _ready = true;
    notifyListeners();
  }

  Future<void> setMode(AppThemeMode mode) async {
    if (_mode == mode) return;

    _mode = mode;
    notifyListeners();

    await _service.save(mode);
  }
}
