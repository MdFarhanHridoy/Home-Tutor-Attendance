import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/repositories/drift_app_settings_repository.dart';
import 'package:home_tutor_attendance/domain/entities/app_settings_data.dart';

void main() {
  late AppDatabase db;
  late DriftAppSettingsRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftAppSettingsRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('load returns Version 1 defaults from the seeded row', () async {
    final AppSettingsData settings = await repository.load();

    expect(settings.themeMode, ThemeModeSetting.dark);
    expect(settings.firstDayOfWeek, FirstDayOfWeek.friday);
  });

  test(
    'save persists values and survives reload on the same database',
    () async {
      await repository.load(); // ensure row exists
      await repository.save(
        const AppSettingsData().copyWith(firstDayOfWeek: FirstDayOfWeek.friday),
      );

      final AppSettingsData reloaded = await repository.load();
      expect(reloaded.themeMode, ThemeModeSetting.dark);
      expect(reloaded.firstDayOfWeek, FirstDayOfWeek.friday);
    },
  );

  test('load materializes defaults when the row is missing', () async {
    // Simulate a database whose settings row vanished.
    await db.customStatement('DELETE FROM app_settings');

    final AppSettingsData settings = await repository.load();

    expect(settings.themeMode, ThemeModeSetting.dark);
    expect(settings.firstDayOfWeek, FirstDayOfWeek.friday);
    expect(await db.select(db.appSettingsTable).get(), hasLength(1));
  });
}
