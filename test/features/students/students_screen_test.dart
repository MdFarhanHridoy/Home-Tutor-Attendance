import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';

import '../../helpers/students_app_harness.dart';

void main() {
  testWidgets('shows the empty state when there are no students', (
    WidgetTester tester,
  ) async {
    await pumpAppWithDb(tester);
    await openStudents(tester);

    expect(find.text('No students yet'), findsOneWidget);
    expect(find.text('Tap + to add your first student'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('lists active students first, inactive below, alphabetical', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    final service = serviceFor(db);
    for (final (String name, bool active) in <(String, bool)>[
      ('Zebra', true),
      ('Anna', false),
      ('Mira', true),
      ('Ben', false),
    ]) {
      await service.createStudent(
        name: name,
        weeklyDays: 3,
        routineWeekdays: monWedFri,
        color: '0xFF42A5F5',
        startDate: DateTime(2026, 8, 1),
      );
      if (!active) {
        final String id =
            await (db.select(db.students)
                  ..where(($StudentsTable tbl) => tbl.name.equals(name)))
                .getSingle()
                .then((StudentRow row) => row.id);
        await service.setCurrentlyTeaching(studentId: id, teaching: false);
      }
    }
    await openStudents(tester);

    expect(find.text('Currently teaching'), findsOneWidget);
    // Section header + per-tile trailing labels for the two inactive rows.
    expect(find.text('Inactive'), findsNWidgets(3));

    // Vertical order: active alphabetical, then inactive alphabetical.
    final double miraY = tester.getTopLeft(find.text('Mira')).dy;
    final double zebraY = tester.getTopLeft(find.text('Zebra')).dy;
    final double annaY = tester.getTopLeft(find.text('Anna')).dy;
    final double benY = tester.getTopLeft(find.text('Ben')).dy;
    expect(miraY < zebraY, isTrue, reason: 'Mira before Zebra (active, A-Z)');
    expect(zebraY < annaY, isTrue, reason: 'active section above inactive');
    expect(annaY < benY, isTrue, reason: 'Anna before Ben (inactive, A-Z)');
    await disposeApp(tester);
  });

  testWidgets('search is case-insensitive and matches partial names', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    final service = serviceFor(db);
    await service.createStudent(
      name: 'Student X',
      weeklyDays: 3,
      routineWeekdays: monWedFri,
      color: '0xFF42A5F5',
      startDate: DateTime(2026, 8, 1),
    );
    await service.createStudent(
      name: 'Rafiq',
      weeklyDays: 2,
      routineWeekdays: const <Weekday>[Weekday.tuesday, Weekday.thursday],
      color: '0xFFEF5350',
      startDate: DateTime(2026, 8, 1),
    );
    await openStudents(tester);

    await tester.enterText(
      find.byKey(const Key('students-search-field')),
      'stu',
    );
    await tester.pump();

    expect(find.text('Student X'), findsOneWidget);
    expect(find.text('Rafiq'), findsNothing);

    await tester.enterText(
      find.byKey(const Key('students-search-field')),
      'RAF',
    );
    await tester.pump();

    expect(find.text('Rafiq'), findsOneWidget);
    expect(find.text('Student X'), findsNothing);

    await tester.enterText(
      find.byKey(const Key('students-search-field')),
      'zz',
    );
    await tester.pump();

    expect(find.text('No students match your search'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('whitespace-only search shows all students', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    final service = serviceFor(db);
    await service.createStudent(
      name: 'Alpha',
      weeklyDays: 3,
      routineWeekdays: monWedFri,
      color: '0xFF42A5F5',
      startDate: DateTime(2026, 8, 1),
    );
    await openStudents(tester);

    await tester.enterText(
      find.byKey(const Key('students-search-field')),
      '   ',
    );
    await tester.pump();

    expect(find.text('Alpha'), findsOneWidget);
    await disposeApp(tester);
  });
}
