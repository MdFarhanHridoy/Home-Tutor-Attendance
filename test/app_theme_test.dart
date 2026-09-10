import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/app/theme/app_theme.dart';

void main() {
  test('app theme is Material 3', () {
    expect(appTheme.useMaterial3, isTrue);
  });

  test('app theme is a true dark theme', () {
    expect(appTheme.brightness, Brightness.dark);
    expect(appTheme.scaffoldBackgroundColor.computeLuminance(), lessThan(0.1));
  });

  test('app theme provides a dark color scheme', () {
    expect(appTheme.colorScheme.brightness, Brightness.dark);
  });
}
