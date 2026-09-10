import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/domain/entities/teaching_period.dart';
import 'package:home_tutor_attendance/domain/entities/year_month.dart';
import 'package:home_tutor_attendance/domain/services/teaching_period_service.dart';

TeachingPeriod _period({required DateTime start, DateTime? end}) {
  return TeachingPeriod(
    id: 'tp1',
    studentId: 's1',
    startDate: start,
    endDate: end,
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  );
}

void main() {
  const TeachingPeriodService service = TeachingPeriodService();

  test('covers start and end dates inclusively', () {
    final TeachingPeriod period = _period(
      start: DateTime.utc(2026, 8, 1),
      end: DateTime.utc(2026, 8, 31),
    );

    expect(service.coversDate(period, DateTime.utc(2026, 8, 1)), isTrue);
    expect(service.coversDate(period, DateTime.utc(2026, 8, 31)), isTrue);
    expect(service.coversDate(period, DateTime.utc(2026, 7, 31)), isFalse);
    expect(service.coversDate(period, DateTime.utc(2026, 9, 1)), isFalse);
  });

  test('open period covers everything from its start date', () {
    final TeachingPeriod period = _period(start: DateTime.utc(2026, 8, 1));

    expect(service.coversDate(period, DateTime.utc(2026, 8, 1)), isTrue);
    expect(service.coversDate(period, DateTime.utc(2027, 3, 15)), isTrue);
    expect(service.coversDate(period, DateTime.utc(2026, 7, 31)), isFalse);
  });

  test('activeOn returns the covering period or null', () {
    final TeachingPeriod august = _period(
      start: DateTime.utc(2026, 8, 1),
      end: DateTime.utc(2026, 8, 31),
    );
    final TeachingPeriod november = _period(
      start: DateTime.utc(2026, 11, 1),
      end: DateTime.utc(2026, 11, 20),
    );

    expect(
      service.activeOn([august, november], DateTime.utc(2026, 8, 15)),
      august,
    );
    expect(
      service.activeOn([august, november], DateTime.utc(2026, 11, 20)),
      november,
    );
    expect(
      service.activeOn([august, november], DateTime.utc(2026, 9, 15)),
      isNull,
    );
  });

  test('multiple historical periods resolve independently', () {
    final TeachingPeriod first = _period(
      start: DateTime.utc(2026, 1, 1),
      end: DateTime.utc(2026, 3, 31),
    );
    final TeachingPeriod second = _period(start: DateTime.utc(2026, 6, 1));

    expect(service.activeOn([first, second], DateTime.utc(2026, 2, 10)), first);
    expect(service.activeOn([first, second], DateTime.utc(2026, 7, 1)), second);
    expect(
      service.activeOn([first, second], DateTime.utc(2026, 5, 31)),
      isNull,
    );
  });

  test('overlapsMonth handles boundary months', () {
    final TeachingPeriod period = _period(
      start: DateTime.utc(2026, 8, 15),
      end: DateTime.utc(2026, 9, 20),
    );

    expect(service.overlapsMonth(period, const YearMonth(2026, 8)), isTrue);
    expect(service.overlapsMonth(period, const YearMonth(2026, 9)), isTrue);
    expect(service.overlapsMonth(period, const YearMonth(2026, 7)), isFalse);
    expect(service.overlapsMonth(period, const YearMonth(2026, 10)), isFalse);
  });

  test('open period overlaps every later month', () {
    final TeachingPeriod period = _period(start: DateTime.utc(2026, 3, 4));

    expect(service.overlapsMonth(period, const YearMonth(2026, 3)), isTrue);
    expect(service.overlapsMonth(period, const YearMonth(2027, 12)), isTrue);
    expect(service.overlapsMonth(period, const YearMonth(2026, 2)), isFalse);
  });
}
