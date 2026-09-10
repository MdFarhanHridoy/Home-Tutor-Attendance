/// Application-level settings stored as a singleton row (PRD §11.6).
class AppSettingsData {
  const AppSettingsData({
    this.themeMode = ThemeModeSetting.dark,
    this.firstDayOfWeek = FirstDayOfWeek.friday,
  });

  /// Version 1 is dark-only (BR-12); the stored value stays `dark` so the
  /// future light theme needs no migration.
  final ThemeModeSetting themeMode;

  /// The calendar week always starts on Friday in Version 1 (BR-11).
  final FirstDayOfWeek firstDayOfWeek;

  AppSettingsData copyWith({
    ThemeModeSetting? themeMode,
    FirstDayOfWeek? firstDayOfWeek,
  }) {
    return AppSettingsData(
      themeMode: themeMode ?? this.themeMode,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettingsData &&
      other.themeMode == themeMode &&
      other.firstDayOfWeek == firstDayOfWeek;

  @override
  int get hashCode => Object.hash(themeMode, firstDayOfWeek);
}

/// Stored theme preference; `system`/`light` are reserved for the future
/// light theme (PRD §19).
enum ThemeModeSetting {
  system('system'),
  light('light'),
  dark('dark');

  const ThemeModeSetting(this.storageValue);

  final String storageValue;

  /// Resolves a stored value; unknown or missing values resolve to dark
  /// because Version 1 is dark-only (BR-12).
  static ThemeModeSetting fromStorage(String? stored) {
    for (final ThemeModeSetting mode in values) {
      if (mode.storageValue == stored) {
        return mode;
      }
    }
    return ThemeModeSetting.dark;
  }
}

/// Calendar week start; fixed to Friday in Version 1 (BR-11). Additional
/// values arrive only if configurability is ever added (PRD §9.1).
enum FirstDayOfWeek {
  friday('friday');

  const FirstDayOfWeek(this.storageValue);

  final String storageValue;

  static FirstDayOfWeek fromStorage(String? stored) {
    for (final FirstDayOfWeek day in values) {
      if (day.storageValue == stored) {
        return day;
      }
    }
    return FirstDayOfWeek.friday;
  }
}
