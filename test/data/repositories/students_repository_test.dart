import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/repositories/drift_students_repository.dart';
import 'package:home_tutor_attendance/domain/entities/student.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';

void main() {
  late AppDatabase db;
  late DriftStudentsRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftStudentsRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  Student buildStudent({String id = 's1', String name = 'Student A'}) =>
      Student(
        id: id,
        name: name,
        weeklyDays: 3,
        routineWeekdays: const <Weekday>[
          Weekday.monday,
          Weekday.wednesday,
          Weekday.friday,
        ],
        color: '0xFF42A5F5',
        currentlyTeaching: true,
        startDate: DateTime.utc(2026, 8, 1),
        createdAt: DateTime.utc(2026, 8, 1),
        updatedAt: DateTime.utc(2026, 8, 1),
        phone: '0123456789',
      );

  test('create and findById round-trips the entity', () async {
    final Student saved = await repository.create(buildStudent());

    expect(saved.id, 's1');
    final Student? loaded = await repository.findById('s1');
    expect(loaded, saved);
    expect(loaded!.phone, '0123456789');
    expect(loaded.routineWeekdays, const <Weekday>[
      Weekday.monday,
      Weekday.wednesday,
      Weekday.friday,
    ]);
  });

  test('update persists edited fields', () async {
    await repository.create(buildStudent());

    await repository.update(
      (await repository.findById('s1'))!.copyWith(
        name: 'Student A (edited)',
        weeklyDays: 2,
        routineWeekdays: const <Weekday>[Weekday.tuesday, Weekday.thursday],
        updatedAt: DateTime.utc(2026, 9, 1),
      ),
    );

    final Student? reloaded = await repository.findById('s1');
    expect(reloaded!.name, 'Student A (edited)');
    expect(reloaded.weeklyDays, 2);
    expect(reloaded.routineWeekdays, const <Weekday>[
      Weekday.tuesday,
      Weekday.thursday,
    ]);
  });

  test('archive marks inactive while preserving the row and history', () async {
    await repository.create(buildStudent());

    await repository.archive('s1', DateTime.utc(2026, 9, 1));

    final Student? archived = await repository.findById('s1');
    expect(archived, isNotNull); // row preserved (PRD BR-08)
    expect(archived!.currentlyTeaching, isFalse);
    expect(archived.archivedAt, DateTime.utc(2026, 9, 1));
    expect(await repository.findAll(), hasLength(1));
  });

  test('findAll returns all students', () async {
    await repository.create(buildStudent(id: 's1'));
    await repository.create(buildStudent(id: 's2', name: 'Student B'));

    final List<Student> all = await repository.findAll();
    expect(all, hasLength(2));
  });
}
