import 'package:drift/drift.dart';

import '../../domain/entities/teaching_period.dart';
import '../../domain/repositories/teaching_periods_repository.dart';
import '../database/app_database.dart';

/// Drift-backed [TeachingPeriodsRepository].
class DriftTeachingPeriodsRepository implements TeachingPeriodsRepository {
  DriftTeachingPeriodsRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> save(TeachingPeriod period) async {
    final TeachingPeriodRow? existing =
        await (_db.select(_db.teachingPeriods)
              ..where(($TeachingPeriodsTable tbl) => tbl.id.equals(period.id)))
            .getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.teachingPeriods).insert(_companion(period));
    } else {
      await (_db.update(_db.teachingPeriods)
            ..where(($TeachingPeriodsTable tbl) => tbl.id.equals(period.id)))
          .write(_companion(period));
    }
  }

  @override
  Future<List<TeachingPeriod>> forStudent(String studentId) async {
    final List<TeachingPeriodRow> rows =
        await (_db.select(_db.teachingPeriods)
              ..where(
                ($TeachingPeriodsTable tbl) => tbl.studentId.equals(studentId),
              )
              ..orderBy(([
                ($TeachingPeriodsTable tbl) =>
                    OrderingTerm(expression: tbl.startDate),
              ])))
            .get();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<TeachingPeriod?> openPeriodForStudent(String studentId) async {
    final TeachingPeriodRow? row =
        await (_db.select(_db.teachingPeriods)..where(
              ($TeachingPeriodsTable tbl) =>
                  tbl.studentId.equals(studentId) & tbl.endDate.isNull(),
            ))
            .getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  TeachingPeriodsCompanion _companion(TeachingPeriod p) =>
      TeachingPeriodsCompanion(
        id: Value<String>(p.id),
        studentId: Value<String>(p.studentId),
        startDate: Value<DateTime>(p.startDate),
        endDate: Value<DateTime?>(p.endDate),
        createdAt: Value<DateTime>(p.createdAt),
        updatedAt: Value<DateTime>(p.updatedAt),
      );

  TeachingPeriod _toEntity(TeachingPeriodRow row) => TeachingPeriod(
    id: row.id,
    studentId: row.studentId,
    startDate: row.startDate,
    endDate: row.endDate,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
