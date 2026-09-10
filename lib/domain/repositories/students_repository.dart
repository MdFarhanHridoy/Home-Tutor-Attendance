import '../entities/student.dart';

/// Storage contract for students (implementation.md §5.4).
///
/// Implementations must hide all database details from callers. Archiving is
/// preferred over deletion (PRD BR-08); no hard-delete is offered.
abstract class StudentsRepository {
  /// Inserts a fully-formed [Student]; the caller owns ID generation.
  Future<Student> create(Student student);

  /// Persists changes to an existing student.
  Future<Student> update(Student student);

  /// Loads one student by ID, or null.
  Future<Student?> findById(String id);

  /// Loads all students (active and inactive).
  Future<List<Student>> findAll();

  /// Observes all students (active and inactive).
  Stream<List<Student>> watchAll();

  /// Marks the student not-currently-teaching and archived at [archivedAt],
  /// preserving all history (PRD §11.2 activeFrom/activeTo semantics).
  Future<void> archive(String id, DateTime archivedAt);
}
