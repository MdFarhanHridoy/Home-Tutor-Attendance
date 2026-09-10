import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/settings/application/theme_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// Root widget of the Home Tutor Attendance application.
///
/// Wires the persisted theme mode into [MaterialApp] and mounts the go_router
/// configuration (three primary destinations, PRD §7/§8). Version 1 is
/// dark-only (PRD v1.1, BR-12); the light theme is future work.
class HomeTutorAttendanceApp extends ConsumerWidget {
  HomeTutorAttendanceApp({super.key, GoRouter? router})
    : _router = router ?? buildAppRouter();

  final GoRouter _router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ThemeMode> themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Home Tutor Attendance',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      darkTheme: appTheme,
      themeMode: themeMode.when(
        data: (ThemeMode mode) => mode,
        // Version 1 resolves every state to dark (PRD §19).
        loading: () => ThemeMode.dark,
        error: (Object _, StackTrace _) => ThemeMode.dark,
      ),
      routerConfig: _router,
    );
  }
}
