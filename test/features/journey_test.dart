import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/students_app_harness.dart';

/// Cross-feature journey (implementation.md §18 8.3): create a student,
/// record attendance, see the calendar chip, and see the goal row — all
/// through the real UI on one in-memory database.
void main() {
  testWidgets('create → record → calendar chip → goal row', (
    WidgetTester tester,
  ) async {
    await pumpAppWithDb(tester);

    // 1. Create a student through the form (default 3 days, M/W/F).
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Students List'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add student'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('student-name-field')),
      'Journey Student',
    );
    await tester.scrollUntilVisible(
      find.byKey(const Key('student-save-button')),
      250,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('student-form-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('student-save-button')));
    await tester.pumpAndSettle();
    expect(find.text('Journey Student'), findsOneWidget);

    // 2. Go to the calendar and open 2026-09-11 (the student starts
    //    "today" = 2026-09-10, so Sep 11 is the first recordable date).
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('cal-day-2026-09-11')));
    await tester.pumpAndSettle();

    // 3. Record attendance via the picker.
    await tester.tap(find.byKey(const Key('add-attendance-fab')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Journey Student').last);
    await tester.pumpAndSettle();
    expect(find.text('Recorded Journey Student'), findsOneWidget);

    // Close the sheet and return to the calendar — the chip is live.
    await tester.tapAt(const Offset(400, 20));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const Key('cal-day-2026-09-11')),
        matching: find.text('Journey'),
      ),
      findsOneWidget,
    );

    // 4. The six-month goal view shows the row for September.
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Monthly Attendance Goal'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('goal-month-2026-09')),
        matching: find.text('Journey Student'),
      ),
      findsOneWidget,
    );
    // Started Sep 10 with 3 days/week → flat monthly target 3 × 4 = 12
    // (v1.2). The single student's row and the month's overall header match.
    expect(
      find.descendant(
        of: find.byKey(const Key('goal-month-2026-09')),
        matching: find.text('1 / 12 · 8%'),
      ),
      findsWidgets,
    );
    await disposeApp(tester);
  });
}
