import '../entities/attendance_record.dart';
import '../entities/year_month.dart';

/// Monthly attendance calculations (PRD §13 as amended by v1.2).
class MonthlySummaryService {
  const MonthlySummaryService();

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
  /// unique attendance records in the month; attendance is never capped by
  /// the target — 14/12 displays as achieved over target).
  int attendedCount(List<AttendanceRecord> attendance, YearMonth month) {
    final Set<DateTime> uniqueDates = <DateTime>{};
    for (final AttendanceRecord record in attendance) {
      if (month.contains(record.attendanceDate)) {
        uniqueDates.add(record.attendanceDate);
      }
    }
    return uniqueDates.length;
  }
}
