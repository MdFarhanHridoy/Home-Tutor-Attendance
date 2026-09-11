import 'dart:math' as math;

import '../../core/utils/date_util.dart';
import '../entities/attendance_record.dart';
import '../entities/routine_period.dart';
import '../entities/teaching_period.dart';
import 'routine_period_service.dart';
import 'teaching_period_service.dart';

/// Result of the weekly allowance computation for one student on one date.
class WeeklyAllowance {
  const WeeklyAllowance({
    required this.weeklyDays,
    required this.weekAllowance,
    required this.usedThisWeek,
    required this.carriedOver,
    this.routineId,
  });

  /// Base weekly cap of the routine effective on the date (0 = no routine).
  final int weeklyDays;

  /// Prorated base allowance for the current week: the ACTIVE days of the
  /// Friday–Thursday week (teaching-period coverage), capped at
  /// [weeklyDays] — see the service documentation for the user-approved
  /// refinement of Edge Case 13.
  final int weekAllowance;

  /// Attendance records in the whole current Friday–Thursday week
  /// (a week spanning a month boundary is a single allowance window,
  /// Edge Case 11).
  final int usedThisWeek;

  /// Unused allowance carried forward from earlier actively-taught weeks.
  /// Does not expire while the student remains active and does not reset at
  /// calendar-month boundaries; resets only when teaching stops (§10.6).
  final int carriedOver;

  final String? routineId;

  /// Total attendance days allowed in the current week (base + carry).
  int get maxAttendance => weekAllowance + carriedOver;

  /// Days still recordable this week; negative means already exceeded.
  int get remaining => maxAttendance - usedThisWeek;

  /// Whether one more attendance may be recorded (BR-10, AC-22).
  bool get canAddAttendance => remaining > 0;
}

/// Weekly attendance cap with carry-over recovery — the authoritative rule
/// of PRD §10.6 (v1.1), with one user-approved refinement:
///
/// - weeks run Friday → Thursday regardless of calendar months;
/// - `weekAllowance(week) = min(weekly_days, ACTIVE days in the week)` —
///   prorated by the days the student is actively being taught, on ANY
///   weekdays (the tutor may teach any N of the 7 days; refinement of
///   Edge Case 13 approved 2026-09-11, replacing routine-weekday-occurrence
///   proration which blocked a mid-week start on a non-routine weekday);
/// - dates outside the teaching period stay blocked via routine
///   effectiveness;
/// - `carryOver(next) = carryOver(current) + max(0, allowance - attended)`
///   for weeks the student was actively taught; carry never expires while
///   active and never resets at month boundaries;
/// - carry resets to 0 for weeks without active teaching (stop → reset,
///   re-activation starts fresh — Edge Case 12);
/// - `maxAttendance(week) = weekAllowance + carryOver`; the app must BLOCK
///   additions beyond it (Edge Case 14, AC-22);
/// - attendance on non-routine weekdays is allowed but consumes the
///   allowance (AC-10/AC-23).
class WeeklyAllowanceService {
  const WeeklyAllowanceService({
    RoutinePeriodService routinePeriodService = const RoutinePeriodService(),
    TeachingPeriodService teachingPeriodService = const TeachingPeriodService(),
  }) : _routines = routinePeriodService,
       _teachingPeriods = teachingPeriodService;

  final RoutinePeriodService _routines;
  final TeachingPeriodService _teachingPeriods;

  /// Start of the Friday-first week containing [date].
  DateTime weekStartOf(DateTime date) {
    final DateTime day = DateUtil.dateOnly(date);
    final int offset = (day.weekday - DateTime.friday + 7) % 7;
    return DateUtil.addDays(day, -offset);
  }

