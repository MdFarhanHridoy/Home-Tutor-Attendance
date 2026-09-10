import 'weekday.dart';

/// A period during which a specific weekly routine was effective for a
/// student (PRD §31 Level B, §32).
///
/// Historical scheduled-day calculations use the routine that was effective
/// on each date, so changing today's routine never rewrites history.
class RoutinePeriod {
  const RoutinePeriod({
    required this.id,
    required this.studentId,
    required this.startDate,
    required this.weeklyDays,
    required this.weekdays,
    required this.createdAt,
    required this.updatedAt,
    this.endDate,
  });

  final String id;
  final String studentId;
  final DateTime startDate; // date-only
  final DateTime? endDate; // date-only; null = ongoing
  final int weeklyDays; // 1–7; must equal weekdays.length
  final List<Weekday> weekdays;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isOpen => endDate == null;

  RoutinePeriod copyWith({
    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,
    int? weeklyDays,
    List<Weekday>? weekdays,
    DateTime? updatedAt,
  }) {
    return RoutinePeriod(
      id: id,
      studentId: studentId,
      startDate: startDate ?? this.startDate,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      weeklyDays: weeklyDays ?? this.weeklyDays,
      weekdays: weekdays ?? this.weekdays,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is RoutinePeriod &&
        other.id == id &&
        other.studentId == studentId &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.weeklyDays == weeklyDays &&
        _sameWeekdays(other.weekdays) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  bool _sameWeekdays(List<Weekday> other) {
    if (other.length != weekdays.length) {
      return false;
    }
    for (int i = 0; i < weekdays.length; i++) {
      if (other[i] != weekdays[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    id,
    studentId,
    startDate,
    endDate,
    weeklyDays,
    Object.hashAll(weekdays),
    createdAt,
    updatedAt,
  );
}
