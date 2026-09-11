import 'package:clock/clock.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/date_util.dart';
import '../entities/routine_period.dart';
import '../entities/student.dart';
import '../entities/teaching_period.dart';
import '../entities/weekday.dart';
import '../repositories/routine_periods_repository.dart';
import '../repositories/students_repository.dart';
import '../repositories/teaching_periods_repository.dart';

/// Use-case layer for student management (implementation.md §13.3).
///
/// Owns the teaching/routine period lifecycle so the UI never manipulates
/// history directly (PRD §31 Level B, §51, §52 Edge Cases 8–9):
///
/// - create → student row + open teaching period + open routine period;
/// - profile edits (name/color/contacts) never touch periods;
/// - routine change → close the open routine period the day before the
///   change and open a new one effective today (history stays intact);
/// - deactivate → close open teaching AND routine periods the day before,
///   mark the student inactive — history and attendance are preserved;
/// - reactivate → brand-new teaching and routine periods (never edit old
///   ones); routine continues from the student's current snapshot.
class StudentManagementService {
  StudentManagementService({
    required StudentsRepository studentsRepository,
    required TeachingPeriodsRepository teachingPeriodsRepository,
    required RoutinePeriodsRepository routinePeriodsRepository,
    this.clock = const Clock(),
    Uuid uuidGenerator = const Uuid(),
  }) : _students = studentsRepository,
       _teachingPeriods = teachingPeriodsRepository,
       _routinePeriods = routinePeriodsRepository,
       _uuid = uuidGenerator;

  final StudentsRepository _students;
  final TeachingPeriodsRepository _teachingPeriods;
  final RoutinePeriodsRepository _routinePeriods;

  /// Injectable "now" for deterministic lifecycle dates in tests.
  final Clock clock;
  final Uuid _uuid;

