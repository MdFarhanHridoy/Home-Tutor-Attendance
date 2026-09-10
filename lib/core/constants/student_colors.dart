import 'package:flutter/material.dart';

/// Predefined student colors (PRD §11.2: user-selected from a preset palette;
/// a custom color picker is future work).
///
/// Values are canonical `0xAARRGGBB` strings as stored in the database. The
/// tones are chosen to stay readable on the dark background (PRD §26).
const List<String> studentColorPalette = <String>[
  '0xFFEF5350', // red
  '0xFFEC407A', // pink
  '0xFFAB47BC', // purple
  '0xFF7E57C2', // deep purple
  '0xFF5C6BC0', // indigo
  '0xFF42A5F5', // blue
  '0xFF29B6F6', // light blue
  '0xFF26C6DA', // cyan
  '0xFF26A69A', // teal
  '0xFF66BB6A', // green
  '0xFFFFA726', // orange
  '0xFF8D6E63', // brown
];

/// Parses a stored `0xAARRGGBB` color string for display; falls back to a
/// neutral grey for malformed values.
Color colorFromHex(String hex) {
  final String normalized = hex.startsWith('0x') ? hex.substring(2) : hex;
  final int? value = int.tryParse(normalized, radix: 16);
  if (value == null) {
    return Colors.grey;
  }
  return Color(value);
}
