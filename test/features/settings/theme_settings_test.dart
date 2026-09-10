import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:home_tutor_attendance/features/settings/data/theme_settings.dart';

void main() {
  test('defaults to dark when nothing is stored', () async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});

    final ThemeMode mode = await ThemeSettings.loadThemeMode();

    expect(mode, ThemeMode.dark);
  });

  test("stored 'dark' resolves to dark", () async {
    SharedPreferences.setMockInitialValues(const <String, Object>{
      'app_settings.theme_mode': 'dark',
    });

    final ThemeMode mode = await ThemeSettings.loadThemeMode();

    expect(mode, ThemeMode.dark);
  });

  test(
    "reserved future value 'light' still renders dark in Version 1",
    () async {
      SharedPreferences.setMockInitialValues(const <String, Object>{
        'app_settings.theme_mode': 'light',
      });

      final ThemeMode mode = await ThemeSettings.loadThemeMode();

      expect(mode, ThemeMode.dark);
    },
  );

  test(
    "reserved future value 'system' still renders dark in Version 1",
    () async {
      SharedPreferences.setMockInitialValues(const <String, Object>{
        'app_settings.theme_mode': 'system',
      });

      final ThemeMode mode = await ThemeSettings.loadThemeMode();

      expect(mode, ThemeMode.dark);
    },
  );

  test('corrupt stored value still renders dark in Version 1', () async {
    SharedPreferences.setMockInitialValues(const <String, Object>{
      'app_settings.theme_mode': 'banana',
    });

    final ThemeMode mode = await ThemeSettings.loadThemeMode();

    expect(mode, ThemeMode.dark);
  });
}