  /// Allowance for [date] given the student's full teaching/routine history
  /// and attendance records.
  WeeklyAllowance compute({
    required DateTime date,
    required List<TeachingPeriod> periods,
    required List<RoutinePeriod> routines,
    required List<AttendanceRecord> attendance,
  }) {
    final DateTime day = DateUtil.dateOnly(date);
    final RoutinePeriod? current = _routines.effectiveOn(routines, day);
    if (current == null) {
      return const WeeklyAllowance(
        weeklyDays: 0,
        weekAllowance: 0,
        usedThisWeek: 0,
        carriedOver: 0,
      );
    }

    final DateTime weekStart = weekStartOf(day);
    final DateTime weekEnd = DateUtil.addDays(weekStart, 6);
    final int usedThisWeek = _countInRange(attendance, weekStart, weekEnd);

    // Walk every completed week from the start of the student's history,
    // accumulating carry. Weeks without active teaching reset the carry.
    DateTime? earliest;
    for (final TeachingPeriod period in periods) {
      if (earliest == null || period.startDate.isBefore(earliest)) {
        earliest = period.startDate;
      }
    }
    for (final RoutinePeriod routine in routines) {
      if (earliest == null || routine.startDate.isBefore(earliest)) {
        earliest = routine.startDate;
      }
    }
    if (earliest == null) {
      return WeeklyAllowance(
        weeklyDays: current.weeklyDays,
        weekAllowance: 0,
        usedThisWeek: usedThisWeek,
        carriedOver: 0,
        routineId: current.id,
      );
    }

    int carry = 0;
    DateTime cursor = weekStartOf(earliest);
    while (cursor.isBefore(weekStart)) {
      final DateTime cursorEnd = DateUtil.addDays(cursor, 6);
      if (_activeDaysInWeek(cursor, cursorEnd, periods) > 0) {
        final RoutinePeriod? capRoutine = _routines.effectiveOn(
          routines,
          cursorEnd,
        );
        final int cap = capRoutine?.weeklyDays ?? current.weeklyDays;
        final int allowance = _weekAllowance(
          cursor,
          cursorEnd,
          cap,
          periods,
          routines,
        );
        final int used = _countInRange(attendance, cursor, cursorEnd);
        carry += math.max(0, allowance - used);
      } else {
        carry = 0; // teaching stopped — reset (Edge Case 12)
      }
      cursor = DateUtil.addDays(cursor, 7);
    }

    return WeeklyAllowance(
      weeklyDays: current.weeklyDays,
      weekAllowance: _weekAllowance(
        weekStart,
        weekEnd,
        current.weeklyDays,
        periods,
        routines,
      ),
      usedThisWeek: usedThisWeek,
      carriedOver: carry,
      routineId: current.id,
    );
  }

  /// Days of the week covered by a teaching period.
  int _activeDaysInWeek(
    DateTime weekStart,
    DateTime weekEnd,
    List<TeachingPeriod> periods,
  ) {
    int activeDays = 0;
    for (
      DateTime day = weekStart;
      !day.isAfter(weekEnd);
      day = DateUtil.addDays(day, 1)
    ) {
      final bool teaching = periods.any(
        (TeachingPeriod period) => _teachingPeriods.coversDate(period, day),
      );
      if (teaching) {
        activeDays++;
      }
    }
    return activeDays;
  }

  /// Prorated base allowance for the week: active days capped at [cap].
  ///
  /// The weekly cap is prorated by ACTIVE DAYS (user-approved refinement of
  /// PRD §10.6 / Edge 13, 2026-09-11): the tutor may teach any N of the 7
  /// weekdays, so a week where teaching starts or stops mid-week allows
  /// min(weeklyDays, active days) on ANY weekdays — never zero just because
  /// the routine's nominal weekdays fall outside the active part. Dates
  /// outside the teaching period remain blocked via routine effectiveness.
  int _weekAllowance(
    DateTime weekStart,
    DateTime weekEnd,
    int cap,
    List<TeachingPeriod> periods,
    List<RoutinePeriod> routines,
  ) {
    return math.min(cap, _activeDaysInWeek(weekStart, weekEnd, periods));
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
