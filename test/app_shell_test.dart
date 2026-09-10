import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/app/theme/app_theme.dart';

import 'helpers/app_harness.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await pumpAppWithDb(tester);
  }

  Future<void> openDrawer(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
  }

  /// Simulates the Android system back button.
  Future<void> systemBack(WidgetTester tester) async {
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
  }

  Finder drawerText(String text) =>
      find.descendant(of: find.byType(Drawer), matching: find.text(text));

  testWidgets('app opens on the Home route showing the current month (AC-01)', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(
      find.text('Home'),
      findsNothing,
    ); // AppBar shows the month, not 'Home'
    expect(find.text('September 2026'), findsOneWidget);
    expect(find.byKey(const Key('cal-day-2026-09-10')), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('drawer lists all primary destinations', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await openDrawer(tester);

    expect(drawerText('Home Tutor Attendance'), findsOneWidget);
    expect(drawerText('Home'), findsOneWidget);
    expect(drawerText('Students List'), findsOneWidget);
    expect(drawerText('Monthly Attendance Goal'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('tapping Students navigates to the Students screen', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await openDrawer(tester);

    await tester.tap(drawerText('Students List'));
    await tester.pumpAndSettle();

    expect(find.text('No students yet'), findsOneWidget);
    // Dispose the tree while the body runs so drift's stream cleanup timers
    // fire before the binding's pending-timer assertion.
    await disposeApp(tester);
  });

  testWidgets('Android back from a secondary screen returns Home', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await openDrawer(tester);
    await tester.tap(drawerText('Monthly Attendance Goal'));
    await tester.pumpAndSettle();
    expect(
      find.text('Six-month attendance summary will appear here.'),
      findsOneWidget,
    );

    await systemBack(tester);

    expect(find.text('September 2026'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('Home from a secondary screen resets the stack', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await openDrawer(tester);
    await tester.tap(drawerText('Students List'));
    await tester.pumpAndSettle();

    await openDrawer(tester);
    await tester.tap(drawerText('Home'));
    await tester.pumpAndSettle();

    expect(find.text('September 2026'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 30));
  });

  testWidgets(
    're-selecting the current destination does not stack duplicates',
    (WidgetTester tester) async {
      await pumpApp(tester);
      await openDrawer(tester);
      await tester.tap(drawerText('Students List'));
      await tester.pumpAndSettle();

      // Select the already-active destination again.
      await openDrawer(tester);
      await tester.tap(drawerText('Students List'));
      await tester.pumpAndSettle();
      expect(find.text('No students yet'), findsOneWidget);

      // A single back press must reach Home — no duplicated Students route.
      await systemBack(tester);
      await tester.pumpAndSettle();
      expect(find.text('September 2026'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 30));
    },
  );

  testWidgets('drawer highlights the current destination', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await openDrawer(tester);
    await tester.tap(drawerText('Students List'));
    await tester.pumpAndSettle();

    await openDrawer(tester);

    final ListTile studentsTile = tester.widget<ListTile>(
      find.ancestor(
        of: drawerText('Students List'),
        matching: find.byType(ListTile),
      ),
    );
    final ListTile homeTile = tester.widget<ListTile>(
      find.ancestor(of: drawerText('Home'), matching: find.byType(ListTile)),
    );
    expect(studentsTile.selected, isTrue);
    expect(homeTile.selected, isFalse);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 30));
  });

  testWidgets('app renders with the dark-only theme', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    final MaterialApp app = tester.widget<MaterialApp>(
      find.byType(MaterialApp),
    );
    expect(app.themeMode, ThemeMode.dark);
    expect(app.darkTheme?.brightness, Brightness.dark);
    expect(identical(app.theme, appTheme), isTrue);
    await disposeApp(tester);
  });
}
