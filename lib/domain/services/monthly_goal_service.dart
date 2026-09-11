import '../entities/attendance_record.dart';
import '../entities/routine_period.dart';
import '../entities/student.dart';
import '../entities/teaching_period.dart';
import '../entities/year_month.dart';
import 'monthly_summary_service.dart';
import 'teaching_period_service.dart';

/// One student's row inside a month card of the goal screen.
class StudentMonthGoal {
  const StudentMonthGoal({
    required this.student,
    required this.attendedCount,
    required this.scheduledCount,
  });

  final Student student;
  final int attendedCount;

  /// Monthly target: `weekly_days × 4` (PRD v1.2 amendment) — a flat target
  /// for every month the student's teaching period overlaps, regardless of
  /// the start date within the month.
  final int scheduledCount;

  /// Attended ÷ target as a percentage; null when the target is 0
  /// (rendered as "—", never 0%).
  double? get percentage =>
      scheduledCount == 0 ? null : attendedCount / scheduledCount * 100;
}

/// One month of the six-month goal view (PRD §9.8, §44, v1.2 amendment).
class MonthGoalSummary {
  const MonthGoalSummary({required this.month, required this.students});

  final YearMonth month;
  final List<StudentMonthGoal> students;

  int get totalAttended =>
      students.fold(0, (int sum, StudentMonthGoal s) => sum + s.attendedCount);

  int get totalScheduled =>
      students.fold(0, (int sum, StudentMonthGoal s) => sum + s.scheduledCount);

  double? get overallPercentage =>
      totalScheduled == 0 ? null : totalAttended / totalScheduled * 100;
}

/// Assembles the six-month goal view from loaded data (PRD §9.8, v1.2).
///
/// Visibility rule (unchanged): a student appears in a month when any of
/// their teaching periods overlaps that month. Monthly target (v1.2):
/// `weekly_days × 4` from the routine period with the latest start date
/// that overlaps the month (falling back to the student's current
/// snapshot); the target does not prorate for mid-month starts. Actual
/// attendance counts unique dates and may exceed the target (14/12).
class MonthlyGoalService {
  const MonthlyGoalService({
    MonthlySummaryService summaryService = const MonthlySummaryService(),
    TeachingPeriodService teachingPeriodService = const TeachingPeriodService(),
  }) : _summaries = summaryService,
       _teachingPeriods = teachingPeriodService;

  final MonthlySummaryService _summaries;
  final TeachingPeriodService _teachingPeriods;

  /// Builds the six month summaries ending at [referenceDate]'s month,
  /// newest first. All inputs are pre-loaded by the caller.
  List<MonthGoalSummary> assemble({
    required DateTime referenceDate,
    required List<Student> students,
    required Map<String, List<TeachingPeriod>> teachingPeriods,
    required Map<String, List<RoutinePeriod>> routines,
    required List<AttendanceRecord> attendance,
  }) {
    final List<YearMonth> months = _summaries.lastSixMonths(referenceDate);

    return <MonthGoalSummary>[
      for (final YearMonth month in months)
        MonthGoalSummary(
          month: month,
          students:
              <StudentMonthGoal>[
                for (final Student student in students)
                  if (_overlapsMonth(
                    teachingPeriods[student.id] ?? const <TeachingPeriod>[],
                    month,
                  ))
                    StudentMonthGoal(
                      student: student,
                      attendedCount: _summaries.attendedCount(
                        attendance
                            .where(
                              (AttendanceRecord r) => r.studentId == student.id,
                            )
                            .toList(),
                        month,
                      ),
                      scheduledCount:
                          4 *
                          _weeklyDaysForMonth(
                            month,
                            routines[student.id] ?? const <RoutinePeriod>[],
                            student.weeklyDays,
                          ),
                    ),
              ]..sort(
                (StudentMonthGoal a, StudentMonthGoal b) =>
                    a.student.name.compareTo(b.student.name),
              ),
        ),
    ];
  }

  /// The weekly rate in effect for [month]: the routine period with the
  /// latest start date that overlaps the month (routine history), falling
  /// back to the student's current snapshot.
  int _weeklyDaysForMonth(
    YearMonth month,
    List<RoutinePeriod> history,
    int fallback,
  ) {
    RoutinePeriod? latest;
    for (final RoutinePeriod routine in history) {
      if (routine.startDate.isAfter(month.monthEnd)) {
        continue;
      }
      final DateTime? end = routine.endDate;
      if (end != null && end.isBefore(month.monthStart)) {
        continue;
      }
      if (latest == null || routine.startDate.isAfter(latest.startDate)) {
        latest = routine;
      }
    }
    return latest?.weeklyDays ?? fallback;
  }

  bool _overlapsMonth(List<TeachingPeriod> periods, YearMonth month) {
    return periods.any(
      (TeachingPeriod period) => _teachingPeriods.overlapsMonth(period, month),
    );
  }
}
