import '../../core/utils/date_util.dart';
import '../entities/attendance_record.dart';

/// Thrown when adding an attendance record for a student/date pair that
/// already exists (PRD §11.5 duplicate prevention, domain level).
class DuplicateAttendanceException implements Exception {
  const DuplicateAttendanceException(this.studentId, this.date);

  final String studentId;
  final DateTime date;

  @override
  String toString() =>
      'DuplicateAttendanceException: student $studentId already has '
      'attendance on ${DateUtil.toIsoDate(date)}';
}

/// Storage contract for attendance records (PRD §11.5). All dates are
/// date-only values; ranges are inclusive.
abstract class AttendanceRepository {
  /// Adds the fact that [studentId] was taught on [attendanceDate].
  ///
  /// Throws [DuplicateAttendanceException] when the pair already exists;
  /// the database additionally enforces uniqueness as the final guard.
  Future<AttendanceRecord> add({
    required String studentId,
    required DateTime attendanceDate,
    String? note,
    String? id,
  });

  /// Removes one record by ID.
  Future<void> removeById(String id);

  /// Removes the record for a student/date pair if present.
  Future<void> removeForStudentAndDate(String studentId, DateTime date);

  /// All records on a date.
  Future<List<AttendanceRecord>> forDate(DateTime date);

  /// All records of ALL students inside [start, end] (inclusive), sorted by
  /// date then student ID.
  Future<List<AttendanceRecord>> between(DateTime start, DateTime end);

  /// All records of one student inside [start, end] (inclusive).
  Future<List<AttendanceRecord>> forStudentBetween(
    String studentId,
    DateTime start,
    DateTime end,
  );

  /// Number of the student's records inside [start, end] (inclusive).
  Future<int> countForStudentBetween(
    String studentId,
    DateTime start,
    DateTime end,
  );

  /// Observes all records on a date.
  Stream<List<AttendanceRecord>> watchForDate(DateTime date);

  /// Observes all records inside [start, end] (inclusive).
  Stream<List<AttendanceRecord>> watchBetween(DateTime start, DateTime end);
}
