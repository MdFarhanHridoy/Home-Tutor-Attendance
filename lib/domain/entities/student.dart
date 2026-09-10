import 'weekday.dart';

/// A student/tuition record (PRD §11.2).
///
/// [routineWeekdays] and [weeklyDays] are the CURRENT routine snapshot for
/// fast UI reads; the authoritative routine history lives in routine periods
/// so historical calculations are never rewritten by later edits (PRD §31/§32,
/// implementation.md §5.3).
class Student {
  const Student({
    required this.id,
    required this.name,
    required this.weeklyDays,
    required this.routineWeekdays,
    required this.color,
    required this.currentlyTeaching,
    required this.startDate,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.guardianName,
    this.address,
    this.notes,
    this.archivedAt,
  });

  final String id;
  final String name;
  final int weeklyDays;
  final List<Weekday> routineWeekdays;
  final String color;
  final bool currentlyTeaching;
  final DateTime startDate; // date-only
  final String? phone;
  final String? guardianName;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;

  Student copyWith({
    String? name,
    int? weeklyDays,
    List<Weekday>? routineWeekdays,
    String? color,
    bool? currentlyTeaching,
    DateTime? startDate,
    String? phone,
    String? guardianName,
    String? address,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? archivedAt,
  }) {
    return Student(
      id: id,
      name: name ?? this.name,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      routineWeekdays: routineWeekdays ?? this.routineWeekdays,
      color: color ?? this.color,
      currentlyTeaching: currentlyTeaching ?? this.currentlyTeaching,
      startDate: startDate ?? this.startDate,
      phone: phone ?? this.phone,
      guardianName: guardianName ?? this.guardianName,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Student &&
        other.id == id &&
        other.name == name &&
        other.weeklyDays == weeklyDays &&
        _sameWeekdays(other.routineWeekdays) &&
        other.color == color &&
        other.currentlyTeaching == currentlyTeaching &&
        other.startDate == startDate &&
        other.phone == phone &&
        other.guardianName == guardianName &&
        other.address == address &&
        other.notes == notes &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.archivedAt == archivedAt;
  }

  bool _sameWeekdays(List<Weekday> other) {
    if (other.length != routineWeekdays.length) {
      return false;
    }
    for (int i = 0; i < routineWeekdays.length; i++) {
      if (other[i] != routineWeekdays[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    weeklyDays,
    Object.hashAll(routineWeekdays),
    color,
    currentlyTeaching,
    startDate,
    phone,
    guardianName,
    address,
    notes,
    createdAt,
    updatedAt,
    archivedAt,
  );
}
