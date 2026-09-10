import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/repositories/drift_routine_periods_repository.dart';
import 'package:home_tutor_attendance/data/repositories/drift_students_repository.dart';
import 'package:home_tutor_attendance/data/repositories/drift_teaching_periods_repository.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';
import 'package:home_tutor_attendance/domain/services/student_management_service.dart';

export 'app_harness.dart' show pumpAppWithDb, disposeApp;

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
