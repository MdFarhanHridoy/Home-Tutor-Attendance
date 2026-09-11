import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/repositories/drift_attendance_repository.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';

import '../../helpers/students_app_harness.dart';

/// Navigates Home → date 2026-09-09 via the calendar cell.
Future<void> openDateDetail(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('cal-day-2026-09-09')));
  await tester.pumpAndSettle();
}

void main() {
  Future<String> seedStudent(
    AppDatabase db, {
    required String name,
    int weeklyDays = 3,
    List<Weekday> weekdays = monWedFri,
  }) async {
    final student = await serviceFor(db).createStudent(
      name: name,
      weeklyDays: weeklyDays,
      routineWeekdays: weekdays,
      color: '0xFF42A5F5',
      startDate: DateTime(2026, 8, 1),
    );
    return student.id;
  }

  testWidgets('shows the empty state for a date without records', (
    WidgetTester tester,
  ) async {
    await pumpAppWithDb(tester);
    await openDateDetail(tester);

    expect(find.text('9 Sep 2026'), findsOneWidget);
    expect(find.text('No attendance recorded for this date'), findsOneWidget);
    expect(find.text('Tap + to record attendance'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('shows recorded students as colored bars', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    final String idA = await seedStudent(db, name: 'Alpha One');
    final String idB = await seedStudent(db, name: 'Bravo Two');
    final DriftAttendanceRepository attendance = DriftAttendanceRepository(db);
    // Insert out of order — display must sort alphabetically.
    await attendance.add(
      studentId: idB,
      attendanceDate: DateTime.utc(2026, 9, 9),
    );
    await attendance.add(
      studentId: idA,
      attendanceDate: DateTime.utc(2026, 9, 9),
    );
    await tester.pumpAndSettle();
    await openDateDetail(tester);

    expect(find.byKey(Key('attendance-card-$idA')), findsOneWidget);
    expect(find.byKey(Key('attendance-card-$idB')), findsOneWidget);
    final double alphaY = tester
        .getTopLeft(find.byKey(Key('attendance-card-$idA')))
        .dy;
    final double bravoY = tester
        .getTopLeft(find.byKey(Key('attendance-card-$idB')))
        .dy;
    expect(alphaY, lessThan(bravoY), reason: 'alphabetical order');
    await disposeApp(tester);
  });

  testWidgets('add via picker creates a card and updates the calendar chips', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    final String idA = await seedStudent(db, name: 'Alpha One');
    await openDateDetail(tester);

    await tester.tap(find.byKey(const Key('add-attendance-fab')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('student-picker')), findsOneWidget);
    expect(find.text('Alpha One'), findsOneWidget); // picker row
    expect(find.text('0 of 3 used this week'), findsOneWidget);

    await tester.tap(find.byKey(Key('picker-row-$idA')));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('attendance-card-$idA')), findsOneWidget);
    expect(find.text('Recorded Alpha One'), findsOneWidget); // snackbar

    // Close the sheet by tapping the modal barrier above it; the calendar
    // chip now shows for this date.
    await tester.tapAt(const Offset(400, 20));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute(); // back to calendar
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const Key('cal-day-2026-09-09')),
        matching: find.text('Alpha'),
      ),
      findsOneWidget,
    );
    await disposeApp(tester);
  });

  testWidgets('duplicate protection blocks re-adding the same student', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    final String idA = await seedStudent(db, name: 'Alpha One');
    await DriftAttendanceRepository(
      db,
    ).add(studentId: idA, attendanceDate: DateTime.utc(2026, 9, 9));
    await tester.pumpAndSettle();
    await openDateDetail(tester);

    await tester.tap(find.byKey(const Key('add-attendance-fab')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('picker-row-$idA')));
    await tester.pumpAndSettle();

    expect(
      find.text('Alpha One is already recorded on this date'),
      findsOneWidget,
    );
    expect(
      find.byKey(Key('attendance-card-$idA')),
      findsOneWidget,
    ); // still one
    expect(
      await DriftAttendanceRepository(db).forDate(DateTime.utc(2026, 9, 9)),
      hasLength(1),
    );
    await disposeApp(tester);
  });

  testWidgets('remove flow asks for confirmation and deletes the record', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    final String idA = await seedStudent(db, name: 'Alpha One');
    await DriftAttendanceRepository(
      db,
    ).add(studentId: idA, attendanceDate: DateTime.utc(2026, 9, 9));
    await tester.pumpAndSettle();
    await openDateDetail(tester);

    await tester.tap(find.byKey(Key('attendance-card-$idA')));
    await tester.pumpAndSettle();

    // Cancel first — nothing is removed.
    await tester.tap(find.byKey(const Key('cancel-remove')));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('attendance-card-$idA')), findsOneWidget);

    // Confirm — the record disappears.
    await tester.tap(find.byKey(Key('attendance-card-$idA')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-remove')));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('attendance-card-$idA')), findsNothing);
    expect(find.text('No attendance recorded for this date'), findsOneWidget);
    expect(
      await DriftAttendanceRepository(db).forDate(DateTime.utc(2026, 9, 9)),
      isEmpty,
    );
    await disposeApp(tester);
  });

  testWidgets('extra attendance beyond the routine asks for confirmation', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    // One day per week; Sep 9 (Wednesday) is not scheduled but allowed.
    final String idA = await seedStudent(
      db,
      name: 'Solo One',
      weeklyDays: 1,
      weekdays: const <Weekday>[Weekday.monday],
    );
    // Monday Sep 7 already used the weekly allowance.
    await DriftAttendanceRepository(
      db,
    ).add(studentId: idA, attendanceDate: DateTime.utc(2026, 9, 7));
    await tester.pumpAndSettle();
    await openDateDetail(tester);

    await tester.tap(find.byKey(const Key('add-attendance-fab')));
    await tester.pumpAndSettle();
    expect(find.text('1 of 1 used this week'), findsOneWidget);

    await tester.tap(find.byKey(Key('picker-row-$idA')));
    await tester.pumpAndSettle();

    expect(find.text('Extra attendance?'), findsOneWidget);

    await tester.tap(find.byKey(const Key('confirm-extra')));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('attendance-card-$idA')), findsOneWidget);
    expect(
      await DriftAttendanceRepository(db).forDate(DateTime.utc(2026, 9, 9)),
      hasLength(1),
    );
    await disposeApp(tester);
  });
}
