/// The fact that the tutor taught a student on a specific calendar date
/// (PRD §11.5).
///
/// A scheduled day does NOT automatically create a record; only actual
/// teaching does (PRD §10.3). Uniqueness of (studentId, attendanceDate) is
/// enforced at the persistence layer.
class AttendanceRecord {
  const AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.attendanceDate,
    required this.createdAt,
    required this.updatedAt,
    this.note,
  });

  final String id;
  final String studentId;
  final DateTime attendanceDate; // date-only
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? note;

  AttendanceRecord copyWith({
    DateTime? attendanceDate,
    String? note,
    DateTime? updatedAt,
  }) {
    return AttendanceRecord(
      id: id,
      studentId: studentId,
      attendanceDate: attendanceDate ?? this.attendanceDate,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AttendanceRecord &&
        other.id == id &&
        other.studentId == studentId &&
        other.attendanceDate == attendanceDate &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.note == note;
  }

  @override
  int get hashCode =>
      Object.hash(id, studentId, attendanceDate, createdAt, updatedAt, note);
}
