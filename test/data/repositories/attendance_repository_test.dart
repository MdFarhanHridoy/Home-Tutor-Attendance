import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/repositories/drift_attendance_repository.dart';
import 'package:home_tutor_attendance/domain/entities/attendance_record.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';
import 'package:home_tutor_attendance/domain/repositories/attendance_repository.dart';

void main() {
  late AppDatabase db;
  late DriftAttendanceRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftAttendanceRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedStudent(String id) async {
    await db
        .into(db.students)
        .insert(
          StudentsCompanion.insert(
            id: id,
            name: 'Student $id',
            weeklyDays: 3,
            routineWeekdays: const <Weekday>[
              Weekday.monday,
              Weekday.wednesday,
              Weekday.friday,
            ],
            color: '0xFF42A5F5',
            startDate: DateTime.utc(2026, 8, 1),
            createdAt: DateTime.utc(2026, 8, 1),
            updatedAt: DateTime.utc(2026, 8, 1),
          ),
        );
  }

  test('add normalizes dates to date-only values', () async {
    await seedStudent('s1');

    await repository.add(
      studentId: 's1',
      attendanceDate: DateTime.utc(2026, 9, 9, 18, 45), // time component
    );

    final List<AttendanceRecord> forDate = await repository.forDate(
      DateTime.utc(2026, 9, 9),
    );
    expect(forDate, hasLength(1));
    expect(forDate.first.attendanceDate, DateTime.utc(2026, 9, 9));
  });

  test('duplicate student+date throws DuplicateAttendanceException', () async {
    await seedStudent('s1');

    await repository.add(
      studentId: 's1',
      attendanceDate: DateTime.utc(2026, 9, 9),
    );

    expect(
      () => repository.add(
        studentId: 's1',
        attendanceDate: DateTime.utc(2026, 9, 9, 20, 0),
      ),
      throwsA(isA<DuplicateAttendanceException>()),
    );
    expect(
      await repository.countForStudentBetween(
        's1',
        DateTime.utc(2026, 9, 1),
        DateTime.utc(2026, 9, 30),
      ),
      1,
    );
  });

  test('multiple students can attend the same date', () async {
    await seedStudent('s1');
    await seedStudent('s2');

    await repository.add(
      studentId: 's2',
      attendanceDate: DateTime.utc(2026, 9, 9),
    );
    await repository.add(
      studentId: 's1',
      attendanceDate: DateTime.utc(2026, 9, 9),
    );
    await repository.add(
      studentId: 's1',
      attendanceDate: DateTime.utc(2026, 9, 10),
    );

    final List<AttendanceRecord> septNinth = await repository.forDate(
      DateTime.utc(2026, 9, 9),
    );
    expect(septNinth, hasLength(2));
    expect(septNinth.map((AttendanceRecord r) => r.studentId), <String>[
      's1',
      's2',
    ]);
  });

  test(
    'attendance outside the routine is accepted (no routine knowledge)',
    () async {
      await seedStudent('s1'); // routine says Mon/Wed/Fri

      // 2026-09-10 is a Thursday — not in the routine.
      final AttendanceRecord record = await repository.add(
        studentId: 's1',
        attendanceDate: DateTime.utc(2026, 9, 10),
      );

      expect(record.attendanceDate, DateTime.utc(2026, 9, 10));
    },
  );

  test('removeForStudentAndDate removes only the matching pair', () async {
    await seedStudent('s1');
    await seedStudent('s2');

    await repository.add(
      studentId: 's1',
      attendanceDate: DateTime.utc(2026, 9, 9),
    );
    await repository.add(
      studentId: 's2',
      attendanceDate: DateTime.utc(2026, 9, 9),
    );
    await repository.add(
      studentId: 's1',
      attendanceDate: DateTime.utc(2026, 9, 10),
    );

    await repository.removeForStudentAndDate('s1', DateTime.utc(2026, 9, 9));

    expect(
      await repository.forDate(DateTime.utc(2026, 9, 9)),
      hasLength(1),
    ); // s2 remains
    expect(
      await repository.forDate(DateTime.utc(2026, 9, 10)),
      hasLength(1),
    ); // s1 other date remains
  });

  test('removeById deletes a single record', () async {
    await seedStudent('s1');
    final AttendanceRecord record = await repository.add(
      studentId: 's1',
      attendanceDate: DateTime.utc(2026, 9, 9),
    );

    await repository.removeById(record.id);

    expect(await repository.forDate(DateTime.utc(2026, 9, 9)), isEmpty);
  });

  test(
    'forStudentBetween and count honor inclusive month boundaries',
    () async {
      await seedStudent('s1');

      await repository.add(
        studentId: 's1',
        attendanceDate: DateTime.utc(2026, 8, 31),
      );
      await repository.add(
        studentId: 's1',
        attendanceDate: DateTime.utc(2026, 9, 1),
      );
      await repository.add(
        studentId: 's1',
        attendanceDate: DateTime.utc(2026, 9, 30),
      );
      await repository.add(
        studentId: 's1',
        attendanceDate: DateTime.utc(2026, 10, 1),
      );

      final List<AttendanceRecord> september = await repository
          .forStudentBetween(
            's1',
            DateTime.utc(2026, 9, 1),
            DateTime.utc(2026, 9, 30),
          );
      expect(
        september.map((AttendanceRecord r) => r.attendanceDate),
        <DateTime>[DateTime.utc(2026, 9, 1), DateTime.utc(2026, 9, 30)],
      );
      expect(
        await repository.countForStudentBetween(
          's1',
          DateTime.utc(2026, 9, 1),
          DateTime.utc(2026, 9, 30),
        ),
        2,
      );
    },
  );

  test('watchForDate emits current records', () async {
    await seedStudent('s1');
    await repository.add(
      studentId: 's1',
      attendanceDate: DateTime.utc(2026, 9, 9),
    );

    final List<AttendanceRecord> first = await repository
        .watchForDate(DateTime.utc(2026, 9, 9))
        .first;

    expect(first, hasLength(1));
    expect(first.first.studentId, 's1');
  });
}
