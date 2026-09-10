import 'package:drift/drift.dart';

import '../../domain/entities/routine_period.dart';
import '../../domain/entities/weekday.dart';
import '../../domain/repositories/routine_periods_repository.dart';
import '../database/app_database.dart';

/// Drift-backed [RoutinePeriodsRepository].
class DriftRoutinePeriodsRepository implements RoutinePeriodsRepository {
  DriftRoutinePeriodsRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> save(RoutinePeriod period) async {
    final RoutinePeriodRow? existing =
        await (_db.select(_db.routinePeriods)
              ..where(($RoutinePeriodsTable tbl) => tbl.id.equals(period.id)))
            .getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.routinePeriods).insert(_companion(period));
    } else {
      await (_db.update(_db.routinePeriods)
            ..where(($RoutinePeriodsTable tbl) => tbl.id.equals(period.id)))
          .write(_companion(period));
    }
  }

  @override
  Future<List<RoutinePeriod>> forStudent(String studentId) async {
    final List<RoutinePeriodRow> rows =
        await (_db.select(_db.routinePeriods)
              ..where(
                ($RoutinePeriodsTable tbl) => tbl.studentId.equals(studentId),
              )
              ..orderBy(([
                ($RoutinePeriodsTable tbl) =>
                    OrderingTerm(expression: tbl.startDate),
              ])))
            .get();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<RoutinePeriod?> openPeriodForStudent(String studentId) async {
    final RoutinePeriodRow? row =
        await (_db.select(_db.routinePeriods)..where(
              ($RoutinePeriodsTable tbl) =>
                  tbl.studentId.equals(studentId) & tbl.endDate.isNull(),
            ))
            .getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  RoutinePeriodsCompanion _companion(RoutinePeriod p) =>
      RoutinePeriodsCompanion(
        id: Value<String>(p.id),
        studentId: Value<String>(p.studentId),
        startDate: Value<DateTime>(p.startDate),
        endDate: Value<DateTime?>(p.endDate),
        weeklyDays: Value<int>(p.weeklyDays),
        weekdays: Value<List<Weekday>>(p.weekdays),
        createdAt: Value<DateTime>(p.createdAt),
        updatedAt: Value<DateTime>(p.updatedAt),
      );

  RoutinePeriod _toEntity(RoutinePeriodRow row) => RoutinePeriod(
    id: row.id,
    studentId: row.studentId,
    startDate: row.startDate,
    endDate: row.endDate,
    weeklyDays: row.weeklyDays,
    weekdays: row.weekdays,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
