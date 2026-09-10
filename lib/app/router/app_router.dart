import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/calendar/presentation/screens/home_screen.dart';
import '../../features/monthly_goal/presentation/screens/monthly_goal_screen.dart';
import '../../features/students/presentation/screens/student_detail_screen.dart';
import '../../features/students/presentation/screens/student_form_screen.dart';
import '../../features/students/presentation/screens/students_screen.dart';

/// Named route paths for the primary destinations (PRD §7/§8).
abstract final class AppRoutes {
  static const String home = '/';
  static const String students = '/students';
  static const String studentNew = '/students/new';
  static String studentDetail(String id) => '/students/$id';
  static String studentEdit(String id) => '/students/$id/edit';
  static const String monthlyGoal = '/monthly-goal';
}

/// Builds the application's router configuration.
///
/// Route names stay stable while later phases replace screen builders.
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
        routes: <RouteBase>[
          // Must precede the parameterized ':id' route (go_router matches
          // routes in declaration order).
          GoRoute(
            path: 'new',
            name: 'student-new',
            builder: (BuildContext context, GoRouterState state) =>
                const StudentFormScreen.create(),
          ),
          GoRoute(
            path: ':id',
            name: 'student-detail',
            builder: (BuildContext context, GoRouterState state) =>
                StudentDetailScreen(studentId: state.pathParameters['id']!),
            routes: <RouteBase>[
              GoRoute(
                path: 'edit',
                name: 'student-edit',
                builder: (BuildContext context, GoRouterState state) =>
                    StudentFormScreen.edit(
                      studentId: state.pathParameters['id']!,
                    ),
              ),
            ],
          ),
        ],
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
