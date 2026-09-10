import 'package:flutter/material.dart';

/// Dark-only Material 3 theme for Version 1 (PRD §19, BR-12).
///
/// The design targets a calm, true-dark Android look: dark surfaces, readable
/// typography, and a single restrained accent for app chrome. Student-assigned
/// colors are rendered on top of this base starting in later phases.
///
/// A light theme is planned for a future version; when it ships, add a
/// parallel builder and expose the stored `theme_mode` values
/// (`system`/`light`/`dark`) through the settings feature.
final ThemeData appTheme = _buildAppTheme();

ThemeData _buildAppTheme() {
  const Color seedColor = Color(0xFF6C8FE8);
  final ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFF111318),
    appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
  );
}
