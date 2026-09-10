import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/domain/entities/routine_period.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';
import 'package:home_tutor_attendance/domain/services/routine_period_service.dart';

RoutinePeriod _routine({
  required DateTime start,
  DateTime? end,
  List<Weekday> weekdays = const [Weekday.monday],
}) {
  return RoutinePeriod(
    id: 'rp1',
    studentId: 's1',
    startDate: start,
    endDate: end,
    weeklyDays: weekdays.length,
    weekdays: weekdays,
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  );
}

void main() {
  const RoutinePeriodService service = RoutinePeriodService();

  test('effective before start date is null', () {
    final RoutinePeriod routine = _routine(start: DateTime.utc(2026, 9, 1));

    expect(service.effectiveOn([routine], DateTime.utc(2026, 8, 31)), isNull);
  });

  test('bounds are inclusive', () {
    final RoutinePeriod routine = _routine(
      start: DateTime.utc(2026, 8, 1),
      end: DateTime.utc(2026, 8, 31),
    );

    expect(service.effectiveOn([routine], DateTime.utc(2026, 8, 1)), routine);
    expect(service.effectiveOn([routine], DateTime.utc(2026, 8, 31)), routine);
    expect(service.effectiveOn([routine], DateTime.utc(2026, 9, 1)), isNull);
  });

  test('routine change resolves to the period effective on each date', () {
    final RoutinePeriod monRoutine = _routine(
      start: DateTime.utc(2026, 8, 1),
      end: DateTime.utc(2026, 8, 31),
      weekdays: const [Weekday.monday, Weekday.wednesday, Weekday.friday],
    );
    final RoutinePeriod tueRoutine = _routine(
      start: DateTime.utc(2026, 9, 1),
      weekdays: const [Weekday.tuesday, Weekday.thursday],
    );

    expect(
      service.effectiveOn([monRoutine, tueRoutine], DateTime.utc(2026, 8, 12)),
      monRoutine,
    );
    expect(
      service.effectiveOn([monRoutine, tueRoutine], DateTime.utc(2026, 9, 12)),
      tueRoutine,
    );
  });

  test('no routines yields null', () {
    expect(
      service.effectiveOn(const <RoutinePeriod>[], DateTime.utc(2026, 9, 1)),
      isNull,
    );
  });
}
