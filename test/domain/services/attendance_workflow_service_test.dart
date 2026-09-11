import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/repositories/drift_attendance_repository.dart';
import 'package:home_tutor_attendance/data/repositories/drift_routine_periods_repository.dart';
import 'package:home_tutor_attendance/data/repositories/drift_students_repository.dart';
import 'package:home_tutor_attendance/data/repositories/drift_teaching_periods_repository.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';
import 'package:home_tutor_attendance/domain/repositories/attendance_repository.dart';
import 'package:home_tutor_attendance/domain/services/attendance_workflow_service.dart';
import 'package:home_tutor_attendance/domain/services/student_management_service.dart';

void main() {
  late AppDatabase db;
  late AttendanceWorkflowService service;
  late StudentManagementService students;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    service = AttendanceWorkflowService(
      studentsRepository: DriftStudentsRepository(db),
      routinePeriodsRepository: DriftRoutinePeriodsRepository(db),
      attendanceRepository: DriftAttendanceRepository(db),
    );
    students = StudentManagementService(
      studentsRepository: DriftStudentsRepository(db),
      teachingPeriodsRepository: DriftTeachingPeriodsRepository(db),
      routinePeriodsRepository: DriftRoutinePeriodsRepository(db),
    );
  });

  tearDown(() async {
    await db.close();
  });

  const List<Weekday> monWedFri = <Weekday>[
    Weekday.monday,
    Weekday.wednesday,
    Weekday.friday,
  ];

  test(
    'picker candidates list teaching students alphabetically with status',
    () async {
      final studentB = await students.createStudent(
        name: 'Bravo',
        weeklyDays: 3,
        routineWeekdays: monWedFri,
        color: '0xFFEF5350',
        startDate: DateTime.utc(2026, 8, 1),
      );
      final studentA = await students.createStudent(
        name: 'Alpha',
        weeklyDays: 2,
        routineWeekdays: const <Weekday>[Weekday.tuesday, Weekday.thursday],
        color: '0xFF42A5F5',
        startDate: DateTime.utc(2026, 8, 1),
      );
      // Deactivate a third student — must not appear.
      final studentC = await students.createStudent(
        name: 'Charlie',
        weeklyDays: 1,
        routineWeekdays: const <Weekday>[Weekday.saturday],
        color: '0xFF66BB6A',
        startDate: DateTime.utc(2026, 8, 1),
      );
      await students.setCurrentlyTeaching(
        studentId: studentC.id,
        teaching: false,
      );

      // One record for Bravo earlier in the queried week.
      await DriftAttendanceRepository(
        db,
      ).add(studentId: studentB.id, attendanceDate: DateTime.utc(2026, 9, 7));

      final candidates = await service.pickerCandidatesForDate(
        DateTime.utc(2026, 9, 9),
      );

      expect(candidates.map((c) => c.student.name), <String>['Alpha', 'Bravo']);
      final alpha = candidates.firstWhere((c) => c.student.id == studentA.id);
      final bravo = candidates.firstWhere((c) => c.student.id == studentB.id);
      expect(alpha.recorded, isFalse);
      expect(alpha.allowance.weeklyDays, 2);
      expect(bravo.allowance.usedThisWeek, 1); // Sep 7 is in the same week
      expect(bravo.recorded, isFalse); // Sep 7 != Sep 9
    },
  );

  test('recorded flag reflects the queried date only', () async {
    final student = await students.createStudent(
      name: 'Alpha',
      weeklyDays: 3,
      routineWeekdays: monWedFri,
      color: '0xFF42A5F5',
      startDate: DateTime.utc(2026, 8, 1),
    );
    await service.addAttendance(
      studentId: student.id,
      date: DateTime.utc(2026, 9, 9),
    );

    final sameDay = await service.pickerCandidatesForDate(
      DateTime.utc(2026, 9, 9),
    );
    final otherDay = await service.pickerCandidatesForDate(
      DateTime.utc(2026, 9, 10),
    );

    expect(sameDay.single.recorded, isTrue);
    expect(otherDay.single.recorded, isFalse);
    expect(otherDay.single.allowance.usedThisWeek, 1);
  });

  test('addAttendance enforces duplicates via the domain guard', () async {
    final student = await students.createStudent(
      name: 'Alpha',
      weeklyDays: 3,
      routineWeekdays: monWedFri,
      color: '0xFF42A5F5',
      startDate: DateTime.utc(2026, 8, 1),
    );

    await service.addAttendance(
      studentId: student.id,
      date: DateTime.utc(2026, 9, 9),
    );
    expect(
      () => service.addAttendance(
        studentId: student.id,
        date: DateTime.utc(2026, 9, 9),
      ),
      throwsA(isA<DuplicateAttendanceException>()),
    );
  });

  test('removeAttendance deletes the record', () async {
    final student = await students.createStudent(
      name: 'Alpha',
      weeklyDays: 3,
      routineWeekdays: monWedFri,
      color: '0xFF42A5F5',
      startDate: DateTime.utc(2026, 8, 1),
    );
    final record = await service.addAttendance(
      studentId: student.id,
      date: DateTime.utc(2026, 9, 9),
    );

    await service.removeAttendance(record.id);

    expect(
      await DriftAttendanceRepository(db).forDate(DateTime.utc(2026, 9, 9)),
      isEmpty,
    );
  });

  test('between returns month records of all students sorted', () async {
    final studentA = await students.createStudent(
      name: 'Alpha',
      weeklyDays: 3,
      routineWeekdays: monWedFri,
      color: '0xFF42A5F5',
      startDate: DateTime.utc(2026, 8, 1),
    );
    final studentB = await students.createStudent(
      name: 'Bravo',
      weeklyDays: 3,
      routineWeekdays: monWedFri,
      color: '0xFFEF5350',
      startDate: DateTime.utc(2026, 8, 1),
    );

    await service.addAttendance(
      studentId: studentB.id,
      date: DateTime.utc(2026, 9, 9),
    );
    await service.addAttendance(
      studentId: studentA.id,
      date: DateTime.utc(2026, 9, 7),
    );
    await service.addAttendance(
      studentId: studentA.id,
      date: DateTime.utc(2026, 8, 31),
    );

    final september = await DriftAttendanceRepository(
      db,
    ).between(DateTime.utc(2026, 9, 1), DateTime.utc(2026, 9, 30));

    expect(september, hasLength(2));
    expect(september.first.attendanceDate, DateTime.utc(2026, 9, 7));
  });
}
