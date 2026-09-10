import '../../core/utils/date_util.dart';
import '../entities/routine_period.dart';
import '../entities/teaching_period.dart';
import '../entities/weekday.dart';
import 'routine_period_service.dart';
import 'teaching_period_service.dart';

/// Generates the scheduled (expected) teaching dates for a student within a
/// date range (Phase 2 task 2.8; PRD §10.4, §13).
///
/// A date is scheduled when BOTH:
///  1. a teaching period covers the date, and
///  2. the routine effective on that date includes the date's weekday.
///
/// The result is derived from real calendar dates — never `weeklyDays × 4`
/// shortcuts — so four- vs five-week months and leap Februaries fall out
/// naturally (PRD §52 Edge Cases 5–6).
class ScheduledDaysService {
  const ScheduledDaysService({
    TeachingPeriodService teachingPeriodService = const TeachingPeriodService(),
    RoutinePeriodService routinePeriodService = const RoutinePeriodService(),
  }) : _teachingPeriods = teachingPeriodService,
       _routines = routinePeriodService;

  final TeachingPeriodService _teachingPeriods;
  final RoutinePeriodService _routines;

  /// All scheduled dates in [rangeStart, rangeEnd] (inclusive), ascending.
  List<DateTime> scheduledDates({
    required List<TeachingPeriod> periods,
    required List<RoutinePeriod> routines,
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) {
    final List<DateTime> result = <DateTime>[];
    DateTime cursor = DateUtil.dateOnly(rangeStart);
    final DateTime end = DateUtil.dateOnly(rangeEnd);
    while (!cursor.isAfter(end)) {
      final bool teaching = periods.any(
        (TeachingPeriod period) => _teachingPeriods.coversDate(period, cursor),
      );
      if (teaching) {
        final RoutinePeriod? routine = _routines.effectiveOn(routines, cursor);
        if (routine != null &&
            routine.weekdays.contains(Weekday.fromDateTime(cursor))) {
          result.add(cursor);
        }
      }
      cursor = DateUtil.addDays(cursor, 1);
    }
    return result;
  }

  /// Number of scheduled dates in [rangeStart, rangeEnd] (inclusive).
  int scheduledCount({
    required List<TeachingPeriod> periods,
    required List<RoutinePeriod> routines,
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) {
    return scheduledDates(
      periods: periods,
      routines: routines,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
    ).length;
  }
}
