import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/repositories/drift_routine_periods_repository.dart';
import 'package:home_tutor_attendance/data/repositories/drift_teaching_periods_repository.dart';
import 'package:home_tutor_attendance/domain/entities/teaching_period.dart';

import '../../helpers/students_app_harness.dart';

void main() {
  testWidgets('shows profile, status, and ongoing teaching history', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    final service = serviceFor(db);
    await service.createStudent(
      name: 'Student A',
      weeklyDays: 3,
      routineWeekdays: monWedFri,
      color: '0xFF42A5F5',
      startDate: DateTime(2026, 8, 1),
      phone: '01700000000',
    );
    await openStudents(tester);

    await tester.tap(find.text('Student A'));
    await tester.pumpAndSettle();

    expect(find.text('Student A'), findsWidgets); // app bar + headline
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('3 days per week'), findsOneWidget);
    expect(find.textContaining('Monday'), findsOneWidget);
    expect(find.textContaining('Phone: 01700000000'), findsOneWidget);

    // History sections live below the fold — scroll before asserting.
    await tester.scrollUntilVisible(
      find.text('Routine history'),
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('student-detail-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('ongoing'),
      findsNWidgets(2),
    ); // teaching + routine
    await disposeApp(tester);
  });

  testWidgets('stop teaching closes the period and preserves the student', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    final service = serviceFor(db);
    final student = await service.createStudent(
      name: 'Student A',
      weeklyDays: 3,
      routineWeekdays: monWedFri,
      color: '0xFF42A5F5',
      startDate: DateTime(2026, 8, 1),
    );
    await openStudents(tester);

    await tester.tap(find.text('Student A'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('stop-teaching')));
    await tester.pumpAndSettle();

    expect(find.text('Inactive'), findsWidgets);
    expect(find.textContaining('preserved'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Routine history'),
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('student-detail-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('ongoing'), findsNothing); // periods closed

    final List<TeachingPeriod> teaching = await DriftTeachingPeriodsRepository(
      db,
    ).forStudent(student.id);
    expect(teaching.single.isOpen, isFalse);

    // History preserved (PRD BR-08): routine history still lists the period.
    expect(
      await DriftRoutinePeriodsRepository(db).forStudent(student.id),
      hasLength(1),
    );
    await disposeApp(tester);
  });

  testWidgets('resume teaching opens a new period', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    final service = serviceFor(db);
    final student = await service.createStudent(
      name: 'Student A',
      weeklyDays: 3,
      routineWeekdays: monWedFri,
      color: '0xFF42A5F5',
      startDate: DateTime(2026, 8, 1),
    );
    await service.setCurrentlyTeaching(studentId: student.id, teaching: false);
    await openStudents(tester);

    // Inactive section on the list: header + tile trailing label.
    expect(find.text('Inactive'), findsNWidgets(2));
    await tester.tap(find.text('Student A'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('resume-teaching')));
    await tester.pumpAndSettle();

    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Inactive'), findsNothing);
    final List<TeachingPeriod> teaching = await DriftTeachingPeriodsRepository(
      db,
    ).forStudent(student.id);
    expect(teaching, hasLength(2)); // old closed + new open
    expect(teaching.last.isOpen, isTrue);
    await disposeApp(tester);
  });
}
