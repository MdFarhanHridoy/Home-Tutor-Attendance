import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/data/database/app_database.dart';

import '../../helpers/students_app_harness.dart';

Future<void> openAddForm(WidgetTester tester) async {
  await openStudents(tester);
  await tester.tap(find.byTooltip('Add student'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('cannot save without a name', (WidgetTester tester) async {
    await pumpAppWithDb(tester);
    await openAddForm(tester);

    await tester.tap(find.byKey(const Key('student-save-button')));
    await tester.pumpAndSettle();

    expect(find.text('Name is required'), findsOneWidget);
    // Still on the form; no student was created.
    expect(find.text('Add student'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('routine weekday selection is optional (v1.2)', (
    WidgetTester tester,
  ) async {
    await pumpAppWithDb(tester);
    await openAddForm(tester);

    // Deselect all default weekdays — saving must still be possible.
    await tester.tap(find.text('Mon'));
    await tester.pump();
    await tester.tap(find.text('Wed'));
    await tester.pump();
    await tester.tap(find.text('Fri'));
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('student-name-field')),
      'Any Day Student',
    );
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('student-save-button')))
          .enabled,
      isTrue,
    );

    await tester.tap(find.byKey(const Key('student-save-button')));
    await tester.pumpAndSettle();

    expect(find.text('Any Day Student'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('valid input creates the student and returns to the list', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    await openAddForm(tester);

    await tester.enterText(
      find.byKey(const Key('student-name-field')),
      'Test Student',
    );
    await tester.tap(find.byKey(const Key('student-save-button')));
    await tester.pumpAndSettle();

    expect(find.text('Test Student'), findsOneWidget);
    expect(await db.select(db.students).get(), hasLength(1));
    await disposeApp(tester);
  });

  testWidgets('editing prefills fields and saving updates the name', (
    WidgetTester tester,
  ) async {
    final AppDatabase db = await pumpAppWithDb(tester);
    final service = serviceFor(db);
    await service.createStudent(
      name: 'Original Name',
      weeklyDays: 3,
      routineWeekdays: monWedFri,
      color: '0xFF42A5F5',
      startDate: DateTime(2026, 8, 1),
    );
    await openStudents(tester);

    await tester.tap(find.text('Original Name'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('student-edit-button')));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'Original Name'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('student-name-field')),
      'Renamed Student',
    );
    await tester.tap(find.byKey(const Key('student-save-button')));
    await tester.pumpAndSettle();

    // Detail screen reflects the new name after returning.
    expect(find.text('Renamed Student'), findsWidgets);
    expect((await db.select(db.students).getSingle()).name, 'Renamed Student');
    await disposeApp(tester);
  });
}
