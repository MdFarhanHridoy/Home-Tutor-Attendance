import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/widgets/app_drawer.dart';

/// Home is the monthly calendar (PRD §9.1) and always the initial route.
///
/// The Samsung-inspired calendar grid arrives in Phase 4; this placeholder
/// establishes the route, app bar, and drawer wiring.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.currentLocation = AppRoutes.home});

  final String currentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: AppDrawer(currentLocation: currentLocation),
      body: const Center(child: Text('Monthly calendar will appear here.')),
    );
  }
}
