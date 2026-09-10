import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/main.dart';

void main() {
  testWidgets('baseline app renders its title', (WidgetTester tester) async {
    await tester.pumpWidget(const HomeTutorAttendanceApp());

    expect(find.byKey(const Key('baseline-app-title')), findsOneWidget);
    expect(find.text('Baseline build — Phase 0'), findsOneWidget);
  });

  testWidgets('baseline app uses a dark theme', (WidgetTester tester) async {
    await tester.pumpWidget(const HomeTutorAttendanceApp());

    final MaterialApp app = tester.widget<MaterialApp>(
      find.byType(MaterialApp),
    );
    expect(app.theme?.brightness, Brightness.dark);
  });
}
