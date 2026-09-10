import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_tutor_attendance/data/database/app_database.dart';
import 'package:home_tutor_attendance/data/repositories/drift_routine_periods_repository.dart';
import 'package:home_tutor_attendance/data/repositories/drift_teaching_periods_repository.dart';
import 'package:home_tutor_attendance/domain/entities/routine_period.dart';
import 'package:home_tutor_attendance/domain/entities/teaching_period.dart';
import 'package:home_tutor_attendance/domain/entities/weekday.dart';

void main() {
  late AppDatabase db;
  late DriftTeachingPeriodsRepository teachingRepository;
  late DriftRoutinePeriodsRepository routineRepository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    teachingRepository = DriftTeachingPeriodsRepository(db);
    routineRepository = DriftRoutinePeriodsRepository(db);
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

  group('teaching periods', () {
    test('save inserts and updates (closing a period)', () async {
      await seedStudent('s1');

      final TeachingPeriod open = TeachingPeriod(
        id: 'tp1',
        studentId: 's1',
        startDate: DateTime.utc(2026, 8, 1),
        createdAt: DateTime.utc(2026, 8, 1),
        updatedAt: DateTime.utc(2026, 8, 1),
      );
      await teachingRepository.save(open);
      expect(await teachingRepository.openPeriodForStudent('s1'), open);

      await teachingRepository.save(
        open.copyWith(endDate: DateTime.utc(2026, 8, 31)),
      );
      expect(await teachingRepository.openPeriodForStudent('s1'), isNull);
      final List<TeachingPeriod> periods = await teachingRepository.forStudent(
        's1',
      );
      expect(periods, hasLength(1));
      expect(periods.single.endDate, DateTime.utc(2026, 8, 31));
    });

    test('multiple historical periods return oldest first', () async {
      await seedStudent('s1');

      await teachingRepository.save(
        TeachingPeriod(
          id: 'tp2',
          studentId: 's1',
          startDate: DateTime.utc(2026, 11, 1),
          createdAt: DateTime.utc(2026, 11, 1),
          updatedAt: DateTime.utc(2026, 11, 1),
        ),
      );
      await teachingRepository.save(
        TeachingPeriod(
          id: 'tp1',
          studentId: 's1',
          startDate: DateTime.utc(2026, 1, 5),
          endDate: DateTime.utc(2026, 3, 31),
          createdAt: DateTime.utc(2026, 1, 5),
          updatedAt: DateTime.utc(2026, 3, 31),
        ),
      );

      final List<TeachingPeriod> periods = await teachingRepository.forStudent(
        's1',
      );
      expect(periods.map((TeachingPeriod p) => p.id), <String>['tp1', 'tp2']);
    });
  });

  group('routine periods', () {
    test('save inserts and updates with weekday history', () async {
      await seedStudent('s1');

      final RoutinePeriod first = RoutinePeriod(
        id: 'rp1',
        studentId: 's1',
        startDate: DateTime.utc(2026, 8, 1),
        endDate: DateTime.utc(2026, 8, 31),
        weeklyDays: 3,
        weekdays: const <Weekday>[
          Weekday.monday,
          Weekday.wednesday,
          Weekday.friday,
        ],
        createdAt: DateTime.utc(2026, 8, 1),
        updatedAt: DateTime.utc(2026, 8, 31),
      );
      final RoutinePeriod second = RoutinePeriod(
        id: 'rp2',
        studentId: 's1',
        startDate: DateTime.utc(2026, 9, 1),
        weeklyDays: 2,
        weekdays: const <Weekday>[Weekday.tuesday, Weekday.thursday],
        createdAt: DateTime.utc(2026, 9, 1),
        updatedAt: DateTime.utc(2026, 9, 1),
      );
      await routineRepository.save(first);
      await routineRepository.save(second);

      final List<RoutinePeriod> history = await routineRepository.forStudent(
        's1',
      );
      expect(history, hasLength(2));
      expect(history[0].weekdays, const <Weekday>[
        Weekday.monday,
        Weekday.wednesday,
        Weekday.friday,
      ]);
      expect(history[1].weekdays, const <Weekday>[
        Weekday.tuesday,
        Weekday.thursday,
      ]);

      final RoutinePeriod? open = await routineRepository.openPeriodForStudent(
        's1',
      );
      expect(open!.id, 'rp2');
    });
  });
}
