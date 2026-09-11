import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/domain/entities/attendance_record.dart';
import 'package:home_tutor_attendance/domain/entities/routine_period.dart';
import 'package:home_tutor_attendance/domain/entities/teaching_period.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';
import 'package:home_tutor_attendance/domain/services/weekly_allowance_service.dart';

const List<Weekday> monWedFri = <Weekday>[
  Weekday.monday,
  Weekday.wednesday,
  Weekday.friday,
];

TeachingPeriod teaching(String id, DateTime start, {DateTime? end}) =>
    TeachingPeriod(
      id: id,
      studentId: 's1',
      startDate: start,
      endDate: end,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

RoutinePeriod routine(
  String id,
  DateTime start,
  DateTime? end, {
  int weeklyDays = 3,
  List<Weekday> weekdays = monWedFri,
}) => RoutinePeriod(
  id: id,
  studentId: 's1',
  startDate: start,
  endDate: end,
  weeklyDays: weeklyDays,
  weekdays: weekdays,
  createdAt: DateTime.utc(2026, 1, 1),
  updatedAt: DateTime.utc(2026, 1, 1),
);

AttendanceRecord record(DateTime date) => AttendanceRecord(
  id: 'a-${date.toIso8601String()}',
  studentId: 's1',
  attendanceDate: date,
  createdAt: DateTime.utc(2026, 9, 1),
  updatedAt: DateTime.utc(2026, 9, 1),
);

void main() {
  const WeeklyAllowanceService service = WeeklyAllowanceService();

  WeeklyAllowance compute({
    required DateTime date,
    List<TeachingPeriod> periods = const <TeachingPeriod>[],
    List<RoutinePeriod> routines = const <RoutinePeriod>[],
    List<AttendanceRecord> attendance = const <AttendanceRecord>[],
  }) {
    return service.compute(
      date: date,
      periods: periods,
      routines: routines,
      attendance: attendance,
    );
  }

  test('weeks run Friday to Thursday (BR-11)', () {
    // 2026-09-10 is a Thursday; its week starts Friday 2026-09-04.
    expect(
      service.weekStartOf(DateTime.utc(2026, 9, 10)),
      DateTime.utc(2026, 9, 4),
    );
    expect(
      service.weekStartOf(DateTime.utc(2026, 9, 4)),
      DateTime.utc(2026, 9, 4),
    );
    expect(
      service.weekStartOf(DateTime.utc(2026, 9, 11)),
      DateTime.utc(2026, 9, 11),
    );
  });

  test('no effective routine yields zero allowance', () {
    final allowance = compute(
      date: DateTime.utc(2026, 9, 10),
      periods: <TeachingPeriod>[
        teaching(
          't1',
          DateTime.utc(2026, 8, 1),
          end: DateTime.utc(2026, 8, 31),
        ),
      ],
      routines: <RoutinePeriod>[
        routine('r1', DateTime.utc(2026, 8, 1), DateTime.utc(2026, 8, 31)),
      ],
    );

    expect(allowance.weeklyDays, 0);
    expect(allowance.maxAttendance, 0);
    expect(allowance.canAddAttendance, isFalse);
  });

  test('first week of teaching has no carry', () {
    final allowance = compute(
      date: DateTime.utc(2026, 9, 8), // teaching starts Sep 7 (Monday)
      periods: <TeachingPeriod>[teaching('t1', DateTime.utc(2026, 9, 7))],
      routines: <RoutinePeriod>[routine('r1', DateTime.utc(2026, 9, 7), null)],
    );

    expect(allowance.carriedOver, 0);
    expect(allowance.weeklyDays, 3);
    // Active part of the week Sep 4-10 is Sep 7-10: Mon + Wed → prorated 2.
    expect(allowance.weekAllowance, 2);
    expect(allowance.maxAttendance, 2);
    expect(allowance.canAddAttendance, isTrue);
  });

  test('unused days carry forward to the following week (AC-23)', () {
    final allowance = compute(
      date: DateTime.utc(2026, 9, 15), // week Sep 11-17
      periods: <TeachingPeriod>[teaching('t1', DateTime.utc(2026, 9, 4))],
      routines: <RoutinePeriod>[routine('r1', DateTime.utc(2026, 9, 4), null)],
      attendance: <AttendanceRecord>[record(DateTime.utc(2026, 9, 7))],
    );

    // Week Sep 4-10: allowance 3, attended 1 → deficit 2 carried.
    expect(allowance.carriedOver, 2);
    expect(allowance.maxAttendance, 5);
    expect(allowance.remaining, 5);
  });

  test(
    'carry does not reset at calendar-month boundaries (Edge Case 11)',
    () async {
      // Teaching from Friday Aug 7, one Friday per week, no attendance:
      // every completed week accrues deficit 1.
      final allowance = compute(
        date: DateTime.utc(2026, 9, 8),
        periods: <TeachingPeriod>[teaching('t1', DateTime.utc(2026, 8, 7))],
        routines: <RoutinePeriod>[
          routine(
            'r1',
            DateTime.utc(2026, 8, 7),
            null,
            weeklyDays: 1,
            weekdays: const <Weekday>[Weekday.friday],
          ),
        ],
      );

      // Completed active weeks: Aug 7, 14, 21, 28 → carry 4 into September.
      expect(allowance.carriedOver, 4);
      expect(allowance.maxAttendance, 5);
    },
  );

  test('a week spanning a month boundary is one allowance window', () {
    // Records Aug 31 (Monday) and Sep 1 (Tuesday) belong to the same
    // Friday-first week (Aug 28 – Sep 3).
    final allowance = compute(
      date: DateTime.utc(2026, 9, 2),
      periods: <TeachingPeriod>[teaching('t1', DateTime.utc(2026, 8, 1))],
      routines: <RoutinePeriod>[routine('r1', DateTime.utc(2026, 8, 1), null)],
      attendance: <AttendanceRecord>[
        record(DateTime.utc(2026, 8, 31)),
        record(DateTime.utc(2026, 9, 1)),
      ],
    );

    expect(allowance.usedThisWeek, 2);
  });

  test('overuse never produces carry', () {
    final allowance = compute(
      date: DateTime.utc(2026, 9, 15),
      periods: <TeachingPeriod>[teaching('t1', DateTime.utc(2026, 9, 4))],
      routines: <RoutinePeriod>[routine('r1', DateTime.utc(2026, 9, 4), null)],
      attendance: <AttendanceRecord>[
        record(DateTime.utc(2026, 9, 4)),
        record(DateTime.utc(2026, 9, 5)),
        record(DateTime.utc(2026, 9, 6)),
        record(DateTime.utc(2026, 9, 7)),
        record(DateTime.utc(2026, 9, 8)),
      ],
    );

    expect(allowance.carriedOver, 0);
    expect(allowance.maxAttendance, 3);
  });

  test(
    'partial first week prorates to routine weekdays inside the active part',
    () {
      // Teaching starts Wednesday Sep 9; routine M/W/F. Active part of the
      // week Sep 4-10 is Sep 9-10 → only Wednesday qualifies → allowance 1.
      final allowance = compute(
        date: DateTime.utc(2026, 9, 10),
        periods: <TeachingPeriod>[teaching('t1', DateTime.utc(2026, 9, 9))],
        routines: <RoutinePeriod>[
          routine('r1', DateTime.utc(2026, 9, 9), null),
        ],
      );

      expect(allowance.weekAllowance, 1);
      expect(allowance.maxAttendance, 1);
    },
  );

  test(
    'stopping teaching resets carry; reactivation starts fresh (Edge 12)',
    () {
      final allowance = compute(
        date: DateTime.utc(2026, 9, 24),
        periods: <TeachingPeriod>[
          teaching(
            't1',
            DateTime.utc(2026, 8, 7),
            end: DateTime.utc(2026, 9, 4),
          ),
          teaching('t2', DateTime.utc(2026, 9, 18)),
        ],
        routines: <RoutinePeriod>[
          routine('r1', DateTime.utc(2026, 8, 7), DateTime.utc(2026, 9, 4)),
          routine('r2', DateTime.utc(2026, 9, 18), null),
        ],
        attendance: <AttendanceRecord>[record(DateTime.utc(2026, 8, 10))],
      );

      expect(allowance.carriedOver, 0);
      expect(allowance.routineId, 'r2');
    },
  );

  test('4th attendance without carry is blocked (AC-22)', () {
    final allowance = compute(
      date: DateTime.utc(2026, 9, 9),
      periods: <TeachingPeriod>[teaching('t1', DateTime.utc(2026, 9, 4))],
      routines: <RoutinePeriod>[routine('r1', DateTime.utc(2026, 9, 4), null)],
      attendance: <AttendanceRecord>[
        record(DateTime.utc(2026, 9, 4)),
        record(DateTime.utc(2026, 9, 7)),
        record(DateTime.utc(2026, 9, 8)),
      ],
    );

    expect(allowance.usedThisWeek, 3);
    expect(allowance.maxAttendance, 3);
    expect(allowance.canAddAttendance, isFalse);
  });

  test('non-routine weekday attendance consumes the allowance (AC-10)', () {
    // Routine M/W/F; records on Mon + Tue (Tue is non-routine) both count.
    final allowance = compute(
      date: DateTime.utc(2026, 9, 10),
      periods: <TeachingPeriod>[teaching('t1', DateTime.utc(2026, 9, 4))],
      routines: <RoutinePeriod>[routine('r1', DateTime.utc(2026, 9, 4), null)],
      attendance: <AttendanceRecord>[
        record(DateTime.utc(2026, 9, 7)), // Monday
        record(DateTime.utc(2026, 9, 8)), // Tuesday
      ],
    );

    expect(allowance.usedThisWeek, 2);
    expect(allowance.remaining, 1);
  });

  test('carry accumulates across multiple missed weeks (§10.6 example)', () {
    final allowance = compute(
      date: DateTime.utc(2026, 9, 18), // week Sep 18-24
      periods: <TeachingPeriod>[teaching('t1', DateTime.utc(2026, 9, 4))],
      routines: <RoutinePeriod>[routine('r1', DateTime.utc(2026, 9, 4), null)],
      attendance: <AttendanceRecord>[
        record(DateTime.utc(2026, 9, 7)), // week 1: 1 of 3
        record(DateTime.utc(2026, 9, 14)), // week 2: 1 of 3 (+2 carry)
      ],
    );

    // Week 1 deficit 2; week 2 allowance 5, used 1 → deficit 4.
    expect(allowance.carriedOver, 4);
    expect(allowance.maxAttendance, 7);
  });
}
