import '../../core/utils/date_util.dart';
import '../entities/attendance_record.dart';
import '../entities/routine_period.dart';
import '../entities/student.dart';
import '../entities/teaching_period.dart';
import '../entities/year_month.dart';
import 'monthly_summary_service.dart';
import 'scheduled_days_service.dart';
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
  final int scheduledCount;

  /// Attended ÷ scheduled as a percentage; null when nothing was scheduled
  /// (rendered as "—", never 0%) (PRD §13.5).
  double? get percentage =>
      scheduledCount == 0 ? null : attendedCount / scheduledCount * 100;
}

/// One month of the six-month goal view (PRD §9.8, §44).
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

/// Assembles the six-month goal view from loaded data (PRD §9.8).
///
/// Visibility rule: a student appears in a month when any of their teaching
/// periods overlaps that month (activeFrom <= monthEnd AND (activeTo IS NULL
/// OR activeTo >= monthStart)) — inactive students therefore keep appearing
/// in historical months. Scheduled days come from the routine effective on
/// each date (history never rewritten), and actual attendance counts unique
/// dates, uncapped by the schedule.
class MonthlyGoalService {
  const MonthlyGoalService({
    MonthlySummaryService summaryService = const MonthlySummaryService(),
    TeachingPeriodService teachingPeriodService = const TeachingPeriodService(),
    ScheduledDaysService scheduledDaysService = const ScheduledDaysService(),
  }) : _summaries = summaryService,
       _teachingPeriods = teachingPeriodService,
       _scheduledDays = scheduledDaysService;

  final MonthlySummaryService _summaries;
  final TeachingPeriodService _teachingPeriods;
  final ScheduledDaysService _scheduledDays;

  /// Builds the six month summaries ending at [referenceDate]'s month,
  /// newest first. All inputs are pre-loaded by the caller.
  List<MonthGoalSummary> assemble({
    required DateTime referenceDate,
    required List<Student> students,
    required Map<String, List<TeachingPeriod>> teachingPeriods,
    required Map<String, List<RoutinePeriod>> routines,
    required List<AttendanceRecord> attendance,
  }) {
    final List<YearMonth> months = _summaries.lastSixMonths(
      DateUtil.dateOnly(referenceDate),
    );

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
                      scheduledCount: _scheduledDays.scheduledCount(
                        periods:
                            teachingPeriods[student.id] ??
                            const <TeachingPeriod>[],
                        routines:
                            routines[student.id] ?? const <RoutinePeriod>[],
                        rangeStart: month.monthStart,
                        rangeEnd: month.monthEnd,
                      ),
                    ),
              ]..sort(
                (StudentMonthGoal a, StudentMonthGoal b) =>
                    a.student.name.compareTo(b.student.name),
              ),
        ),
    ];
  }

  bool _overlapsMonth(List<TeachingPeriod> periods, YearMonth month) {
    return periods.any(
      (TeachingPeriod period) => _teachingPeriods.overlapsMonth(period, month),
    );
  }
}
