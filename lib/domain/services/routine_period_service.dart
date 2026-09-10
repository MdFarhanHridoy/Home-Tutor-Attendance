import '../entities/routine_period.dart';

/// Resolves which routine was effective for a student on a date
/// (Phase 2 task 2.8; implementation.md §5.3).
class RoutinePeriodService {
  const RoutinePeriodService();

  /// The routine period whose effective range covers [date]; the first match
  /// wins (periods are non-overlapping per student).
  RoutinePeriod? effectiveOn(List<RoutinePeriod> routines, DateTime date) {
    for (final RoutinePeriod routine in routines) {
      if (coversDate(routine, date)) {
        return routine;
      }
    }
    return null;
  }

  /// Whether [routine] covers [date] (inclusive bounds).
  bool coversDate(RoutinePeriod routine, DateTime date) {
    if (date.isBefore(routine.startDate)) {
      return false;
    }
    final DateTime? end = routine.endDate;
    return end == null || !date.isAfter(end);
  }
}
