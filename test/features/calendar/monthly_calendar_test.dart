import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/app/theme/app_theme.dart';
import 'package:home_tutor_attendance/domain/entities/attendance_record.dart';
import 'package:home_tutor_attendance/domain/entities/student.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';
import 'package:home_tutor_attendance/domain/entities/year_month.dart';
import 'package:home_tutor_attendance/features/calendar/presentation/widgets/monthly_calendar.dart';

Student studentOf(String id, String name, String color) => Student(
  id: id,
  name: name,
  weeklyDays: 1,
  routineWeekdays: const <Weekday>[Weekday.monday],
  color: color,
  currentlyTeaching: true,
  startDate: DateTime.utc(2026, 1, 1),
  createdAt: DateTime.utc(2026, 1, 1),
  updatedAt: DateTime.utc(2026, 1, 1),
);

AttendanceRecord recordOf(String id, String studentId, DateTime date) =>
    AttendanceRecord(
      id: id,
      studentId: studentId,
      attendanceDate: date,
      createdAt: DateTime.utc(2026, 9, 1),
      updatedAt: DateTime.utc(2026, 9, 1),
    );

MonthlyCalendar calendarFor(YearMonth month, {DateTime? today}) =>
    MonthlyCalendar(
      month: month,
      today: today ?? month.monthStart,
      recordsByDate: const <DateTime, List<AttendanceRecord>>{},
      studentById: const <String, Student>{},
      onDateSelected: (DateTime _) {},
    );

void main() {
  test('weekday order is Friday-first (BR-11)', () {
    expect(MonthlyCalendar.weekOrder, <Weekday>[
      Weekday.friday,
      Weekday.saturday,
      Weekday.sunday,
      Weekday.monday,
      Weekday.tuesday,
      Weekday.wednesday,
      Weekday.thursday,
    ]);
  });

  test('September 2026 (starts Tuesday) offsets by four columns', () {
    final MonthlyCalendar calendar = calendarFor(const YearMonth(2026, 9));
    expect(calendar.leadingBlanks, 4); // Fri, Sat, Sun, Mon blank
    expect(calendar.rowCount, 5); // (4 + 30) / 7 rounded up
  });

  test('October 2026 (starts Thursday, 31 days) needs six rows', () {
    final MonthlyCalendar calendar = calendarFor(const YearMonth(2026, 10));
    expect(calendar.leadingBlanks, 6);
    expect(calendar.rowCount, 6);
  });

  test('leap-year February 2028 lays out 29 days in five rows', () {
    final MonthlyCalendar calendar = calendarFor(const YearMonth(2028, 2));
    expect(calendar.leadingBlanks, 4);
    expect(calendar.rowCount, 5);
  });

  testWidgets('weekday header renders left-to-right Fri…Thu (AC-21)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: Scaffold(
          body: SizedBox.expand(child: calendarFor(const YearMonth(2026, 9))),
        ),
      ),
    );

    final List<String> labels = <String>[
      'Fri',
      'Sat',
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
    ];
    double? previousX;
    for (final String label in labels) {
      final double x = tester.getTopLeft(find.text(label)).dx;
      if (previousX != null) {
        expect(x, greaterThan(previousX), reason: '$label must follow');
      }
      previousX = x;
    }
  });

  testWidgets('today is marked inside its own cell (AC-02)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: Scaffold(
          body: SizedBox.expand(
            child: calendarFor(
              const YearMonth(2026, 9),
              today: DateTime.utc(2026, 9, 10),
            ),
          ),
        ),
      ),
    );

    expect(
      find.descendant(
        of: find.byKey(const Key('cal-day-2026-09-10')),
        matching: find.byKey(const Key('today-marker')),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('cal-day-2026-09-11')),
        matching: find.byKey(const Key('today-marker')),
      ),
      findsNothing,
    );
  });

  testWidgets('out-of-month days render no cells', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: Scaffold(
          body: SizedBox.expand(child: calendarFor(const YearMonth(2026, 9))),
        ),
      ),
    );

    expect(find.byKey(const Key('cal-day-2026-08-31')), findsNothing);
    expect(find.byKey(const Key('cal-day-2026-10-01')), findsNothing);
    expect(find.byKey(const Key('cal-day-2026-09-01')), findsOneWidget);
    expect(find.byKey(const Key('cal-day-2026-09-30')), findsOneWidget);
  });

  testWidgets('attendance chips render colors with +N overflow', (
    WidgetTester tester,
  ) async {
    final DateTime date = DateTime.utc(2026, 9, 9);
    final MonthlyCalendar calendar = MonthlyCalendar(
      month: const YearMonth(2026, 9),
      today: DateTime.utc(2026, 9, 10),
      recordsByDate: <DateTime, List<AttendanceRecord>>{
        date: <AttendanceRecord>[
          recordOf('a1', 's1', date),
          recordOf('a2', 's2', date),
          recordOf('a3', 's3', date),
        ],
      },
      studentById: <String, Student>{
        's1': studentOf('s1', 'Alpha One', '0xFF42A5F5'),
        's2': studentOf('s2', 'Bravo Two', '0xFFEF5350'),
        's3': studentOf('s3', 'Charlie Three', '0xFF66BB6A'),
      },
      onDateSelected: (DateTime _) {},
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: Scaffold(body: SizedBox.expand(child: calendar)),
      ),
    );

    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Bravo'), findsOneWidget);
    expect(find.text('Charlie'), findsNothing); // behind the overflow
    expect(find.text('+1 more'), findsOneWidget);
  });

  testWidgets('tapping a cell reports its date', (WidgetTester tester) async {
    DateTime? selected;
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: Scaffold(
          body: SizedBox.expand(
            child: MonthlyCalendar(
              month: const YearMonth(2026, 9),
              today: DateTime.utc(2026, 9, 10),
              recordsByDate: const <DateTime, List<AttendanceRecord>>{},
              studentById: const <String, Student>{},
              onDateSelected: (DateTime date) => selected = date,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('cal-day-2026-09-23')));
    expect(selected, DateTime.utc(2026, 9, 23));
  });

  testWidgets('day cells expose screen-reader labels', (
    WidgetTester tester,
  ) async {
    final DateTime date = DateTime.utc(2026, 9, 9);
    final MonthlyCalendar calendar = MonthlyCalendar(
      month: const YearMonth(2026, 9),
      today: DateTime.utc(2026, 9, 10),
      recordsByDate: <DateTime, List<AttendanceRecord>>{
        date: <AttendanceRecord>[
          recordOf('a1', 's1', date),
          recordOf('a2', 's2', date),
        ],
      },
      studentById: const <String, Student>{},
      onDateSelected: (DateTime _) {},
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: Scaffold(body: SizedBox.expand(child: calendar)),
      ),
    );

    expect(
      find.bySemanticsLabel('9 Sep 2026, 2 students recorded'),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('10 Sep 2026, today'), findsOneWidget);
    expect(find.bySemanticsLabel('11 Sep 2026'), findsOneWidget);
  });
}
