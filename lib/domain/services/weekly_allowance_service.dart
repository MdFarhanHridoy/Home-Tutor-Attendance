import 'dart:math' as math;

import '../../core/utils/date_util.dart';
import '../entities/attendance_record.dart';
import '../entities/routine_period.dart';
import '../entities/year_month.dart';
import 'routine_period_service.dart';

/// Result of the weekly allowance computation for one student on one date.
class WeeklyAllowance {
  const WeeklyAllowance({
    required this.weeklyDays,
    required this.usedThisWeek,
    required this.carriedOver,
    this.routineId,
  });

  /// Base weekly cap from the routine effective on the date (0 = no routine).
  final int weeklyDays;

  /// Attendance records in the current week, up to and including the date.
  final int usedThisWeek;

  /// Unused allowance carried forward from earlier weeks of the same month
  /// (PRD §10.6); resets on routine/teaching changes and month boundaries.
  final int carriedOver;

  /// ID of the routine period the numbers were computed against.
  final String? routineId;

  /// Total slots currently available (base + carry).
  int get allowance => weeklyDays + carriedOver;

  /// Slots left; negative means the student already exceeded the routine.
  int get remaining => allowance - usedThisWeek;

  /// Whether the routine (including carry-over) is already fulfilled —
  /// adding more attendance requires the tutor's explicit confirmation.
  bool get metRoutine => usedThisWeek >= allowance && weeklyDays > 0;
}

/// Computes the weekly routine allowance with carry-over (PRD §10.6, BR-10).
///
/// Rules:
/// - weeks run Friday → Thursday (BR-11);
/// - the cap for a week is the weeklyDays of the routine effective on the
///   date, plus unused allowance carried from earlier weeks of the SAME
///   month;
/// - carry resets whenever the routine period changes or teaching stopped
///   for any intermediate week (Edge Case 12) — carry never crosses months;
/// - attendance beyond the cap is never blocked, only surfaced via
///   [WeeklyAllowance.metRoutine] so the UI can ask for confirmation.
class WeeklyAllowanceService {
  const WeeklyAllowanceService({
    RoutinePeriodService routinePeriodService = const RoutinePeriodService(),
  }) : _routines = routinePeriodService;

  final RoutinePeriodService _routines;

  /// Start of the Friday-first week containing [date].
  DateTime weekStartOf(DateTime date) {
    final DateTime day = DateUtil.dateOnly(date);
    final int offset = (day.weekday - DateTime.friday + 7) % 7;
    return DateUtil.addDays(day, -offset);
  }

  /// Allowance for [date] given the student's full routine history and
  /// attendance records of the surrounding month.
  WeeklyAllowance compute({
    required DateTime date,
    required List<RoutinePeriod> routines,
    required List<AttendanceRecord> attendance,
  }) {
    final DateTime day = DateUtil.dateOnly(date);
    final RoutinePeriod? current = _routines.effectiveOn(routines, day);
    if (current == null) {
      return const WeeklyAllowance(
        weeklyDays: 0,
        usedThisWeek: 0,
        carriedOver: 0,
      );
    }

    final DateTime currentWeekStart = weekStartOf(day);
    final DateTime monthStart = YearMonth.fromDateTime(day).monthStart;

    // Walk complete weeks of the month, earliest first. The partial week
    // containing the 1st may span the previous month — it never earns
    // carry (carry stays within the month, PRD §10.6).
    DateTime weekStart = weekStartOf(monthStart);
    if (weekStart.isBefore(monthStart)) {
      weekStart = DateUtil.addDays(weekStart, 7);
    }
    int carry = 0;
    while (weekStart.isBefore(currentWeekStart)) {
      final DateTime weekEnd = DateUtil.addDays(weekStart, 6);
      final RoutinePeriod? weekRoutine = _routines.effectiveOn(
        routines,
        weekEnd,
      );
      if (weekRoutine == null || weekRoutine.id != current.id) {
        // Teaching stopped or the routine changed — carry resets.
        carry = 0;
      } else {
        final int used = _countInRange(attendance, weekStart, weekEnd);
        carry = math.max(0, current.weeklyDays + carry - used);
      }
      weekStart = DateUtil.addDays(weekStart, 7);
    }

    final int usedThisWeek = _countInRange(attendance, currentWeekStart, day);
    return WeeklyAllowance(
      weeklyDays: current.weeklyDays,
      usedThisWeek: usedThisWeek,
      carriedOver: carry,
      routineId: current.id,
    );
  }

  int _countInRange(
    List<AttendanceRecord> attendance,
    DateTime start,
    DateTime end,
  ) {
    return attendance
        .where(
          (AttendanceRecord record) =>
              !record.attendanceDate.isBefore(start) &&
              !record.attendanceDate.isAfter(end),
        )
        .length;
  }
}
