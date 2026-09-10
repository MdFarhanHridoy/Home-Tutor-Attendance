import '../entities/teaching_period.dart';
import '../entities/year_month.dart';

/// Resolves which teaching period (if any) applies to a date (Phase 2 task
/// 2.8; PRD §13.2).
class TeachingPeriodService {
  const TeachingPeriodService();

  /// The period that covers [date]: `startDate <= date` and, when closed,
  /// `date <= endDate`. Periods are expected to be non-overlapping per
  /// student; the first match wins.
  TeachingPeriod? activeOn(List<TeachingPeriod> periods, DateTime date) {
    for (final TeachingPeriod period in periods) {
      if (coversDate(period, date)) {
        return period;
      }
    }
    return null;
  }

  /// Whether [period] covers [date] (inclusive bounds).
  bool coversDate(TeachingPeriod period, DateTime date) {
    if (date.isBefore(period.startDate)) {
      return false;
    }
    final DateTime? end = period.endDate;
    return end == null || !date.isAfter(end);
  }

  /// Whether [period] overlaps [month] at all (PRD §9.8 month-membership
  /// rule: activeFrom <= monthEnd AND (activeTo IS NULL OR activeTo >=
  /// monthStart)).
  bool overlapsMonth(TeachingPeriod period, YearMonth month) {
    if (period.startDate.isAfter(month.monthEnd)) {
      return false;
    }
    final DateTime? end = period.endDate;
    return end == null || !end.isBefore(month.monthStart);
  }
}