  /// Creates a student and opens their initial periods from [startDate].
  Future<Student> createStudent({
    required String name,
    required int weeklyDays,
    required List<Weekday> routineWeekdays,
    required String color,
    required DateTime startDate,
    String? phone,
    String? guardianName,
    String? address,
    String? notes,
  }) async {
    _validate(name: name, weeklyDays: weeklyDays, weekdays: routineWeekdays);
    final DateTime now = clock.now();
    final DateTime start = DateUtil.dateOnly(startDate);
    final String studentId = _uuid.v4();

    final Student student = Student(
      id: studentId,
      name: name.trim(),
      weeklyDays: weeklyDays,
      routineWeekdays: List<Weekday>.of(routineWeekdays),
      color: color,
      currentlyTeaching: true,
      startDate: start,
      createdAt: now,
      updatedAt: now,
      phone: phone?.trim().isEmpty == true ? null : phone?.trim(),
      guardianName: guardianName?.trim().isEmpty == true
          ? null
          : guardianName?.trim(),
      address: address?.trim().isEmpty == true ? null : address?.trim(),
      notes: notes?.trim().isEmpty == true ? null : notes?.trim(),
    );
    await _students.create(student);

    await _teachingPeriods.save(
      TeachingPeriod(
        id: _uuid.v4(),
        studentId: studentId,
        startDate: start,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await _routinePeriods.save(
      RoutinePeriod(
        id: _uuid.v4(),
        studentId: studentId,
        startDate: start,
        weeklyDays: weeklyDays,
        weekdays: List<Weekday>.of(routineWeekdays),
        createdAt: now,
        updatedAt: now,
      ),
    );
    return student;
  }

  /// Updates profile fields only — periods and history are untouched.
  Future<Student> updateProfile({
    required String studentId,
    required String name,
    required String color,
    String? phone,
    String? guardianName,
    String? address,
    String? notes,
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Student name is required');
    }
    final Student? existing = await _students.findById(studentId);
    if (existing == null) {
      throw StateError('Student not found: $studentId');
    }
    final Student updated = Student(
      id: existing.id,
      name: name.trim(),
      weeklyDays: existing.weeklyDays,
      routineWeekdays: existing.routineWeekdays,
      color: color,
      currentlyTeaching: existing.currentlyTeaching,
      startDate: existing.startDate,
      createdAt: existing.createdAt,
      updatedAt: clock.now(),
      phone: phone?.trim().isEmpty == true ? null : phone?.trim(),
      guardianName: guardianName?.trim().isEmpty == true
          ? null
          : guardianName?.trim(),
      address: address?.trim().isEmpty == true ? null : address?.trim(),
      notes: notes?.trim().isEmpty == true ? null : notes?.trim(),
      archivedAt: existing.archivedAt,
    );
    return _students.update(updated);
  }

  /// Changes the routine going forward: the open routine period (if any)
  /// closes the day before today and a new one opens today. Historical
  /// scheduled-day calculations keep using the old period (PRD §31).
  Future<Student> changeRoutine({
    required String studentId,
    required int weeklyDays,
    required List<Weekday> weekdays,
  }) async {
    _validate(name: 'n/a', weeklyDays: weeklyDays, weekdays: weekdays);
    final Student? existing = await _students.findById(studentId);
    if (existing == null) {
      throw StateError('Student not found: $studentId');
    }

    final RoutinePeriod? open = await _routinePeriods.openPeriodForStudent(
      studentId,
    );
    final bool unchanged =
        open != null &&
        open.weeklyDays == weeklyDays &&
        _sameWeekdays(open.weekdays, weekdays);
    if (unchanged) {
      return existing;
    }

    final DateTime now = clock.now();
    final DateTime today = DateUtil.dateOnly(now);
    if (open != null) {
      await _routinePeriods.save(
        open.copyWith(endDate: DateUtil.addDays(today, -1), updatedAt: now),
      );
    }
    await _routinePeriods.save(
      RoutinePeriod(
        id: _uuid.v4(),
        studentId: studentId,
        startDate: today,
        weeklyDays: weeklyDays,
        weekdays: List<Weekday>.of(weekdays),
        createdAt: now,
        updatedAt: now,
      ),
    );
    return _students.update(
      existing.copyWith(
        weeklyDays: weeklyDays,
        routineWeekdays: List<Weekday>.of(weekdays),
        updatedAt: now,
      ),
    );
  }

  /// Deactivates or reactivates teaching (PRD §11.2 active semantics).
  Future<Student> setCurrentlyTeaching({
    required String studentId,
    required bool teaching,
  }) async {
    final Student? existing = await _students.findById(studentId);
    if (existing == null) {
      throw StateError('Student not found: $studentId');
    }
    if (existing.currentlyTeaching == teaching) {
      return existing; // idempotent
    }

    final DateTime now = clock.now();
    final DateTime today = DateUtil.dateOnly(now);

    if (!teaching) {
      // Close open periods the day before today (PRD §51: "OFF as of
      // September 1" ↔ period ends August 31).
      final TeachingPeriod? openTeaching = await _teachingPeriods
          .openPeriodForStudent(studentId);
      if (openTeaching != null) {
        await _teachingPeriods.save(
          openTeaching.copyWith(
            endDate: DateUtil.addDays(today, -1),
            updatedAt: now,
          ),
        );
      }
      final RoutinePeriod? openRoutine = await _routinePeriods
          .openPeriodForStudent(studentId);
      if (openRoutine != null) {
        await _routinePeriods.save(
          openRoutine.copyWith(
            endDate: DateUtil.addDays(today, -1),
            updatedAt: now,
          ),
        );
      }
      return _students.update(
        existing.copyWith(
          currentlyTeaching: false,
          archivedAt: existing.archivedAt ?? now,
          updatedAt: now,
        ),
      );
    }

    // Reactivation: brand-new periods from today (PRD §52 Edge Case 9).
    await _teachingPeriods.save(
      TeachingPeriod(
        id: _uuid.v4(),
        studentId: studentId,
        startDate: today,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await _routinePeriods.save(
      RoutinePeriod(
        id: _uuid.v4(),
        studentId: studentId,
        startDate: today,
        weeklyDays: existing.weeklyDays,
        weekdays: existing.routineWeekdays,
        createdAt: now,
        updatedAt: now,
      ),
    );
    return _students.update(
      existing.copyWith(currentlyTeaching: true, updatedAt: now),
    );
  }

  void _validate({
    required String name,
    required int weeklyDays,
    List<Weekday>? weekdays,
  }) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Student name is required');
    }
    if (weeklyDays < 1 || weeklyDays > 7) {
      throw ArgumentError('Weekly days must be between 1 and 7');
    }
    // Routine weekdays are OPTIONAL (v1.2): the routine is defined by the
    // days-per-week count; weekdays, when provided, are informational.
    if (weekdays != null && weekdays.toSet().length != weekdays.length) {
      throw ArgumentError('Routine weekdays must be unique');
    }
  }

  bool _sameWeekdays(List<Weekday> a, List<Weekday> b) {
    if (a.length != b.length) {
      return false;
    }
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }
}
