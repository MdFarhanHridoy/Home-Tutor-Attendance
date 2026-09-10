import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/domain/entities/routine_period.dart';
import 'package:home_tutor_attendance/domain/entities/teaching_period.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';
import 'package:home_tutor_attendance/domain/services/scheduled_days_service.dart';

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
  const ScheduledDaysService service = ScheduledDaysService();
  final DateTime septStart = DateTime.utc(2026, 9, 1);
  final DateTime septEnd = DateTime.utc(2026, 9, 30);
  const List<Weekday> monWedFri = <Weekday>[
    Weekday.monday,
    Weekday.wednesday,
    Weekday.friday,
  ];

  // September 2026: Mon x4, Wed x5, Fri x4.
  test('Mon/Wed/Fri routine yields real calendar occurrences (13, not 12)', () {
    final List<DateTime> dates = service.scheduledDates(
      periods: [_teaching(DateTime.utc(2026, 8, 1))],
      routines: [_routine(DateTime.utc(2026, 8, 1), weekdays: monWedFri)],
      rangeStart: septStart,
      rangeEnd: septEnd,
    );

    expect(dates.length, 13);
    expect(dates.first, DateTime.utc(2026, 9, 2)); // first Wednesday
    expect(dates.last, DateTime.utc(2026, 9, 30)); // last Wednesday
  });

  // September 2026 has five Wednesdays (2, 9, 16, 23, 30).
  test('five occurrences of a single weekday', () {
    final int count = service.scheduledCount(
      periods: [_teaching(DateTime.utc(2026, 1, 1))],
      routines: [
        _routine(DateTime.utc(2026, 1, 1), weekdays: const [Weekday.wednesday]),
      ],
      rangeStart: septStart,
      rangeEnd: septEnd,
    );

    expect(count, 5);
  });

  test('four occurrences month (Feb 2027 Tuesdays)', () {
    final int count = service.scheduledCount(
      periods: [_teaching(DateTime.utc(2026, 1, 1))],
      routines: [
        _routine(DateTime.utc(2026, 1, 1), weekdays: const [Weekday.tuesday]),
      ],
      rangeStart: DateTime.utc(2027, 2, 1),
      rangeEnd: DateTime.utc(2027, 2, 28),
    );

    expect(count, 4);
  });

  test('leap-year February 2028 includes Feb 29 (5 Tuesdays)', () {
    final List<DateTime> dates = service.scheduledDates(
      periods: [_teaching(DateTime.utc(2026, 1, 1))],
      routines: [
        _routine(DateTime.utc(2026, 1, 1), weekdays: const [Weekday.tuesday]),
      ],
      rangeStart: DateTime.utc(2028, 2, 1),
      rangeEnd: DateTime.utc(2028, 2, 29),
    );

    expect(dates.length, 5);
    expect(dates.contains(DateTime.utc(2028, 2, 29)), isTrue);
  });

  test(
    'student starting mid-month gets no scheduled days before the start',
    () {
      final int count = service.scheduledCount(
        periods: [_teaching(DateTime.utc(2026, 9, 10))],
        routines: [_routine(DateTime.utc(2026, 9, 10), weekdays: monWedFri)],
        rangeStart: septStart,
        rangeEnd: septEnd,
      );

      // Mon {14,21,28} + Wed {16,23,30} + Fri {11,18,25}.
      expect(count, 9);
    },
  );

  test('student stopping mid-month gets no scheduled days after the end', () {
    final int count = service.scheduledCount(
      periods: [
        _teaching(DateTime.utc(2026, 8, 1), end: DateTime.utc(2026, 9, 17)),
      ],
      routines: [_routine(DateTime.utc(2026, 8, 1), weekdays: monWedFri)],
      rangeStart: septStart,
      rangeEnd: septEnd,
    );

    // Mon {7,14} + Wed {2,9,16} + Fri {4,11}.
    expect(count, 7);
  });

  test('routine change mid-month uses the routine effective on each date', () {
    final int count = service.scheduledCount(
      periods: [_teaching(DateTime.utc(2026, 8, 1))],
      routines: [
        _routine(
          DateTime.utc(2026, 8, 1),
          end: DateTime.utc(2026, 9, 15),
          weekdays: const [Weekday.monday],
        ),
        _routine(DateTime.utc(2026, 9, 16), weekdays: const [Weekday.friday]),
      ],
      rangeStart: septStart,
      rangeEnd: septEnd,
    );

    // Mon {7,14} + Fri {18,25}.
    expect(count, 4);
  });

  test('no teaching period overlap yields zero scheduled days', () {
    final int count = service.scheduledCount(
      periods: [
        _teaching(DateTime.utc(2026, 8, 1), end: DateTime.utc(2026, 8, 31)),
      ],
      routines: [_routine(DateTime.utc(2026, 8, 1), weekdays: monWedFri)],
      rangeStart: septStart,
      rangeEnd: septEnd,
    );

    expect(count, 0);
  });

  test('no routine yields zero scheduled days', () {
    final int count = service.scheduledCount(
      periods: [_teaching(DateTime.utc(2026, 8, 1))],
      routines: const <RoutinePeriod>[],
      rangeStart: septStart,
      rangeEnd: septEnd,
    );

    expect(count, 0);
  });

  test('1 and 7 days per week extremes', () {
    final List<Weekday> all = Weekday.values;
    expect(
      service.scheduledCount(
        periods: [_teaching(DateTime.utc(2026, 8, 1))],
        routines: [_routine(DateTime.utc(2026, 8, 1), weekdays: all)],
        rangeStart: septStart,
        rangeEnd: septEnd,
      ),
      30,
    );
    expect(
      service.scheduledCount(
        periods: [_teaching(DateTime.utc(2026, 8, 1))],
        routines: [
          _routine(
            DateTime.utc(2026, 8, 1),
            weekdays: const [Weekday.saturday],
          ),
        ],
        rangeStart: septStart,
        rangeEnd: septEnd,
      ),
      4,
    );
  });
}
