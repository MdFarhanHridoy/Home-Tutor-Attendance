import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/data/database/app_database.dart';

import '../../helpers/students_app_harness.dart';

/// The form's scrollable — found via the keyed ListView so TextField-internal
/// scrollables can never be picked by mistake.
Finder get formScrollable => find
    .descendant(
      of: find.byKey(const Key('student-form-scroll')),
      matching: find.byType(Scrollable),
    )
    .first;

Future<void> openAddForm(WidgetTester tester) async {
  await openStudents(tester);
  await tester.tap(find.byTooltip('Add student'));
  await tester.pumpAndSettle();
}

/// The save button sits at the bottom of the lazy ListView — build and
/// reveal it before interacting.
Future<void> scrollToSave(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.byKey(const Key('student-save-button')),
    250,
    scrollable: formScrollable,
  );
  await tester.pumpAndSettle();
}

Future<void> scrollUpTo(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(target, -250, scrollable: formScrollable);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('cannot save without a name', (WidgetTester tester) async {
    await pumpAppWithDb(tester);
    await openAddForm(tester);
    await scrollToSave(tester);

    await tester.tap(find.byKey(const Key('student-save-button')));
    await tester.pump();
    await scrollUpTo(tester, find.byKey(const Key('student-name-field')));

    expect(find.text('Name is required'), findsOneWidget);
    // Still on the form; no student was created.
    expect(find.text('Add student'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('AC-09: save is blocked until exactly N weekdays are selected', (
    WidgetTester tester,
  ) async {
    await pumpAppWithDb(tester);
    await openAddForm(tester);

    // Deselect Wednesday → 2 of 3 selected → hint updates.
    await tester.tap(find.text('Wed'));
    await tester.pump();
    expect(find.textContaining('2 selected'), findsOneWidget);

    await scrollToSave(tester);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('student-save-button')))
          .enabled,
      isFalse,
    );

    // Scroll back up, reselect Wednesday → valid again.
    await scrollUpTo(tester, find.byKey(const Key('weekday-hint')));
    await tester.tap(find.text('Wed'));
    await tester.pump();

    await scrollToSave(tester);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('student-save-button')))
          .enabled,
      isTrue,
    );
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
    await scrollToSave(tester);
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
    await scrollToSave(tester);
    await tester.tap(find.byKey(const Key('student-save-button')));
    await tester.pumpAndSettle();

    // Detail screen reflects the new name after returning.
    expect(find.text('Renamed Student'), findsWidgets);
    expect((await db.select(db.students).getSingle()).name, 'Renamed Student');
    await disposeApp(tester);
  });
}
