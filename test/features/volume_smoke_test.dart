import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/repositories/drift_attendance_repository.dart';

import '../helpers/students_app_harness.dart';

/// Rendering smoke test (implementation.md §18 8.6): the two heaviest
/// screens settle and render correctly with a realistic volume of data
/// (dozens of students, a hundred+ attendance records).
void main() {
  testWidgets('calendar and goal screens render at volume', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    final service = serviceFor(db);
    final DriftAttendanceRepository attendance = DriftAttendanceRepository(db);

    final List<String> ids = <String>[];
    for (int i = 1; i <= 40; i++) {
      final student = await service.createStudent(
        name: 'Student ${i.toString().padLeft(2, '0')}',
        weeklyDays: 3,
        routineWeekdays: monWedFri,
        color: '0xFF42A5F5',
        startDate: DateTime(2026, 8, 1),
      );
      ids.add(student.id);
    }
    for (final String id in ids) {
      for (final int day in <int>[2, 7, 9, 14, 21]) {
        await attendance.add(
          studentId: id,
          attendanceDate: DateTime.utc(2026, 9, day),
        );
      }
    }

    // Calendar: 40 chips on the busiest day (Mon Sep 7) render with overflow.
    await tester.pumpAndSettle();
    expect(find.text('+38 more'), findsWidgets);
    expect(find.byKey(const Key('cal-day-2026-09-07')), findsOneWidget);

    // Goal screen: 40 rows in the September card settle without errors.
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Monthly Attendance Goal'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('goal-month-2026-09')),
        matching: find.text('5 / 13 · 38%'),
      ),
      findsWidgets,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('goal-month-2026-09')),
        matching: find.text('Student 01'),
      ),
      findsOneWidget,
    );
    await disposeApp(tester);
  });
}
