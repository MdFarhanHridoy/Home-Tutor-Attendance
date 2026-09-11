import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/domain/entities/attendance_record.dart';
import 'package:home_tutor_attendance/domain/entities/routine_period.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';
import 'package:home_tutor_attendance/domain/services/weekly_allowance_service.dart';

const List<Weekday> monWedFri = <Weekday>[
  Weekday.monday,
  Weekday.wednesday,
  Weekday.friday,
];

RoutinePeriod routine(
  String id,
  DateTime start, {
  DateTime? end,
  int weeklyDays = 3,
}) => RoutinePeriod(
  id: id,
  studentId: 's1',
  startDate: start,
  endDate: end,
  weeklyDays: weeklyDays,
  weekdays: monWedFri,
  createdAt: DateTime.utc(2026, 1, 1),
  updatedAt: DateTime.utc(2026, 1, 1),
);

AttendanceRecord record(DateTime date) => AttendanceRecord(
  id: 'a-${date.day}',
  studentId: 's1',
  attendanceDate: date,
  createdAt: DateTime.utc(2026, 9, 1),
  updatedAt: DateTime.utc(2026, 9, 1),
);

void main() {
  const WeeklyAllowanceService service = WeeklyAllowanceService();

  test('weeks run Friday to Thursday (BR-11)', () {
    // 2026-09-10 is a Thursday; its week starts Friday 2026-09-04.
    expect(
      service.weekStartOf(DateTime.utc(2026, 9, 10)),
      DateTime.utc(2026, 9, 4),
    );
    // 2026-09-04 is the Friday itself.
    expect(
      service.weekStartOf(DateTime.utc(2026, 9, 4)),
      DateTime.utc(2026, 9, 4),
    );
    // 2026-09-11 is the next Friday.
    expect(
      service.weekStartOf(DateTime.utc(2026, 9, 11)),
      DateTime.utc(2026, 9, 11),
    );
  });

  test('no effective routine yields zero allowance', () {
    final WeeklyAllowance allowance = service.compute(
      date: DateTime.utc(2026, 9, 10),
      routines: <RoutinePeriod>[
        routine('r1', DateTime.utc(2026, 8, 1), end: DateTime.utc(2026, 8, 31)),
      ],
      attendance: const <AttendanceRecord>[],
    );

    expect(allowance.weeklyDays, 0);
    expect(allowance.allowance, 0);
    expect(allowance.metRoutine, isFalse);
  });

  test('first week of a month has no carry', () {
    // Routine since August; querying in September's first week.
    final WeeklyAllowance allowance = service.compute(
      date: DateTime.utc(
        2026,
        9,
        4,
      ), // Friday, first day of a week fully in Sept
      routines: <RoutinePeriod>[routine('r1', DateTime.utc(2026, 8, 1))],
      attendance: const <AttendanceRecord>[],
    );

    expect(allowance.carriedOver, 0);
    expect(allowance.weeklyDays, 3);
    expect(allowance.remaining, 3);
  });

  test('unused days carry forward within the month', () {
    // Week of Sep 4-10: one record used (allowance 3) → carry 2 into
    // the week of Sep 11-17.
    final WeeklyAllowance allowance = service.compute(
      date: DateTime.utc(2026, 9, 15),
      routines: <RoutinePeriod>[routine('r1', DateTime.utc(2026, 8, 1))],
      attendance: <AttendanceRecord>[record(DateTime.utc(2026, 9, 7))],
    );

    expect(allowance.carriedOver, 2);
    expect(allowance.allowance, 5);
    expect(allowance.remaining, 5);
  });

  test('overuse never produces negative carry', () {
    // Week of Sep 4-10: five records (over the 3-day cap) → carry 0.
    final WeeklyAllowance allowance = service.compute(
      date: DateTime.utc(2026, 9, 15),
      routines: <RoutinePeriod>[routine('r1', DateTime.utc(2026, 8, 1))],
      attendance: <AttendanceRecord>[
        record(DateTime.utc(2026, 9, 4)),
        record(DateTime.utc(2026, 9, 5)),
        record(DateTime.utc(2026, 9, 6)),
        record(DateTime.utc(2026, 9, 7)),
        record(DateTime.utc(2026, 9, 8)),
      ],
    );

    expect(allowance.carriedOver, 0);
    expect(allowance.allowance, 3);
  });

  test('usedThisWeek counts only through the queried date', () {
    final WeeklyAllowance allowance = service.compute(
      date: DateTime.utc(2026, 9, 15), // Tuesday
      routines: <RoutinePeriod>[routine('r1', DateTime.utc(2026, 8, 1))],
      attendance: <AttendanceRecord>[
        record(DateTime.utc(2026, 9, 14)), // Monday — same week, counted
        record(DateTime.utc(2026, 9, 17)), // Thursday — same week, later
      ],
    );

    expect(allowance.usedThisWeek, 1);
  });

  test('routine change resets carried-over allowance', () {
    // One routine until Sep 10 with a single used day, then a NEW routine
    // from Sep 11 — carry must reset.
    final WeeklyAllowance allowance = service.compute(
      date: DateTime.utc(2026, 9, 15),
      routines: <RoutinePeriod>[
        routine('r1', DateTime.utc(2026, 8, 1), end: DateTime.utc(2026, 9, 10)),
        routine('r2', DateTime.utc(2026, 9, 11)),
      ],
      attendance: <AttendanceRecord>[record(DateTime.utc(2026, 9, 7))],
    );

    expect(allowance.carriedOver, 0);
    expect(allowance.routineId, 'r2');
    expect(allowance.allowance, 3);
  });

  test('teaching stop and resume resets carry (Edge Case 12)', () {
    final WeeklyAllowance allowance = service.compute(
      date: DateTime.utc(2026, 9, 15),
      routines: <RoutinePeriod>[
        routine('r1', DateTime.utc(2026, 8, 1), end: DateTime.utc(2026, 9, 6)),
        routine('r2', DateTime.utc(2026, 9, 13)),
      ],
      attendance: <AttendanceRecord>[record(DateTime.utc(2026, 9, 4))],
    );

    expect(allowance.carriedOver, 0);
    expect(allowance.routineId, 'r2');
  });

  test('metRoutine flags fulfilled routine for confirmation', () {
    final WeeklyAllowance met = service.compute(
      date: DateTime.utc(2026, 9, 8),
      routines: <RoutinePeriod>[routine('r1', DateTime.utc(2026, 8, 1))],
      attendance: <AttendanceRecord>[
        record(DateTime.utc(2026, 9, 4)),
        record(DateTime.utc(2026, 9, 5)),
        record(DateTime.utc(2026, 9, 6)),
      ],
    );
    expect(met.metRoutine, isTrue);
    expect(met.remaining, 0); // exactly fulfilled

    final WeeklyAllowance exceeded = service.compute(
      date: DateTime.utc(2026, 9, 8),
      routines: <RoutinePeriod>[routine('r1', DateTime.utc(2026, 8, 1))],
      attendance: <AttendanceRecord>[
        record(DateTime.utc(2026, 9, 4)),
        record(DateTime.utc(2026, 9, 5)),
        record(DateTime.utc(2026, 9, 6)),
        record(DateTime.utc(2026, 9, 7)),
      ],
    );
    expect(exceeded.metRoutine, isTrue);
    expect(exceeded.remaining, isNegative);

    final WeeklyAllowance notMet = service.compute(
      date: DateTime.utc(2026, 9, 8),
      routines: <RoutinePeriod>[routine('r1', DateTime.utc(2026, 8, 1))],
      attendance: <AttendanceRecord>[record(DateTime.utc(2026, 9, 4))],
    );
    expect(notMet.metRoutine, isFalse);
    expect(notMet.remaining, 2);
  });

  test('carry accumulates across multiple weeks within the month', () {
    // Week Sep 4-10: 0 used → carry 3. Week Sep 11-17: 1 used → carry
    // 3 + 3 - 1 = 5 into week Sep 18-24.
    final WeeklyAllowance allowance = service.compute(
      date: DateTime.utc(2026, 9, 22),
      routines: <RoutinePeriod>[routine('r1', DateTime.utc(2026, 8, 1))],
      attendance: <AttendanceRecord>[record(DateTime.utc(2026, 9, 14))],
    );

    expect(allowance.carriedOver, 5);
    expect(allowance.allowance, 8);
  });
}
