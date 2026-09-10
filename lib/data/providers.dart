import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/app_settings_repository.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../domain/repositories/routine_periods_repository.dart';
import '../../domain/repositories/students_repository.dart';
import '../../domain/repositories/teaching_periods_repository.dart';
import 'database/app_database.dart';
import 'repositories/drift_app_settings_repository.dart';
import 'repositories/drift_attendance_repository.dart';
import 'repositories/drift_routine_periods_repository.dart';
import 'repositories/drift_students_repository.dart';
import 'repositories/drift_teaching_periods_repository.dart';

/// Single app-scoped database instance; closed with the container.
final Provider<AppDatabase> databaseProvider = Provider<AppDatabase>((Ref ref) {
  final AppDatabase db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final Provider<StudentsRepository> studentsRepositoryProvider =
    Provider<StudentsRepository>(
      (Ref ref) => DriftStudentsRepository(ref.watch(databaseProvider)),
    );

final Provider<TeachingPeriodsRepository> teachingPeriodsRepositoryProvider =
    Provider<TeachingPeriodsRepository>(
      (Ref ref) => DriftTeachingPeriodsRepository(ref.watch(databaseProvider)),
    );

final Provider<RoutinePeriodsRepository> routinePeriodsRepositoryProvider =
    Provider<RoutinePeriodsRepository>(
      (Ref ref) => DriftRoutinePeriodsRepository(ref.watch(databaseProvider)),
    );

final Provider<AttendanceRepository> attendanceRepositoryProvider =
    Provider<AttendanceRepository>(
      (Ref ref) => DriftAttendanceRepository(ref.watch(databaseProvider)),
    );

final Provider<AppSettingsRepository> appSettingsRepositoryProvider =
    Provider<AppSettingsRepository>(
      (Ref ref) => DriftAppSettingsRepository(ref.watch(databaseProvider)),
    );
