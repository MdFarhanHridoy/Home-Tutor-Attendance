import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:home_tutor_attendance/app/app.dart';
import 'package:home_tutor_attendance/app/router/app_router.dart';
import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/providers.dart';
import 'package:home_tutor_attendance/data/repositories/drift_routine_periods_repository.dart';
import 'package:home_tutor_attendance/data/repositories/drift_students_repository.dart';
import 'package:home_tutor_attendance/data/repositories/drift_teaching_periods_repository.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';
import 'package:home_tutor_attendance/domain/services/student_management_service.dart';

/// Shared harness: pumps the full app with an in-memory database override.
Future<AppDatabase> pumpAppWithDb(WidgetTester tester) async {
  final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
  addTearDown(db.close);
  SharedPreferences.setMockInitialValues(const <String, Object>{});
  await tester.pumpWidget(
    ProviderScope(
      overrides: [databaseProvider.overrideWith((Ref ref) => db)],
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

StudentManagementService serviceFor(AppDatabase db) => StudentManagementService(
  studentsRepository: DriftStudentsRepository(db),
  teachingPeriodsRepository: DriftTeachingPeriodsRepository(db),
  routinePeriodsRepository: DriftRoutinePeriodsRepository(db),
);

const List<Weekday> monWedFri = <Weekday>[
  Weekday.monday,
  Weekday.wednesday,
  Weekday.friday,
];

/// Navigates to the Students screen via the drawer (real user path).
Future<void> openStudents(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Open navigation menu'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Students List'));
  await tester.pumpAndSettle();
}
