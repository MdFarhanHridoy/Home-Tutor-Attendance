import 'package:drift/drift.dart';

import '../../domain/entities/app_settings_data.dart';
import '../../domain/repositories/app_settings_repository.dart';
import '../database/app_database.dart';

/// Drift-backed [AppSettingsRepository] over the singleton row (id = 1).
class DriftAppSettingsRepository implements AppSettingsRepository {
  DriftAppSettingsRepository(this._db);

  final AppDatabase _db;

  @override
  Future<AppSettingsData> load() async {
    final AppSettingsRow? row =
        await (_db.select(_db.appSettingsTable)
              ..where(($AppSettingsTableTable tbl) => tbl.id.equals(1)))
            .getSingleOrNull();
    if (row == null) {
      // Defensive materialization for databases created outside the normal
      // migration path (PRD §11.6 defaults).
      final DateTime now = DateTime.now();
      await _db
          .into(_db.appSettingsTable)
          .insert(
            AppSettingsTableCompanion.insert(createdAt: now, updatedAt: now),
          );
      return const AppSettingsData();
    }
    return AppSettingsData(
      themeMode: ThemeModeSetting.fromStorage(row.themeMode),
      firstDayOfWeek: FirstDayOfWeek.fromStorage(row.firstDayOfWeek),
    );
  }

  @override
  Future<void> save(AppSettingsData settings) async {
    await (_db.update(
      _db.appSettingsTable,
    )..where(($AppSettingsTableTable tbl) => tbl.id.equals(1))).write(
      AppSettingsTableCompanion(
        themeMode: Value<String>(settings.themeMode.storageValue),
        firstDayOfWeek: Value<String>(settings.firstDayOfWeek.storageValue),
        updatedAt: Value<DateTime>(DateTime.now()),
      ),
    );
  }
}
