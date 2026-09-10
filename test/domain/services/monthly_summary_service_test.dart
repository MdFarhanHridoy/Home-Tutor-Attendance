import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/domain/entities/attendance_record.dart';
import 'package:home_tutor_attendance/domain/entities/routine_period.dart';
import 'package:home_tutor_attendance/domain/entities/teaching_period.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';
import 'package:home_tutor_attendance/domain/entities/year_month.dart';
import 'package:home_tutor_attendance/domain/services/monthly_summary_service.dart';

AttendanceRecord _record(String id, DateTime date) => AttendanceRecord(
  id: id,
  studentId: 's1',
  attendanceDate: date,
  createdAt: DateTime.utc(2026, 9, 30),
  updatedAt: DateTime.utc(2026, 9, 30),
);

TeachingPeriod _teaching(DateTime start, {DateTime? end}) => TeachingPeriod(
  id: 'tp1',
  studentId: 's1',
  startDate: start,
  endDate: end,
  createdAt: DateTime.utc(2026, 1, 1),
  updatedAt: DateTime.utc(2026, 1, 1),
);

RoutinePeriod _routine(
  DateTime start, {
  DateTime? end,
  required List<Weekday> weekdays,
}) => RoutinePeriod(
  id: 'rp1',
  studentId: 's1',
  startDate: start,
  endDate: end,
  weeklyDays: weekdays.length,
  weekdays: weekdays,
  createdAt: DateTime.utc(2026, 1, 1),
  updatedAt: DateTime.utc(2026, 1, 1),
);

void main() {
  const MonthlySummaryService service = MonthlySummaryService();
  const List<Weekday> monWedFri = <Weekday>[
    Weekday.monday,
    Weekday.wednesday,
    Weekday.friday,
  ];

  test('attendedCount counts unique dates inside the month', () {
    final int count = service.attendedCount(<AttendanceRecord>[
      _record('a1', DateTime.utc(2026, 9, 2)),
      _record('a2', DateTime.utc(2026, 9, 9)),
      _record('a3', DateTime.utc(2026, 9, 9)), // same date — deduped
      _record('a4', DateTime.utc(2026, 8, 31)), // outside month
    ], const YearMonth(2026, 9));

    expect(count, 2);
  });

  test('summarize computes actual/scheduled/percentage (12/10 → 120%)', () {
    // Mon/Wed/Fri September 2026 with teaching ending Sep 17 → 7 scheduled.
    final StudentMonthlySummary summary = service.summarize(
      studentId: 's1',
      month: const YearMonth(2026, 9),
      periods: [
        _teaching(DateTime.utc(2026, 8, 1), end: DateTime.utc(2026, 9, 17)),
      ],
      routines: [_routine(DateTime.utc(2026, 8, 1), weekdays: monWedFri)],
      attendance: <AttendanceRecord>[
        _record('a1', DateTime.utc(2026, 9, 1)),
        _record('a2', DateTime.utc(2026, 9, 2)),
        _record('a3', DateTime.utc(2026, 9, 4)),
        _record('a4', DateTime.utc(2026, 9, 7)),
        _record('a5', DateTime.utc(2026, 9, 9)),
        _record('a6', DateTime.utc(2026, 9, 11)),
        _record('a7', DateTime.utc(2026, 9, 14)),
        _record('a8', DateTime.utc(2026, 9, 16)),
        _record('a9', DateTime.utc(2026, 9, 17)), // unscheduled extra day
      ],
    );

    expect(summary.attendedCount, 9);
    expect(summary.scheduledCount, 7);
    expect(summary.percentage, closeTo(9 / 7 * 100, 0.001));
  });

  test('attendance is never capped by scheduled days (12/10 case)', () {
    final StudentMonthlySummary summary = service.summarize(
      studentId: 's1',
      month: const YearMonth(2026, 9),
      periods: [
        _teaching(DateTime.utc(2026, 8, 1), end: DateTime.utc(2026, 9, 14)),
      ],
      routines: [_routine(DateTime.utc(2026, 8, 1), weekdays: monWedFri)],
      attendance: List<AttendanceRecord>.generate(
        12,
        (int i) => _record('a$i', DateTime.utc(2026, 9, i + 1)),
      ),
    );

    // Mon {7,14} + Wed {2,9,16→excluded>14} → Wed {2,9} + Fri {4,11} = 5? No:
    // range ends Sep 14, so Mon {7,14}=2, Wed {2,9}=2, Fri {4,11}=2 → 6.
    expect(summary.attendedCount, 12);
    expect(summary.scheduledCount, 6);
    expect(summary.percentage, closeTo(200.0, 0.001));
  });

  test('zero scheduled days yields null percentage, not 0%', () {
    final StudentMonthlySummary summary = service.summarize(
      studentId: 's1',
      month: const YearMonth(2026, 9),
      periods: [
        _teaching(DateTime.utc(2026, 8, 1), end: DateTime.utc(2026, 8, 31)),
      ],
      routines: [_routine(DateTime.utc(2026, 8, 1), weekdays: monWedFri)],
      attendance: const <AttendanceRecord>[],
    );

    expect(summary.scheduledCount, 0);
    expect(summary.attendedCount, 0);
    expect(summary.percentage, isNull);
  });

  test('routine change keeps history intact (Aug M/W/F vs Sep T/Th)', () {
    final List<Weekday> tueThu = <Weekday>[Weekday.tuesday, Weekday.thursday];

    final StudentMonthlySummary august = service.summarize(
      studentId: 's1',
      month: const YearMonth(2026, 8),
      periods: [_teaching(DateTime.utc(2026, 8, 1))],
      routines: [
        _routine(
          DateTime.utc(2026, 8, 1),
          end: DateTime.utc(2026, 8, 31),
          weekdays: monWedFri,
        ),
        _routine(DateTime.utc(2026, 9, 1), weekdays: tueThu),
      ],
      attendance: const <AttendanceRecord>[],
    );
    final StudentMonthlySummary september = service.summarize(
      studentId: 's1',
      month: const YearMonth(2026, 9),
      periods: [_teaching(DateTime.utc(2026, 8, 1))],
      routines: [
        _routine(
          DateTime.utc(2026, 8, 1),
          end: DateTime.utc(2026, 8, 31),
          weekdays: monWedFri,
        ),
        _routine(DateTime.utc(2026, 9, 1), weekdays: tueThu),
      ],
      attendance: const <AttendanceRecord>[],
    );

    // Aug 2026: Mon x5 + Wed x4 + Fri x4 = 13; Sep 2026: Tue x5 + Thu x4 = 9.
    expect(august.scheduledCount, 13);
    expect(september.scheduledCount, 9);
  });

  test('lastSixMonths returns six consecutive months, newest first', () {
    final List<YearMonth> months = service.lastSixMonths(
      DateTime.utc(2026, 9, 15),
    );

    expect(months, const <YearMonth>[
      YearMonth(2026, 9),
      YearMonth(2026, 8),
      YearMonth(2026, 7),
      YearMonth(2026, 6),
      YearMonth(2026, 5),
      YearMonth(2026, 4),
    ]);
  });

  test('lastSixMonths rolls over year boundaries', () {
    final List<YearMonth> months = service.lastSixMonths(
      DateTime.utc(2027, 2, 1),
    );

    expect(months.first, const YearMonth(2027, 2));
    expect(months.last, const YearMonth(2026, 9));
  });
}
