import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/widgets/app_drawer.dart';

/// Monthly Attendance Goal screen (PRD §9.8).
///
/// The six-month summary arrives in Phase 6; this placeholder establishes the
/// route, app bar, and drawer wiring.
class MonthlyGoalScreen extends StatelessWidget {
  const MonthlyGoalScreen({super.key, this.currentLocation = AppRoutes.home});

  final String currentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Attendance Goal')),
      drawer: AppDrawer(currentLocation: currentLocation),
      body: const Center(
        child: Text('Six-month attendance summary will appear here.'),
      ),
    );
  }
}
