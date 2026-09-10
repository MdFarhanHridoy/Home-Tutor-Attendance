import '../entities/attendance_record.dart';
import '../entities/routine_period.dart';
import '../entities/teaching_period.dart';
import '../entities/weekday.dart';
import '../entities/year_month.dart';
import 'scheduled_days_service.dart';

/// Per-student monthly attendance totals (PRD §13).
class StudentMonthlySummary {
  const StudentMonthlySummary({
    required this.studentId,
    required this.month,
    required this.attendedCount,
    required this.scheduledCount,
  });

  final String studentId;
  final YearMonth month;
  final int attendedCount;
  final int scheduledCount;

  /// Attended ÷ scheduled as a percentage; null when nothing was scheduled
  /// (division by zero is undefined rather than 0%, PRD §13.5).
  double? get percentage =>
      scheduledCount == 0 ? null : attendedCount / scheduledCount * 100;
}

/// Monthly attendance calculations (Phase 2 task 2.8; PRD §13, §44).
class MonthlySummaryService {
  const MonthlySummaryService({
    ScheduledDaysService scheduledDaysService = const ScheduledDaysService(),
  }) : _scheduledDays = scheduledDaysService;

  final ScheduledDaysService _scheduledDays;

  /// The last six consecutive calendar months ending at (and starting with)
  /// [referenceDate]'s month, newest first (PRD §9.8).
  List<YearMonth> lastSixMonths(DateTime referenceDate) {
    YearMonth current = YearMonth.fromDateTime(referenceDate);
    final List<YearMonth> months = <YearMonth>[current];
    for (int i = 0; i < 5; i++) {
      current = current.previous();
      months.add(current);
    }
    return months;
  }

  /// Counts unique attendance dates inside [month] (PRD §13.4: actual =
  /// unique attendance records in the month; attendance beyond the routine
  /// still counts and is never capped by scheduled days).
  int attendedCount(List<AttendanceRecord> attendance, YearMonth month) {
    final Set<DateTime> uniqueDates = <DateTime>{};
    for (final AttendanceRecord record in attendance) {
      if (month.contains(record.attendanceDate)) {
        uniqueDates.add(record.attendanceDate);
      }
    }
    return uniqueDates.length;
  }

  /// Builds one student's monthly summary for [month].
  StudentMonthlySummary summarize({
    required String studentId,
    required YearMonth month,
    required List<TeachingPeriod> periods,
    required List<RoutinePeriod> routines,
    required List<AttendanceRecord> attendance,
  }) {
    return StudentMonthlySummary(
      studentId: studentId,
      month: month,
      attendedCount: attendedCount(attendance, month),
      scheduledCount: _scheduledDays.scheduledCount(
        periods: periods,
        routines: routines,
        rangeStart: month.monthStart,
        rangeEnd: month.monthEnd,
      ),
    );
  }

  /// Weekday helper exposed for callers building routine-driven UI later.
  Weekday weekdayOf(DateTime date) => Weekday.fromDateTime(date);
}
