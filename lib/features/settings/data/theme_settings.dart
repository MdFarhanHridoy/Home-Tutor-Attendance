import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the app-level theme preference in simple local key-value storage,
/// as sanctioned by the PRD (§11.6, §19).
///
/// Stored values `system`, `light`, and `dark` are reserved by the data
/// model. Version 1 is dark-only (BR-12), so every stored value currently
/// resolves to [ThemeMode.dark]; this mapping is the single place to extend
/// when the light theme ships. Phase 2 will carry the same setting into the
/// `app_settings` database row while this quick-read store keeps startup
/// synchronous-friendly.
class ThemeSettings {
  const ThemeSettings._();

  static const String _themeModeKey = 'app_settings.theme_mode';

  /// Loads the persisted theme mode, defaulting to dark.
  ///
  /// Reading (rather than hard-coding) keeps the persistence contract real:
  /// the app consults the stored value on every startup, so the future theme
  /// toggle requires no bootstrap changes.
  static Future<ThemeMode> loadThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? stored = prefs.getString(_themeModeKey);
    return _modeFromStorage(stored);
  }

  static ThemeMode _modeFromStorage(String? stored) {
    // Version 1 is dark-only (PRD v1.1, BR-12): every stored value — null,
    // 'dark', or values reserved for future versions ('light', 'system') —
    // renders dark. Map the reserved values to real ThemeModes here once the
    // light theme ships (docs/PRD.md §19).
    return ThemeMode.dark;
  }
}
