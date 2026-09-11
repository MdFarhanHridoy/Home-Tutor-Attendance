import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/domain/entities/attendance_record.dart';
import 'package:home_tutor_attendance/domain/entities/routine_period.dart';
import 'package:home_tutor_attendance/domain/entities/student.dart';
import 'package:home_tutor_attendance/domain/entities/teaching_period.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';
import 'package:home_tutor_attendance/domain/services/monthly_goal_service.dart';

Student student(String id, String name, {int weeklyDays = 3}) => Student(
  id: id,
  name: name,
  weeklyDays: weeklyDays,
  routineWeekdays: const <Weekday>[],
  color: '0xFF42A5F5',
  currentlyTeaching: true,
  startDate: DateTime.utc(2026, 1, 1),
  createdAt: DateTime.utc(2026, 1, 1),
  updatedAt: DateTime.utc(2026, 1, 1),
);

TeachingPeriod period(
  String id,
  String studentId,
  DateTime start,
  DateTime? end,
) => TeachingPeriod(
  id: id,
  studentId: studentId,
  startDate: start,
  endDate: end,
  createdAt: DateTime.utc(2026, 1, 1),
  updatedAt: DateTime.utc(2026, 1, 1),
);

RoutinePeriod routine(
  String id,
  String studentId,
  DateTime start,
  DateTime? end,
  int weeklyDays,
) => RoutinePeriod(
  id: id,
  studentId: studentId,
  startDate: start,
  endDate: end,
  weeklyDays: weeklyDays,
  weekdays: const <Weekday>[],
  createdAt: DateTime.utc(2026, 1, 1),
  updatedAt: DateTime.utc(2026, 1, 1),
);

AttendanceRecord rec(String studentId, DateTime date) => AttendanceRecord(
  id: '$studentId-${date.toIso8601String()}',
  studentId: studentId,
  attendanceDate: date,
  createdAt: DateTime.utc(2026, 9, 1),
  updatedAt: DateTime.utc(2026, 9, 1),
);

