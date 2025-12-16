import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// Provider to manage app theme (light/dark mode)
class ThemeProvider extends ChangeNotifier {
  static const String _themeModeKey = 'themeMode';
  final StorageService _storage = StorageService();

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Initialize theme from storage
  void loadTheme() {
    try {
      final savedTheme = _storage.settingsBox.get(_themeModeKey, defaultValue: 'light');
      _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      // If error, use default light theme
      _themeMode = ThemeMode.light;
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _saveTheme();
    notifyListeners();
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    await _saveTheme();
    notifyListeners();
  }

  /// Save theme preference to storage
  Future<void> _saveTheme() async {
    try {
      await _storage.settingsBox.put(
        _themeModeKey,
        _themeMode == ThemeMode.dark ? 'dark' : 'light',
      );
    } catch (e) {
      // Silent fail - theme will reset on next launch
    }
  }
}
