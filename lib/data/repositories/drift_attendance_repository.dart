import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/date_util.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../database/app_database.dart';

/// Drift-backed [AttendanceRepository].
///
/// Date-only columns are stored as `YYYY-MM-DD` TEXT via a converter; drift
/// expressions compare the SQL-side value, so where-clauses pass ISO strings
/// (lexicographic ISO comparison equals chronological comparison).
class DriftAttendanceRepository implements AttendanceRepository {
  DriftAttendanceRepository(this._db, {Uuid uuidGenerator = const Uuid()})
    : _uuid = uuidGenerator;

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Future<AttendanceRecord> add({
    required String studentId,
    required DateTime attendanceDate,
    String? note,
    String? id,
  }) async {
    final DateTime date = DateUtil.dateOnly(attendanceDate);
    final bool exists =
        await (_db.select(_db.attendanceRecords)..where(
              ($AttendanceRecordsTable tbl) =>
                  tbl.studentId.equals(studentId) &
                  tbl.attendanceDate.equals(DateUtil.toIsoDate(date)),
            ))
            .get()
            .then((List<AttendanceRecordRow> rows) => rows.isNotEmpty);
    if (exists) {
      throw DuplicateAttendanceException(studentId, date);
    }

    final DateTime now = DateTime.now();
    final AttendanceRecord record = AttendanceRecord(
      id: id ?? _uuid.v4(),
      studentId: studentId,
      attendanceDate: date,
      createdAt: now,
      updatedAt: now,
      note: note,
    );
    await _db.into(_db.attendanceRecords).insert(_companion(record));
    return record;
  }

  @override
  Future<void> removeById(String id) async {
    await (_db.delete(
      _db.attendanceRecords,
    )..where(($AttendanceRecordsTable tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<void> removeForStudentAndDate(String studentId, DateTime date) async {
    await (_db.delete(_db.attendanceRecords)..where(
          ($AttendanceRecordsTable tbl) =>
              tbl.studentId.equals(studentId) &
              tbl.attendanceDate.equals(DateUtil.toIsoDate(date)),
        ))
        .go();
  }

  @override
  Future<List<AttendanceRecord>> forDate(DateTime date) async {
    final List<AttendanceRecordRow> rows =
        await (_db.select(_db.attendanceRecords)
              ..where(
                ($AttendanceRecordsTable tbl) =>
                    tbl.attendanceDate.equals(DateUtil.toIsoDate(date)),
              )
              ..orderBy(([
                ($AttendanceRecordsTable tbl) =>
                    OrderingTerm(expression: tbl.studentId),
              ])))
            .get();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<AttendanceRecord>> between(DateTime start, DateTime end) async {
    final List<AttendanceRecordRow> rows =
        await (_db.select(_db.attendanceRecords)
              ..where(
                ($AttendanceRecordsTable tbl) =>
                    tbl.attendanceDate.isBetweenValues(
                      DateUtil.toIsoDate(start),
                      DateUtil.toIsoDate(end),
                    ),
              )
              ..orderBy(([
                ($AttendanceRecordsTable tbl) =>
                    OrderingTerm(expression: tbl.attendanceDate),
                ($AttendanceRecordsTable tbl) =>
                    OrderingTerm(expression: tbl.studentId),
              ])))
            .get();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<AttendanceRecord>> forStudentBetween(
    String studentId,
    DateTime start,
    DateTime end,
  ) async {
    final List<AttendanceRecordRow> rows =
        await (_db.select(_db.attendanceRecords)
              ..where(
                ($AttendanceRecordsTable tbl) =>
                    tbl.studentId.equals(studentId) &
                    tbl.attendanceDate.isBetweenValues(
                      DateUtil.toIsoDate(start),
                      DateUtil.toIsoDate(end),
                    ),
              )
              ..orderBy(([
                ($AttendanceRecordsTable tbl) =>
                    OrderingTerm(expression: tbl.attendanceDate),
              ])))
            .get();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<int> countForStudentBetween(
    String studentId,
    DateTime start,
    DateTime end,
  ) async {
    final List<AttendanceRecordRow> rows =
        await (_db.select(_db.attendanceRecords)..where(
              ($AttendanceRecordsTable tbl) =>
                  tbl.studentId.equals(studentId) &
                  tbl.attendanceDate.isBetweenValues(
                    DateUtil.toIsoDate(start),
                    DateUtil.toIsoDate(end),
                  ),
            ))
            .get();
    return rows.length;
  }

  @override
  Stream<List<AttendanceRecord>> watchForDate(DateTime date) {
    return (_db.select(_db.attendanceRecords)..where(
          ($AttendanceRecordsTable tbl) =>
              tbl.attendanceDate.equals(DateUtil.toIsoDate(date)),
        ))
        .watch()
        .map((List<AttendanceRecordRow> rows) => rows.map(_toEntity).toList());
  }

  @override
  Stream<List<AttendanceRecord>> watchBetween(DateTime start, DateTime end) {
    return (_db.select(_db.attendanceRecords)..where(
          ($AttendanceRecordsTable tbl) => tbl.attendanceDate.isBetweenValues(
            DateUtil.toIsoDate(start),
            DateUtil.toIsoDate(end),
          ),
        ))
        .watch()
        .map((List<AttendanceRecordRow> rows) => rows.map(_toEntity).toList());
  }

  AttendanceRecordsCompanion _companion(AttendanceRecord r) =>
      AttendanceRecordsCompanion(
        id: Value<String>(r.id),
        studentId: Value<String>(r.studentId),
        attendanceDate: Value<DateTime>(r.attendanceDate),
        createdAt: Value<DateTime>(r.createdAt),
        updatedAt: Value<DateTime>(r.updatedAt),
        note: Value<String?>(r.note),
      );

  AttendanceRecord _toEntity(AttendanceRecordRow row) => AttendanceRecord(
    id: row.id,
    studentId: row.studentId,
    attendanceDate: row.attendanceDate,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    note: row.note,
  );
}