void main() {
  const MonthlyGoalService service = MonthlyGoalService();
  final DateTime defaultDate = DateTime.utc(2026, 9, 15);

  List<MonthGoalSummary> assemble({
    DateTime? referenceDate,
    List<Student> students = const <Student>[],
    Map<String, List<TeachingPeriod>> teachingPeriods =
        const <String, List<TeachingPeriod>>{},
    Map<String, List<RoutinePeriod>> routines =
        const <String, List<RoutinePeriod>>{},
    List<AttendanceRecord> attendance = const <AttendanceRecord>[],
  }) {
    return service.assemble(
      referenceDate: referenceDate ?? defaultDate,
      students: students,
      teachingPeriods: teachingPeriods,
      routines: routines,
      attendance: attendance,
    );
  }

  test('returns six months, newest first', () {
    final summaries = assemble();

    expect(summaries.map((s) => s.month.toString()), <String>[
      '2026-09',
      '2026-08',
      '2026-07',
      '2026-06',
      '2026-05',
      '2026-04',
    ]);
  });

  test('monthly target is weeklyDays × 4 regardless of mid-month start', () {
    // The user case: start teaching Sep 9 with 3 days/week → September
    // target is still 12 (v1.2 flat target).
    final summaries = assemble(
      students: <Student>[student('s1', 'Alpha')],
      teachingPeriods: <String, List<TeachingPeriod>>{
        's1': <TeachingPeriod>[
          period('t1', 's1', DateTime.utc(2026, 9, 9), null),
        ],
      },
      routines: <String, List<RoutinePeriod>>{
        's1': <RoutinePeriod>[
          routine('r1', 's1', DateTime.utc(2026, 9, 9), null, 3),
        ],
      },
    );

    expect(summaries.first.students.single.scheduledCount, 12);
  });

  test('over-attendance displays uncapped: 14 / 12', () {
    final summaries = assemble(
      students: <Student>[student('s1', 'Alpha')],
      teachingPeriods: <String, List<TeachingPeriod>>{
        's1': <TeachingPeriod>[
          period('t1', 's1', DateTime.utc(2026, 8, 1), null),
        ],
      },
      routines: <String, List<RoutinePeriod>>{
        's1': <RoutinePeriod>[
          routine('r1', 's1', DateTime.utc(2026, 8, 1), null, 3),
        ],
      },
      attendance: <AttendanceRecord>[
        for (int day = 1; day <= 14; day++)
          rec('s1', DateTime.utc(2026, 9, day)),
      ],
    );

    final StudentMonthGoal row = summaries.first.students.single;
    expect(row.scheduledCount, 12);
    expect(row.attendedCount, 14);
    expect(row.percentage!.round(), 117);
  });

  test('target follows the routine history rate for the month', () {
    // Old routine 3/week through Aug, new routine 2/week from Sep 1:
    // August target 12, September target 8.
    final summaries = assemble(
      students: <Student>[student('s1', 'Alpha', weeklyDays: 2)],
      teachingPeriods: <String, List<TeachingPeriod>>{
        's1': <TeachingPeriod>[
          period('t1', 's1', DateTime.utc(2026, 8, 1), null),
        ],
      },
      routines: <String, List<RoutinePeriod>>{
        's1': <RoutinePeriod>[
          routine(
            'r1',
            's1',
            DateTime.utc(2026, 8, 1),
            DateTime.utc(2026, 8, 31),
            3,
          ),
          routine('r2', 's1', DateTime.utc(2026, 9, 1), null, 2),
        ],
      },
    );

    expect(summaries[0].students.single.scheduledCount, 8); // September
    expect(summaries[1].students.single.scheduledCount, 12); // August
  });

  test('student appears only in months their teaching period overlaps', () {
    final summaries = assemble(
      students: <Student>[student('s1', 'Alpha')],
      teachingPeriods: <String, List<TeachingPeriod>>{
        's1': <TeachingPeriod>[
          period(
            't1',
            's1',
            DateTime.utc(2026, 7, 10),
            DateTime.utc(2026, 8, 20),
          ),
        ],
      },
      routines: <String, List<RoutinePeriod>>{
        's1': <RoutinePeriod>[
          routine(
            'r1',
            's1',
            DateTime.utc(2026, 7, 10),
            DateTime.utc(2026, 8, 20),
            3,
          ),
        ],
      },
    );

    expect(summaries[0].students, isEmpty); // September
    expect(summaries[1].students, isNotEmpty); // August
    expect(summaries[2].students, isNotEmpty); // July
    expect(summaries[3].students, isEmpty); // June
  });

  test('overall totals aggregate every visible student', () {
    final summaries = assemble(
      students: <Student>[
        student('s1', 'Alpha'),
        student('s2', 'Bravo', weeklyDays: 2),
      ],
      teachingPeriods: <String, List<TeachingPeriod>>{
        's1': <TeachingPeriod>[
          period('t1', 's1', DateTime.utc(2026, 1, 1), null),
        ],
        's2': <TeachingPeriod>[
          period('t2', 's2', DateTime.utc(2026, 1, 1), null),
        ],
      },
      routines: <String, List<RoutinePeriod>>{
        's1': <RoutinePeriod>[
          routine('r1', 's1', DateTime.utc(2026, 1, 1), null, 3),
        ],
        's2': <RoutinePeriod>[
          routine('r2', 's2', DateTime.utc(2026, 1, 1), null, 2),
        ],
      },
      attendance: <AttendanceRecord>[
        rec('s1', DateTime.utc(2026, 9, 2)),
        rec('s1', DateTime.utc(2026, 9, 4)),
        rec('s2', DateTime.utc(2026, 9, 7)),
      ],
    );

    final MonthGoalSummary september = summaries.first;
    expect(september.students, hasLength(2));
    expect(september.totalScheduled, 20); // 12 + 8
    expect(september.totalAttended, 3);
  });
}
