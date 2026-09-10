import 'package:drift/drift.dart';

import '../../domain/entities/weekday.dart';
import 'converters.dart';
import 'database_connection.dart';
import 'tables.dart';

part 'app_database.g.dart';

/// The local database for Home Tutor Attendance.
///
/// Migration policy (PRD §40): step-by-step, additive migrations only — never
/// destructive changes during normal upgrades. Development reset strategy:
/// delete the app (or its data) to remove the database file; tests use
/// in-memory executors via [AppDatabase.forTesting].
@DriftDatabase(
  tables: [
    Students,
    TeachingPeriods,
    RoutinePeriods,
    AttendanceRecords,
    AppSettingsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openAppDatabaseConnection());

  /// Test constructor over a provided (typically in-memory) executor.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // Seed the singleton settings row with Version 1 defaults
      // (dark theme, Friday week start).
      await into(appSettingsTable).insert(
        AppSettingsTableCompanion.insert(
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Add step-by-step migrations as schemaVersion increases, e.g.:
      // if (from < 2) { await m.addColumn(...); }
    },
    beforeOpen: (OpeningDetails details) async {
      // Enforce referential integrity (attendance must reference students).
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
