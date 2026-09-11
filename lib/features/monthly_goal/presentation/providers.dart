import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/providers.dart';
import '../../../../domain/entities/attendance_record.dart';
import '../../../../domain/entities/routine_period.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/entities/teaching_period.dart';
import '../../../../domain/services/monthly_goal_service.dart';
import '../../../../domain/services/monthly_summary_service.dart';
import '../../calendar/presentation/providers.dart';
import '../../students/presentation/providers.dart';

/// The six-month goal view, newest month first (PRD §9.8).
///
/// Recomputes when attendance changes (stream) or when students change
/// (the student stream rebuilds this provider). "Today" comes from the
/// injectable calendar provider so tests stay deterministic.
final monthlyGoalSummariesProvider = StreamProvider<List<MonthGoalSummary>>((
  Ref ref,
) {
  final DateTime today = ref.watch(calendarTodayProvider);
  // Watched for its rebuild side effect: profile/routine/status edits
  // must recompute scheduled counts.
  ref.watch(studentsStreamProvider);

  final months = const MonthlySummaryService().lastSixMonths(today);
  return ref
      .watch(attendanceRepositoryProvider)
      .watchBetween(months.last.monthStart, months.first.monthEnd)
      .asyncMap((List<AttendanceRecord> records) {
        return _assemble(ref, today, records);
      });
});

Future<List<MonthGoalSummary>> _assemble(
  Ref ref,
  DateTime today,
  List<AttendanceRecord> records,
) async {
  final List<Student> students = await ref
      .read(studentsRepositoryProvider)
      .findAll();
  final Map<String, List<TeachingPeriod>> teachingPeriods =
      <String, List<TeachingPeriod>>{};
  final Map<String, List<RoutinePeriod>> routines =
      <String, List<RoutinePeriod>>{};
  for (final Student student in students) {
    teachingPeriods[student.id] = await ref
        .read(teachingPeriodsRepositoryProvider)
        .forStudent(student.id);
    routines[student.id] = await ref
        .read(routinePeriodsRepositoryProvider)
        .forStudent(student.id);
  }
  return MonthlyGoalService().assemble(
    referenceDate: today,
    students: students,
    teachingPeriods: teachingPeriods,
    routines: routines,
    attendance: records,
  );
}
