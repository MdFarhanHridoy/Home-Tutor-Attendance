import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/domain/entities/weekday.dart';

void main() {
  test('codes follow the PRD 0-6 Monday-first convention', () {
    expect(Weekday.monday.code, 0);
    expect(Weekday.sunday.code, 6);
  });

  test('fromCode round-trips every weekday', () {
    for (final Weekday weekday in Weekday.values) {
      expect(Weekday.fromCode(weekday.code), weekday);
    }
  });

  test('fromCode throws on invalid codes', () {
    expect(() => Weekday.fromCode(7), throwsArgumentError);
    expect(() => Weekday.fromCode(-1), throwsArgumentError);
  });

  test('fromDateTime maps DateTime.weekday correctly', () {
    // 2026-09-10 is a Thursday.
    expect(Weekday.fromDateTime(DateTime.utc(2026, 9, 10)), Weekday.thursday);
    // 2026-09-06 is a Sunday.
    expect(Weekday.fromDateTime(DateTime.utc(2026, 9, 6)), Weekday.sunday);
    // 2026-09-07 is a Monday.
    expect(Weekday.fromDateTime(DateTime.utc(2026, 9, 7)), Weekday.monday);
  });
}
