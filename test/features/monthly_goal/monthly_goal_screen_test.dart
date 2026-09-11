import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/repositories/drift_attendance_repository.dart';

import '../../helpers/students_app_harness.dart';

void main() {
  testWidgets('shows the empty state when there are no students', (
    WidgetTester tester,
  ) async {
    await pumpAppWithDb(tester);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Monthly Attendance Goal'));
    await tester.pumpAndSettle();

    expect(
      find.text('Monthly Attendance Goal'),
      findsWidgets,
    ); // drawer + app bar
    expect(find.text('No attendance data yet'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('renders six month cards with per-student summaries', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    final student = await serviceFor(db).createStudent(
      name: 'Alpha One',
      weeklyDays: 3,
      routineWeekdays: monWedFri,
      color: '0xFF42A5F5',
      startDate: DateTime(2026, 8, 1),
    );
    final DriftAttendanceRepository attendance = DriftAttendanceRepository(db);
    for (final int day in <int>[2, 4, 7, 9, 11]) {
      await attendance.add(
        studentId: student.id,
        attendanceDate: DateTime.utc(2026, 9, day),
      );
    }

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Monthly Attendance Goal'));
    await tester.pumpAndSettle();

    // Newest month first.
    expect(find.text('September 2026'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('goal-month-2026-09')),
        matching: find.text('Alpha One'),
      ),
      findsOneWidget,
    );
    // Overall header (single student → equals the row) via its key.
    expect(
      tester.widget<Text>(find.byKey(const Key('goal-overall-2026-09'))).data,
      '5 / 12 · 42%',
    );
    // Row: 5 attended / 12 flat target (3 days/week × 4, v1.2).
    expect(
      find.descendant(
        of: find.byKey(Key('goal-row-${student.id}-2026-09')),
        matching: find.text('5 / 12 · 42%'),
      ),
      findsOneWidget,
    );

    // Older months render further down the list.
    await tester.scrollUntilVisible(
      find.text('April 2026'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('April 2026'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('inactive student keeps appearing in historical months only', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    final service = serviceFor(db);
    final student = await service.createStudent(
      name: 'Alpha One',
      weeklyDays: 3,
      routineWeekdays: monWedFri,
      color: '0xFF42A5F5',
      startDate: DateTime(2026, 7, 1),
    );
    await service.setCurrentlyTeaching(studentId: student.id, teaching: false);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Monthly Attendance Goal'));
    await tester.pumpAndSettle();

    // September (current month, today 2026-09-10): the student stopped
    // teaching Sep 9 — their period (Jul 1 – Sep 9) still overlaps
    // September, so they remain visible with history.
    expect(
      find.descendant(
        of: find.byKey(const Key('goal-month-2026-09')),
        matching: find.text('Alpha One'),
      ),
      findsOneWidget,
    );

    // November does not exist in the window; scroll to the oldest month
    // (April) — the period does not overlap April, so no row there.
    await tester.scrollUntilVisible(
      find.text('April 2026'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('goal-month-2026-04')),
        matching: find.text('Alpha One'),
      ),
      findsNothing,
    );
    await disposeApp(tester);
  });
}
