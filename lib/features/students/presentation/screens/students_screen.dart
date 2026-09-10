import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/widgets/app_drawer.dart';

/// Students List screen (PRD §9.5).
///
/// Student/tuition CRUD arrives in Phase 3; this placeholder establishes the
/// route, app bar, and drawer wiring.
class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key, this.currentLocation = AppRoutes.home});

  final String currentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      drawer: AppDrawer(currentLocation: currentLocation),
      body: const Center(child: Text('Student list will appear here.')),
    );
  }
}
