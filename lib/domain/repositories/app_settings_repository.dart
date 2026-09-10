import '../entities/app_settings_data.dart';

/// Storage contract for the singleton app-settings row (PRD §11.6).
abstract class AppSettingsRepository {
  /// Loads settings, materializing defaults if the row is missing.
  Future<AppSettingsData> load();

  /// Persists changed settings (timestamps are maintained by the
  /// implementation).
  Future<void> save(AppSettingsData settings);
}
