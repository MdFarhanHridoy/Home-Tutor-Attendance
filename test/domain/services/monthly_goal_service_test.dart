import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/domain/entities/attendance_record.dart';
import 'package:home_tutor_attendance/domain/entities/routine_period.dart';
import 'package:home_tutor_attendance/domain/entities/student.dart';
import 'package:home_tutor_attendance/domain/entities/teaching_period.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';
import 'package:home_tutor_attendance/domain/services/monthly_goal_service.dart';

const List<Weekday> monWedFri = <Weekday>[
  Weekday.monday,
  Weekday.wednesday,
  Weekday.friday,
];

Student student(String id, String name) => Student(
  id: id,
  name: name,
  weeklyDays: 3,
  routineWeekdays: monWedFri,
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
  List<Weekday> weekdays,
) => RoutinePeriod(
  id: id,
  studentId: studentId,
  startDate: start,
  endDate: end,
  weeklyDays: weekdays.length,
  weekdays: weekdays,
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
      referenceDate: referenceDate ?? DateTime.utc(2026, 9, 15),
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

  test('rows are alphabetical by student name', () {
    final summaries = assemble(
      students: <Student>[student('s2', 'Zebra'), student('s1', 'Anna')],
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
          routine('r1', 's1', DateTime.utc(2026, 1, 1), null, monWedFri),
        ],
        's2': <RoutinePeriod>[
          routine('r2', 's2', DateTime.utc(2026, 1, 1), null, monWedFri),
        ],
      },
    );

    expect(summaries.first.students.map((s) => s.student.name), <String>[
      'Anna',
      'Zebra',
    ]);
  });

  test('scheduled days follow routine history (Aug M/W/F vs Sep T/Th)', () {
    final List<Weekday> tueThu = <Weekday>[Weekday.tuesday, Weekday.thursday];
    final summaries = assemble(
      students: <Student>[student('s1', 'Alpha')],
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
            monWedFri,
          ),
          routine('r2', 's1', DateTime.utc(2026, 9, 1), null, tueThu),
        ],
      },
    );

    final MonthGoalSummary september = summaries[0];
    final MonthGoalSummary august = summaries[1];
    // Sep 2026 Tue×5 + Thu×4 = 9; Aug 2026 Mon×5 + Wed×4 + Fri×4 = 13.
    expect(september.students.single.scheduledCount, 9);
    expect(august.students.single.scheduledCount, 13);
  });

  test('attendance counts unique dates and is never capped (12/10 → 120%)', () {
    final summaries = assemble(
      students: <Student>[student('s1', 'Alpha')],
      teachingPeriods: <String, List<TeachingPeriod>>{
        's1': <TeachingPeriod>[
          period(
            't1',
            's1',
            DateTime.utc(2026, 8, 1),
            DateTime.utc(2026, 9, 14),
          ),
        ],
      },
      routines: <String, List<RoutinePeriod>>{
        's1': <RoutinePeriod>[
          routine('r1', 's1', DateTime.utc(2026, 8, 1), null, monWedFri),
        ],
      },
      attendance: <AttendanceRecord>[
        for (int day = 1; day <= 12; day++)
          rec('s1', DateTime.utc(2026, 9, day)),
      ],
    );

    final StudentMonthGoal row = summaries.first.students.single;
    // Mon {7,14}=2, Wed {2,9}=2, Fri {4,11}=2 within Sep 1-14.
    expect(row.scheduledCount, 6);
    expect(row.attendedCount, 12);
    expect(row.percentage!.round(), 200);
  });

  test('zero scheduled shows null percentage (rendered as —, not 0%)', () {
    // Routine ends Aug 31; September has teaching gap but attendance exists.
    final summaries = assemble(
      students: <Student>[student('s1', 'Alpha')],
      teachingPeriods: <String, List<TeachingPeriod>>{
        's1': <TeachingPeriod>[
          period(
            't1',
            's1',
            DateTime.utc(2026, 8, 1),
            DateTime.utc(2026, 9, 30),
          ),
        ],
      },
      routines: <String, List<RoutinePeriod>>{
        's1': <RoutinePeriod>[
          routine(
            'r1',
            's1',
            DateTime.utc(2026, 8, 1),
            DateTime.utc(2026, 8, 31),
            monWedFri,
          ),
        ],
      },
      attendance: <AttendanceRecord>[rec('s1', DateTime.utc(2026, 9, 5))],
    );

    final StudentMonthGoal row = summaries.first.students.single;
    expect(row.scheduledCount, 0);
    expect(row.attendedCount, 1);
    expect(row.percentage, isNull);
    expect(summaries.first.overallPercentage, isNull);
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
            monWedFri,
          ),
        ],
      },
    );

    // Months: Sep, Aug, Jul, Jun, May, Apr.
    expect(summaries[0].students, isEmpty); // September — no overlap
    expect(summaries[1].students, isNotEmpty); // August
    expect(summaries[2].students, isNotEmpty); // July
    expect(summaries[3].students, isEmpty); // June
  });

  test('overall totals aggregate every visible student', () {
    final summaries = assemble(
      students: <Student>[student('s1', 'Alpha'), student('s2', 'Bravo')],
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
          routine('r1', 's1', DateTime.utc(2026, 1, 1), null, monWedFri),
        ],
        's2': <RoutinePeriod>[
          routine('r2', 's2', DateTime.utc(2026, 1, 1), null, monWedFri),
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
    // Both students: 13 scheduled each → 26 total; 3 attended.
    expect(september.totalScheduled, 26);
    expect(september.totalAttended, 3);
    expect(september.overallPercentage!.round(), 12); // 3/26 ≈ 11.5%
  });
}
