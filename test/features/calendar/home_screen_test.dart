import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/repositories/drift_attendance_repository.dart';

import '../../helpers/students_app_harness.dart';

void main() {
  testWidgets('opens on the current month with today highlighted (AC-01/02)', (
    WidgetTester tester,
  ) async {
    await pumpAppWithDb(tester);

    expect(find.text('September 2026'), findsOneWidget);
    expect(find.byKey(const Key('cal-day-2026-09-10')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('cal-day-2026-09-10')),
        matching: find.byKey(const Key('today-marker')),
      ),
      findsOneWidget,
    );
    await disposeApp(tester);
  });

  testWidgets('weekday header is Friday-first (AC-21)', (
    WidgetTester tester,
  ) async {
    await pumpAppWithDb(tester);

    final double friX = tester.getTopLeft(find.text('Fri')).dx;
    final double monX = tester.getTopLeft(find.text('Mon')).dx;
    final double thuX = tester.getTopLeft(find.text('Thu')).dx;
    expect(friX, lessThan(monX));
    expect(monX, lessThan(thuX));
    await disposeApp(tester);
  });

  testWidgets('month navigation works and Today returns home', (
    WidgetTester tester,
  ) async {
    await pumpAppWithDb(tester);

    await tester.tap(find.byKey(const Key('next-month')));
    await tester.pumpAndSettle();
    expect(find.text('October 2026'), findsOneWidget);
    expect(find.byKey(const Key('cal-day-2026-10-31')), findsOneWidget);

    await tester.tap(find.byKey(const Key('prev-month')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('prev-month')));
    await tester.pumpAndSettle();
    expect(find.text('August 2026'), findsOneWidget);

    await tester.tap(find.byKey(const Key('go-today')));
    await tester.pumpAndSettle();
    expect(find.text('September 2026'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('swipe navigation changes months (PRD §34)', (
    WidgetTester tester,
  ) async {
    await pumpAppWithDb(tester);

    // Fling left → next month.
    await tester.fling(
      find.byKey(const Key('calendar-swipe-area')),
      const Offset(-400, 0),
      1000,
    );
    await tester.pumpAndSettle();
    expect(find.text('October 2026'), findsOneWidget);

    // Fling right → previous month.
    await tester.fling(
      find.byKey(const Key('calendar-swipe-area')),
      const Offset(400, 0),
      1000,
    );
    await tester.pumpAndSettle();
    expect(find.text('September 2026'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('December to January rollover navigates across the year', (
    WidgetTester tester,
  ) async {
    await pumpAppWithDb(tester);

    // September → December 2026.
    for (int i = 0; i < 3; i++) {
      await tester.tap(find.byKey(const Key('next-month')));
      await tester.pumpAndSettle();
    }
    expect(find.text('December 2026'), findsOneWidget);
    expect(find.byKey(const Key('cal-day-2026-12-31')), findsOneWidget);

    // One more → January 2027.
    await tester.tap(find.byKey(const Key('next-month')));
    await tester.pumpAndSettle();
    expect(find.text('January 2027'), findsOneWidget);
    expect(find.byKey(const Key('cal-day-2027-01-31')), findsOneWidget);

    // And back over the boundary.
    await tester.tap(find.byKey(const Key('prev-month')));
    await tester.pumpAndSettle();
    expect(find.text('December 2026'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('attendance chips render from the database', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    final service = serviceFor(db);
    final studentA = await service.createStudent(
      name: 'Alpha One',
      weeklyDays: 3,
      routineWeekdays: monWedFri,
      color: '0xFF42A5F5',
      startDate: DateTime(2026, 8, 1),
    );
    final studentB = await service.createStudent(
      name: 'Bravo Two',
      weeklyDays: 3,
      routineWeekdays: monWedFri,
      color: '0xFFEF5350',
      startDate: DateTime(2026, 8, 1),
    );
    final DriftAttendanceRepository attendance = DriftAttendanceRepository(db);
    await attendance.add(
      studentId: studentA.id,
      attendanceDate: DateTime.utc(2026, 9, 9),
    );
    await attendance.add(
      studentId: studentB.id,
      attendanceDate: DateTime.utc(2026, 9, 9),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('cal-day-2026-09-09')),
        matching: find.text('Alpha'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('cal-day-2026-09-09')),
        matching: find.text('Bravo'),
      ),
      findsOneWidget,
    );
    // No attendance anywhere else yet.
    expect(find.text('+1 more'), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('tapping a date opens the date details screen', (
    WidgetTester tester,
  ) async {
    await pumpAppWithDb(tester);

    await tester.tap(find.byKey(const Key('cal-day-2026-09-09')));
    await tester.pumpAndSettle();

    expect(find.text('9 Sep 2026'), findsOneWidget);
    expect(find.text('No attendance recorded for this date'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('September 2026'), findsOneWidget);
    await disposeApp(tester);
  });
}
