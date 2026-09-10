import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'features/settings/application/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ProviderContainer container = ProviderContainer();
  // Warm the persisted theme so the first frame already uses the stored mode
  // (no theme flash on startup). Version 1 is dark-only; see docs/PRD.md §19.
  await container.read(themeModeProvider.future);
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: HomeTutorAttendanceApp(),
    ),
  );
}
