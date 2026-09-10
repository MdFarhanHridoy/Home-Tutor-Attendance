import 'package:clock/clock.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/core/utils/date_util.dart';
import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/repositories/drift_routine_periods_repository.dart';
import 'package:home_tutor_attendance/data/repositories/drift_students_repository.dart';
import 'package:home_tutor_attendance/data/repositories/drift_teaching_periods_repository.dart';
import 'package:home_tutor_attendance/domain/entities/routine_period.dart';
import 'package:home_tutor_attendance/domain/entities/student.dart';
import 'package:home_tutor_attendance/domain/entities/teaching_period.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';
import 'package:home_tutor_attendance/domain/services/student_management_service.dart';

void main() {
  // 2026-09-10 (Thursday) 12:00 local — "today" for all lifecycle rules.
  final Clock fixedClock = Clock.fixed(DateTime(2026, 9, 10, 12));
  final DateTime today = DateTime.utc(2026, 9, 10);
  final DateTime yesterday = DateTime.utc(2026, 9, 9);

  late AppDatabase db;
  late StudentManagementService service;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    service = StudentManagementService(
      studentsRepository: DriftStudentsRepository(db),
      teachingPeriodsRepository: DriftTeachingPeriodsRepository(db),
      routinePeriodsRepository: DriftRoutinePeriodsRepository(db),
      clock: fixedClock,
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
  const List<Weekday> tueThu = <Weekday>[Weekday.tuesday, Weekday.thursday];

  Future<Student> createDefaultStudent() {
    return service.createStudent(
      name: 'Student A',
      weeklyDays: 3,
      routineWeekdays: monWedFri,
      color: '0xFF42A5F5',
      startDate: DateTime.utc(2026, 8, 1),
    );
  }

  test(
    'create opens teaching and routine periods from the start date',
    () async {
      final Student student = await createDefaultStudent();

      expect(student.currentlyTeaching, isTrue);
      final List<TeachingPeriod> teaching =
          await DriftTeachingPeriodsRepository(db).forStudent(student.id);
      final List<RoutinePeriod> routine = await DriftRoutinePeriodsRepository(
        db,
      ).forStudent(student.id);
      expect(teaching, hasLength(1));
      expect(teaching.single.startDate, DateTime.utc(2026, 8, 1));
      expect(teaching.single.isOpen, isTrue);
      expect(routine, hasLength(1));
      expect(routine.single.weekdays, monWedFri);
      expect(routine.single.isOpen, isTrue);
      // Snapshot on the student row mirrors the routine.
      expect(student.routineWeekdays, monWedFri);
      expect(student.weeklyDays, 3);
    },
  );

  test('profile edits never touch periods', () async {
    final Student created = await createDefaultStudent();

    final Student updated = await service.updateProfile(
      studentId: created.id,
      name: 'Student A (edited)',
      color: '0xFFEF5350',
      phone: '01700000000',
    );

    expect(updated.name, 'Student A (edited)');
    expect(updated.color, '0xFFEF5350');
    expect(updated.phone, '01700000000');
    expect(
      await DriftTeachingPeriodsRepository(db).forStudent(created.id),
      hasLength(1),
    );
    expect(
      await DriftRoutinePeriodsRepository(db).forStudent(created.id),
      hasLength(1),
    );
  });

  test(
    'routine change closes the old period and opens a new one today',
    () async {
      final Student created = await createDefaultStudent();

      final Student updated = await service.changeRoutine(
        studentId: created.id,
        weeklyDays: 2,
        weekdays: tueThu,
      );

      final List<RoutinePeriod> history = await DriftRoutinePeriodsRepository(
        db,
      ).forStudent(created.id);
      expect(history, hasLength(2));
      expect(history[0].weekdays, monWedFri); // history intact
      expect(history[0].endDate, yesterday);
      expect(history[1].weekdays, tueThu); // new routine from today
      expect(history[1].startDate, today);
      expect(history[1].isOpen, isTrue);
      expect(updated.weeklyDays, 2);
      expect(updated.routineWeekdays, tueThu);
    },
  );

  test('changing to the same routine is a no-op', () async {
    final Student created = await createDefaultStudent();

    await service.changeRoutine(
      studentId: created.id,
      weeklyDays: 3,
      weekdays: monWedFri,
    );

    expect(
      await DriftRoutinePeriodsRepository(db).forStudent(created.id),
      hasLength(1),
    );
  });

  test(
    'deactivate closes periods the day before and preserves everything',
    () async {
      final Student created = await createDefaultStudent();

      final Student inactive = await service.setCurrentlyTeaching(
        studentId: created.id,
        teaching: false,
      );

      expect(inactive.currentlyTeaching, isFalse);
      expect(inactive.archivedAt, isNotNull);
      final List<TeachingPeriod> teaching =
          await DriftTeachingPeriodsRepository(db).forStudent(created.id);
      expect(teaching.single.endDate, yesterday);
      expect(teaching.single.isOpen, isFalse);
      final List<RoutinePeriod> routine = await DriftRoutinePeriodsRepository(
        db,
      ).forStudent(created.id);
      expect(routine.single.endDate, yesterday);
      // Student row itself is preserved (PRD BR-08).
      expect(await DriftStudentsRepository(db).findById(created.id), isNotNull);
    },
  );

  test('reactivate creates brand-new periods (never edits old ones)', () async {
    final Student created = await createDefaultStudent();
    await service.setCurrentlyTeaching(studentId: created.id, teaching: false);

    final Student active = await service.setCurrentlyTeaching(
      studentId: created.id,
      teaching: true,
    );

    expect(active.currentlyTeaching, isTrue);
    final List<TeachingPeriod> teaching = await DriftTeachingPeriodsRepository(
      db,
    ).forStudent(created.id);
    final List<RoutinePeriod> routine = await DriftRoutinePeriodsRepository(
      db,
    ).forStudent(created.id);
    expect(teaching, hasLength(2));
    expect(teaching[0].endDate, yesterday); // historical period untouched
    expect(teaching[1].startDate, today); // NEW period
    expect(teaching[1].isOpen, isTrue);
    expect(routine, hasLength(2));
    expect(routine[1].startDate, today);
    expect(routine[1].weekdays, monWedFri); // routine continues from snapshot
  });

  test('deactivate/reactivate are idempotent', () async {
    final Student created = await createDefaultStudent();

    await service.setCurrentlyTeaching(studentId: created.id, teaching: false);
    await service.setCurrentlyTeaching(studentId: created.id, teaching: false);

    final List<TeachingPeriod> teaching = await DriftTeachingPeriodsRepository(
      db,
    ).forStudent(created.id);
    expect(teaching, hasLength(1)); // no duplicate closing
  });

  test('validation rejects empty names', () async {
    expect(
      () => service.createStudent(
        name: '   ',
        weeklyDays: 3,
        routineWeekdays: monWedFri,
        color: '0xFF42A5F5',
        startDate: today,
      ),
      throwsArgumentError,
    );
  });

  test('validation rejects weeklyDays outside 1-7 (AC-09)', () async {
    expect(
      () => service.createStudent(
        name: 'A',
        weeklyDays: 8,
        routineWeekdays: monWedFri,
        color: '0xFF42A5F5',
        startDate: today,
      ),
      throwsArgumentError,
    );
  });

  test('validation rejects mismatched weekday counts (AC-09)', () async {
    expect(
      () => service.createStudent(
        name: 'A',
        weeklyDays: 3,
        routineWeekdays: tueThu, // only 2
        color: '0xFF42A5F5',
        startDate: today,
      ),
      throwsArgumentError,
    );
  });

  test('validation rejects duplicate weekdays', () async {
    expect(
      () => service.createStudent(
        name: 'A',
        weeklyDays: 2,
        routineWeekdays: <Weekday>[Weekday.monday, Weekday.monday],
        color: '0xFF42A5F5',
        startDate: today,
      ),
      throwsArgumentError,
    );
  });

  test('optional text fields are trimmed and empties become null', () async {
    final Student student = await service.createStudent(
      name: 'Student B',
      weeklyDays: 2,
      routineWeekdays: tueThu,
      color: '0xFFEF5350',
      startDate: today,
      phone: '  01700000000  ',
      guardianName: '   ',
    );

    expect(student.phone, '01700000000');
    expect(student.guardianName, isNull);
    expect(DateUtil.isSameDay(student.startDate, today), isTrue);
  });
}
