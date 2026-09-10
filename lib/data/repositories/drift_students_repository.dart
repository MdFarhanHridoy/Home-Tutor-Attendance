import 'package:drift/drift.dart';

import '../../domain/entities/student.dart';
import '../../domain/entities/weekday.dart';
import '../../domain/repositories/students_repository.dart';
import '../database/app_database.dart';

/// Drift-backed [StudentsRepository]; hides all database details.
class DriftStudentsRepository implements StudentsRepository {
  DriftStudentsRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Student> create(Student student) async {
    await _db.into(_db.students).insert(_companion(student));
    return student;
  }

  @override
  Future<Student> update(Student student) async {
    await (_db.update(_db.students)
          ..where(($StudentsTable tbl) => tbl.id.equals(student.id)))
        .write(_companion(student));
    return student;
  }

  @override
  Future<Student?> findById(String id) async {
    final StudentRow? row = await (_db.select(
      _db.students,
    )..where(($StudentsTable tbl) => tbl.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<List<Student>> findAll() async {
    final List<StudentRow> rows = await _db.select(_db.students).get();
    return rows.map(_toEntity).toList();
  }

  @override
  Stream<List<Student>> watchAll() {
    return _db
        .select(_db.students)
        .watch()
        .map((List<StudentRow> rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<void> archive(String id, DateTime archivedAt) async {
    await (_db.update(
      _db.students,
    )..where(($StudentsTable tbl) => tbl.id.equals(id))).write(
      StudentsCompanion(
        currentlyTeaching: const Value<bool>(false),
        archivedAt: Value<DateTime>(archivedAt),
        updatedAt: Value<DateTime>(DateTime.now()),
      ),
    );
  }

  StudentsCompanion _companion(Student s) => StudentsCompanion(
    id: Value<String>(s.id),
    name: Value<String>(s.name),
    weeklyDays: Value<int>(s.weeklyDays),
    routineWeekdays: Value<List<Weekday>>(s.routineWeekdays),
    color: Value<String>(s.color),
    currentlyTeaching: Value<bool>(s.currentlyTeaching),
    startDate: Value<DateTime>(s.startDate),
    phone: Value<String?>(s.phone),
    guardianName: Value<String?>(s.guardianName),
    address: Value<String?>(s.address),
    notes: Value<String?>(s.notes),
    createdAt: Value<DateTime>(s.createdAt),
    updatedAt: Value<DateTime>(s.updatedAt),
    archivedAt: Value<DateTime?>(s.archivedAt),
  );

  Student _toEntity(StudentRow row) => Student(
    id: row.id,
    name: row.name,
    weeklyDays: row.weeklyDays,
    routineWeekdays: row.routineWeekdays,
    color: row.color,
    currentlyTeaching: row.currentlyTeaching,
    startDate: row.startDate,
    phone: row.phone,
    guardianName: row.guardianName,
    address: row.address,
    notes: row.notes,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    archivedAt: row.archivedAt,
  );
}
