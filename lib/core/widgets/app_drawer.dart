import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';

/// The application's primary navigation drawer (PRD §9.4).
///
/// Shows the three primary destinations and highlights the current one.
/// The bottom area is reserved for a future theme toggle; Version 1 is
/// dark-only and deliberately shows no theme control (PRD v1.1, BR-12).
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.currentLocation});

  /// Matched location of the route this drawer is attached to, used to
  /// highlight the selected destination.
  final String currentLocation;

  static const List<(String, IconData, String)> _destinations =
      <(String, IconData, String)>[
        (AppRoutes.home, Icons.home_outlined, 'Home'),
        (AppRoutes.students, Icons.people_outline, 'Students List'),
        (
          AppRoutes.monthlyGoal,
          Icons.insights_outlined,
          'Monthly Attendance Goal',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'Home Tutor Attendance',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text('Offline attendance tracker'),
          ),
          const Divider(height: 1),
          for (final (String, IconData, String) destination in _destinations)
            ListTile(
              leading: Icon(destination.$2),
              title: Text(
                destination.$3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              selected: currentLocation == destination.$1,
              onTap: () => _handleDestinationSelected(context, destination.$1),
            ),
          // Reserved for the future theme toggle (PRD §9.4); intentionally
          // empty in Version 1.
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _handleDestinationSelected(BuildContext context, String target) {
    // Capture the router before closing the drawer; the drawer's context is
    // disposed once its route pops.
    final GoRouter router = GoRouter.of(context);
    Navigator.of(context).pop();
    if (target == AppRoutes.home) {
      // Home resets the navigation stack so back from Home exits the app.
      router.go(AppRoutes.home);
      return;
    }
    // Secondary destinations are pushed so Android system back returns to
    // where the user came from. Re-selecting the current destination must
    // not stack a duplicate route (implementation.md §1.5).
    if (currentLocation != target) {
      router.push(target);
    }
  }
}
