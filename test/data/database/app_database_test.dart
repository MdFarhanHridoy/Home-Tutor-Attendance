import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/database/tables.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';

AppDatabase newDb() => AppDatabase.forTesting(NativeDatabase.memory());

const List<Weekday> monWedFri = <Weekday>[
  Weekday.monday,
  Weekday.wednesday,
  Weekday.friday,
];

Future<void> seedStudent(
  AppDatabase db, {
  String id = 's1',
  String name = 'Student A',
}) async {
  await db
      .into(db.students)
      .insert(
        StudentsCompanion.insert(
          id: id,
          name: name,
          weeklyDays: 3,
          routineWeekdays: monWedFri,
          color: '0xFF42A5F5',
          startDate: DateTime.utc(2026, 8, 1),
          createdAt: DateTime.utc(2026, 8, 1),
          updatedAt: DateTime.utc(2026, 8, 1),
        ),
      );
}

Future<void> seedAttendance(
  AppDatabase db, {
  String id = 'a1',
  String studentId = 's1',
  DateTime? date,
}) async {
  await db
      .into(db.attendanceRecords)
      .insert(
        AttendanceRecordsCompanion.insert(
          id: id,
          studentId: studentId,
          attendanceDate: date ?? DateTime.utc(2026, 9, 9),
          createdAt: DateTime.utc(2026, 9, 9),
          updatedAt: DateTime.utc(2026, 9, 9),
        ),
      );
}

void main() {
  tearDown(() async {});

  test(
    'schema version is 1 and settings row is seeded with v1 defaults',
    () async {
      final AppDatabase db = newDb();
      addTearDown(db.close);

      expect(db.schemaVersion, 1);
      final List<AppSettingsRow> rows = await db
          .select(db.appSettingsTable)
          .get();
      expect(rows, hasLength(1));
      expect(rows.first.id, 1);
      expect(rows.first.themeMode, 'dark');
      expect(rows.first.firstDayOfWeek, 'friday');
    },
  );

  test('student round-trips with date-only and weekday-list values', () async {
    final AppDatabase db = newDb();
    addTearDown(db.close);
    await seedStudent(db);

    final StudentRow row = await db.select(db.students).getSingle();
    expect(row.name, 'Student A');
    expect(row.weeklyDays, 3);
    expect(row.routineWeekdays, monWedFri);
    expect(row.startDate, DateTime.utc(2026, 8, 1));
    expect(row.currentlyTeaching, isTrue); // column default applied
    expect(row.phone, isNull);
    expect(row.archivedAt, isNull);
  });

  test('nullable optional fields persist', () async {
    final AppDatabase db = newDb();
    addTearDown(db.close);
    await seedStudent(db);

    await (db.update(
      db.students,
    )..where((Students tbl) => tbl.id.equals('s1'))).write(
      const StudentsCompanion(
        phone: Value('0123456789'),
        guardianName: Value('Guardian'),
      ),
    );

    final StudentRow row = await db.select(db.students).getSingle();
    expect(row.phone, '0123456789');
    expect(row.guardianName, 'Guardian');
    expect(row.address, isNull);
  });

  test('attendance UNIQUE(student_id, attendance_date) is enforced', () async {
    final AppDatabase db = newDb();
    addTearDown(db.close);
    await seedStudent(db);
    await seedAttendance(db, id: 'a1');

    try {
      await seedAttendance(db, id: 'a2'); // same student + date
      fail('Expected a uniqueness violation');
    } on Exception {
      // Expected: SqliteException UNIQUE constraint failed.
    }

    final List<AttendanceRecordRow> rows = await db
        .select(db.attendanceRecords)
        .get();
    expect(rows, hasLength(1));
    expect(rows.first.id, 'a1');
  });

  test('attendance foreign key references an existing student', () async {
    final AppDatabase db = newDb();
    addTearDown(db.close);
    await seedStudent(db);

    try {
      await seedAttendance(db, id: 'a1', studentId: 'ghost');
      fail('Expected a foreign key violation');
    } on Exception {
      // Expected: SqliteException FOREIGN KEY constraint failed.
    }

    expect(await db.select(db.attendanceRecords).get(), isEmpty);
  });

  test('multiple students can attend the same date', () async {
    final AppDatabase db = newDb();
    addTearDown(db.close);
    await seedStudent(db, id: 's1', name: 'Student A');
    await seedStudent(db, id: 's2', name: 'Student B');

    await seedAttendance(db, id: 'a1', studentId: 's1');
    await seedAttendance(db, id: 'a2', studentId: 's2');

    expect(await db.select(db.attendanceRecords).get(), hasLength(2));
  });

  test('data persists across close/reopen on a file-backed database', () async {
    final Directory tempDir = await Directory.systemTemp.createTemp(
      'hta_db_test',
    );
    addTearDown(() => tempDir.delete(recursive: true));
    final File file = File(
      '${tempDir.path}${Platform.pathSeparator}test.sqlite',
    );

    final AppDatabase first = AppDatabase.forTesting(
      LazyDatabase(() async => NativeDatabase.createInBackground(file)),
    );
    await seedStudent(first);
    await seedAttendance(first);
    await first.close();

    final AppDatabase second = AppDatabase.forTesting(
      LazyDatabase(() async => NativeDatabase.createInBackground(file)),
    );
    addTearDown(second.close);

    final List<StudentRow> students = await second
        .select(second.students)
        .get();
    final List<AttendanceRecordRow> attendance = await second
        .select(second.attendanceRecords)
        .get();
    expect(students, hasLength(1));
    expect(attendance, hasLength(1));
    expect(attendance.first.attendanceDate, DateTime.utc(2026, 9, 9));
  });

  test('teaching and routine period history rows persist', () async {
    final AppDatabase db = newDb();
    addTearDown(db.close);
    await seedStudent(db);

    await db
        .into(db.teachingPeriods)
        .insert(
          TeachingPeriodsCompanion.insert(
            id: 'tp1',
            studentId: 's1',
            startDate: DateTime.utc(2026, 8, 1),
            endDate: Value(DateTime.utc(2026, 8, 31)),
            createdAt: DateTime.utc(2026, 8, 1),
            updatedAt: DateTime.utc(2026, 8, 31),
          ),
        );
    await db
        .into(db.teachingPeriods)
        .insert(
          TeachingPeriodsCompanion.insert(
            id: 'tp2',
            studentId: 's1',
            startDate: DateTime.utc(2026, 11, 1),
            createdAt: DateTime.utc(2026, 11, 1),
            updatedAt: DateTime.utc(2026, 11, 1),
          ),
        );
    await db
        .into(db.routinePeriods)
        .insert(
          RoutinePeriodsCompanion.insert(
            id: 'rp1',
            studentId: 's1',
            startDate: DateTime.utc(2026, 8, 1),
            weeklyDays: 3,
            weekdays: monWedFri,
            createdAt: DateTime.utc(2026, 8, 1),
            updatedAt: DateTime.utc(2026, 8, 1),
          ),
        );

    final List<TeachingPeriodRow> periods = await db
        .select(db.teachingPeriods)
        .get();
    final List<RoutinePeriodRow> routines = await db
        .select(db.routinePeriods)
        .get();
    expect(periods, hasLength(2));
    expect(periods.first.endDate, DateTime.utc(2026, 8, 31));
    expect(periods.last.endDate, isNull);
    expect(routines.single.weekdays, monWedFri);
  });
}
