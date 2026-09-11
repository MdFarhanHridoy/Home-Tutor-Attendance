import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/students_app_harness.dart';

/// Fresh-install regression (implementation.md §18 8.5): with an empty
/// database every screen renders its empty state instead of crashing.
void main() {
  testWidgets('all screens handle the empty database gracefully', (
    WidgetTester tester,
  ) async {
    await pumpAppWithDb(tester);

    // Home calendar renders an empty month grid.
    expect(find.text('September 2026'), findsOneWidget);
    expect(find.byKey(const Key('cal-day-2026-09-10')), findsOneWidget);

    // Students screen shows its empty state.
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Students List'));
    await tester.pumpAndSettle();
    expect(find.text('No students yet'), findsOneWidget);

    // Goal screen shows its empty state.
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Monthly Attendance Goal'));
    await tester.pumpAndSettle();
    expect(find.text('No attendance data yet'), findsOneWidget);

    // Date details show the empty state; the picker explains why it is empty.
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('cal-day-2026-09-12')));
    await tester.pumpAndSettle();
    expect(find.text('No attendance recorded for this date'), findsOneWidget);

    await tester.tap(find.byKey(const Key('add-attendance-fab')));
    await tester.pumpAndSettle();
    expect(
      find.text('No currently teaching students. Add students first.'),
      findsOneWidget,
    );
    await tester.tapAt(const Offset(400, 20));
    await tester.pumpAndSettle();
    await disposeApp(tester);
  });
}
