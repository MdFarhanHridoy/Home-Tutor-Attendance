/// A period during which the tutor actively taught a student (PRD §11.3).
///
/// An open period (`endDate == null`) means teaching is ongoing. Historical
/// periods are immutable in normal flows: stopping teaching closes the open
/// period; reactivating creates a NEW period rather than editing old ones
/// (implementation.md §5.2).
class TeachingPeriod {
  const TeachingPeriod({
    required this.id,
    required this.studentId,
    required this.startDate,
    required this.createdAt,
    required this.updatedAt,
    this.endDate,
  });

  final String id;
  final String studentId;
  final DateTime startDate; // date-only
  final DateTime? endDate; // date-only; null = ongoing
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isOpen => endDate == null;

  TeachingPeriod copyWith({
    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,
    DateTime? updatedAt,
  }) {
    return TeachingPeriod(
      id: id,
      studentId: studentId,
      startDate: startDate ?? this.startDate,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is TeachingPeriod &&
        other.id == id &&
        other.studentId == studentId &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode =>
      Object.hash(id, studentId, startDate, endDate, createdAt, updatedAt);
}
