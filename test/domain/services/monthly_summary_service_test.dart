import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/domain/entities/attendance_record.dart';
import 'package:home_tutor_attendance/domain/entities/year_month.dart';
import 'package:home_tutor_attendance/domain/services/monthly_summary_service.dart';

AttendanceRecord _record(String id, DateTime date) => AttendanceRecord(
  id: id,
  studentId: 's1',
  attendanceDate: date,
  createdAt: DateTime.utc(2026, 9, 30),
  updatedAt: DateTime.utc(2026, 9, 30),
);

void main() {
  const MonthlySummaryService service = MonthlySummaryService();

  test('attendedCount counts unique dates inside the month', () {
    final int count = service.attendedCount(<AttendanceRecord>[
      _record('a1', DateTime.utc(2026, 9, 2)),
      _record('a2', DateTime.utc(2026, 9, 9)),
      _record('a3', DateTime.utc(2026, 9, 9)), // same date — deduped
      _record('a4', DateTime.utc(2026, 8, 31)), // outside month
    ], const YearMonth(2026, 9));

    expect(count, 2);
  });

  test('attendedCount is never capped (14 attended is 14)', () {
    final int count = service.attendedCount(
      List<AttendanceRecord>.generate(
        14,
        (int i) => _record('a$i', DateTime.utc(2026, 9, i + 1)),
      ),
      const YearMonth(2026, 9),
    );

    expect(count, 14);
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
