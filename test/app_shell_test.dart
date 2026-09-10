import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:home_tutor_attendance/app/app.dart';
import 'package:home_tutor_attendance/app/router/app_router.dart';
import 'package:home_tutor_attendance/app/theme/app_theme.dart';
import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/providers.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    SharedPreferences.setMockInitialValues(const <String, Object>{
      'app_settings.theme_mode': 'dark',
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWith((Ref ref) => db)],
        child: HomeTutorAttendanceApp(router: buildAppRouter()),
      ),
    );
    await tester.pumpAndSettle();
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

  testWidgets('app opens on the Home route', (WidgetTester tester) async {
    await pumpApp(tester);

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Monthly calendar will appear here.'), findsOneWidget);
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
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 30));
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

    expect(find.text('Monthly calendar will appear here.'), findsOneWidget);
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

    expect(find.text('Monthly calendar will appear here.'), findsOneWidget);
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
      expect(find.text('Monthly calendar will appear here.'), findsOneWidget);
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
  });
}
