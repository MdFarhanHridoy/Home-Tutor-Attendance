import 'package:flutter/material.dart';

void main() {
  runApp(const HomeTutorAttendanceApp());
}

/// Root widget of the Home Tutor Attendance application.
///
/// Phase 0 baseline: renders a minimal placeholder screen so that the project
/// builds, analyzes, tests, and packages into an APK before feature work
/// starts. The real app shell, dark theme, and navigation drawer are
/// implemented in Phase 1 (see docs/implementation.md).
class HomeTutorAttendanceApp extends StatelessWidget {
  const HomeTutorAttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Tutor Attendance',
      debugShowCheckedModeBanner: false,
      // Provisional dark look so the baseline APK matches the product's
      // dark-first direction. The full dark theme definition lands in Phase 1.
      theme: ThemeData.dark(),
      home: const _BaselineHomeScreen(),
    );
  }
}

class _BaselineHomeScreen extends StatelessWidget {
  const _BaselineHomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Home Tutor Attendance',
              key: Key('baseline-app-title'),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text('Baseline build — Phase 0'),
          ],
        ),
      ),
    );
  }
}
