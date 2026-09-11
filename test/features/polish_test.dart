import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/repositories/drift_attendance_repository.dart';

import '../helpers/students_app_harness.dart';

/// Phase 9 polish checks: drawer status-bar safety, goal progress bars, and
/// responsive calendar layouts at small/large screen sizes.
void main() {
  testWidgets('drawer content stays below the status bar (user report)', (
    WidgetTester tester,
  ) async {
    await pumpAppWithDb(tester);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    // The drawer's list is wrapped in a SafeArea (honoring the top inset)
    // so the app title clears the phone's notification bar. Material's own
    // internal drawer SafeAreas ignore the top inset, so assert on the
    // top-avoiding one specifically.
    expect(
      find.descendant(
        of: find.byType(Drawer),
        matching: find.byWidgetPredicate(
          (Widget widget) => widget is SafeArea && widget.top,
        ),
      ),
      findsOneWidget,
    );
    // Title renders inside the drawer below the safe-area inset.
    expect(
      find.descendant(
        of: find.byType(Drawer),
        matching: find.text('Home Tutor Attendance'),
      ),
      findsOneWidget,
    );
    await disposeApp(tester);
  });

  testWidgets('goal month cards show a clamped progress bar', (
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
    await DriftAttendanceRepository(
      db,
    ).add(studentId: student.id, attendanceDate: DateTime.utc(2026, 9, 2));

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Monthly Attendance Goal'));
    await tester.pumpAndSettle();

    final Finder septemberBar = find.descendant(
      of: find.byKey(const Key('goal-month-2026-09')),
      matching: find.byType(LinearProgressIndicator),
    );
    expect(septemberBar, findsOneWidget);
    // 1 attended of the flat 3×4 target.
    expect(tester.widget<LinearProgressIndicator>(septemberBar).value, 1 / 12);
    await disposeApp(tester);
  });

  testWidgets('calendar renders on small and large screens without overflow', (
    WidgetTester tester,
  ) async {
    await pumpAppWithDb(tester);

    // Small phone (360×640-class logical size).
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('cal-day-2026-09-15')), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Large phone / small tablet.
    await tester.binding.setSurfaceSize(const Size(800, 1280));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('cal-day-2026-09-15')), findsOneWidget);
    expect(tester.takeException(), isNull);
    await disposeApp(tester);
  });
}
