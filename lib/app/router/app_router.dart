import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/calendar/presentation/screens/home_screen.dart';
import '../../features/monthly_goal/presentation/screens/monthly_goal_screen.dart';
import '../../features/students/presentation/screens/students_screen.dart';

/// Named route paths for the three primary destinations (PRD §7/§8).
abstract final class AppRoutes {
  static const String home = '/';
  static const String students = '/students';
  static const String monthlyGoal = '/monthly-goal';
}

/// Builds the application's router configuration.
///
/// Phase 1 mounts placeholder screens behind stable route names so later
/// phases can replace screen builders without touching navigation.
GoRouter buildAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (BuildContext context, GoRouterState state) =>
            HomeScreen(currentLocation: state.matchedLocation),
      ),
      GoRoute(
        path: AppRoutes.students,
        name: 'students',
        builder: (BuildContext context, GoRouterState state) =>
            StudentsScreen(currentLocation: state.matchedLocation),
      ),
      GoRoute(
        path: AppRoutes.monthlyGoal,
        name: 'monthly-goal',
        builder: (BuildContext context, GoRouterState state) =>
            MonthlyGoalScreen(currentLocation: state.matchedLocation),
      ),
    ],
  );
}
