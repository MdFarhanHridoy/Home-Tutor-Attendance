import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:home_tutor_attendance/app/app.dart';
import 'package:home_tutor_attendance/app/router/app_router.dart';
import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/providers.dart';
import 'package:home_tutor_attendance/features/calendar/presentation/providers.dart';

/// Pumps the full app with an in-memory database and a fixed "today"
/// (2026-09-10) so calendar assertions stay deterministic.
Future<AppDatabase> pumpAppWithDb(WidgetTester tester) async {
  final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
  addTearDown(db.close);
  SharedPreferences.setMockInitialValues(const <String, Object>{});
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWith((Ref ref) => db),
        calendarTodayProvider.overrideWith(
          (Ref ref) => DateTime.utc(2026, 9, 10),
        ),
      ],
      child: HomeTutorAttendanceApp(router: buildAppRouter()),
    ),
  );
  await tester.pumpAndSettle();
  return db;
}

/// Disposes the app tree while the test body is still running, then flushes
/// fake time so drift's stream-store cleanup timers fire before the test
/// binding asserts that no timers remain pending.
Future<void> disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 30));
}
