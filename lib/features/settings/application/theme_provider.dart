import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/theme_settings.dart';

/// Provides the persisted application theme mode (Version 1: always dark,
/// PRD §19, BR-12).
final FutureProvider<ThemeMode> themeModeProvider = FutureProvider<ThemeMode>(
  (Ref ref) => ThemeSettings.loadThemeMode(),
);
