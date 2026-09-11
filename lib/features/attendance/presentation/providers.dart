import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/providers.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../domain/entities/attendance_record.dart';
import '../../../../domain/services/attendance_workflow_service.dart';

/// Live attendance records for a date (keyed by ISO date string).
final attendanceForDateProvider =
    StreamProvider.family<List<AttendanceRecord>, String>((
      Ref ref,
      String isoDate,
    ) {
      return ref
          .watch(attendanceRepositoryProvider)
          .watchForDate(DateUtil.fromIsoDate(isoDate));
    });

/// Use-case service for the attendance workflow.
final attendanceWorkflowServiceProvider = Provider<AttendanceWorkflowService>((
  Ref ref,
) {
  return AttendanceWorkflowService(
    studentsRepository: ref.watch(studentsRepositoryProvider),
    teachingPeriodsRepository: ref.watch(teachingPeriodsRepositoryProvider),
    routinePeriodsRepository: ref.watch(routinePeriodsRepositoryProvider),
    attendanceRepository: ref.watch(attendanceRepositoryProvider),
  );
});
