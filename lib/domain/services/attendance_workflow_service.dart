import '../../core/utils/date_util.dart';
import '../entities/attendance_record.dart';
import '../entities/routine_period.dart';
import '../entities/student.dart';
import '../entities/teaching_period.dart';
import '../repositories/attendance_repository.dart';
import '../repositories/routine_periods_repository.dart';
import '../repositories/students_repository.dart';
import '../repositories/teaching_periods_repository.dart';
import 'weekly_allowance_service.dart';

/// One candidate row of the attendance picker for a single date.
class AttendanceCandidate {
  const AttendanceCandidate({
    required this.student,
    required this.allowance,
    required this.recorded,
  });

  final Student student;
  final WeeklyAllowance allowance;
  final bool recorded;
}

/// Thrown when adding attendance would exceed the student's weekly
/// allowance including carry-over (BR-10/AC-22 — blocked, not confirmed).
class WeeklyLimitExceededException implements Exception {
  const WeeklyLimitExceededException(
    this.studentId,
    this.date,
    this.maxAttendance,
  );

  final String studentId;
  final DateTime date;
  final int maxAttendance;

  @override
  String toString() =>
      'WeeklyLimitExceededException: student $studentId allows at most '
      '$maxAttendance attendance days in the week of ${DateUtil.toIsoDate(date)}';
}

/// Use-case layer for the date attendance workflow (PRD §9.3, §27, §10.6).
///
/// Assembles picker rows and performs add/remove with duplicate protection
/// (repository + database) and the weekly-cap block.
class AttendanceWorkflowService {
  AttendanceWorkflowService({
    required StudentsRepository studentsRepository,
    required TeachingPeriodsRepository teachingPeriodsRepository,
    required RoutinePeriodsRepository routinePeriodsRepository,
    required AttendanceRepository attendanceRepository,
    this.allowanceService = const WeeklyAllowanceService(),
  }) : _students = studentsRepository,
       _teachingPeriods = teachingPeriodsRepository,
       _routinePeriods = routinePeriodsRepository,
       _attendance = attendanceRepository;

  final StudentsRepository _students;
  final TeachingPeriodsRepository _teachingPeriods;
  final RoutinePeriodsRepository _routinePeriods;
  final AttendanceRepository _attendance;

  /// Weekly-cap computation (public for tests/injection).
  final WeeklyAllowanceService allowanceService;

  /// Currently-teaching students, alphabetical, with their weekly allowance
  /// and whether they are already recorded on [date] (PRD §9.3).
  Future<List<AttendanceCandidate>> pickerCandidatesForDate(
    DateTime date,
  ) async {
    final DateTime day = DateUtil.dateOnly(date);
    final List<AttendanceRecord> dayRecords = await _attendance.forDate(day);
    final Set<String> recordedStudentIds = dayRecords
        .map((AttendanceRecord r) => r.studentId)
        .toSet();

    final List<Student> students = await _students.findAll();
    final List<Student> teaching =
        students.where((Student s) => s.currentlyTeaching).toList()
          ..sort((Student a, Student b) => a.name.compareTo(b.name));
    if (teaching.isEmpty) {
      return const <AttendanceCandidate>[];
    }

    final List<AttendanceCandidate> candidates = <AttendanceCandidate>[];
    for (final Student student in teaching) {
      final allowance = await _allowanceFor(student.id, day);
      candidates.add(
        AttendanceCandidate(
          student: student,
          allowance: allowance,
          recorded: recordedStudentIds.contains(student.id),
        ),
      );
    }
    return candidates;
  }

  /// Adds an attendance record.
  ///
  /// Throws [WeeklyLimitExceededException] when the weekly allowance
  /// (including carry-over) is exhausted (BR-10) and
  /// [DuplicateAttendanceException] when the student already has a record
  /// for the date (PRD §11.5).
  Future<AttendanceRecord> addAttendance({
    required String studentId,
    required DateTime date,
  }) async {
    final DateTime day = DateUtil.dateOnly(date);
    final WeeklyAllowance allowance = await _allowanceFor(studentId, day);
    if (!allowance.canAddAttendance) {
      throw WeeklyLimitExceededException(
        studentId,
        day,
        allowance.maxAttendance,
      );
    }
    return _attendance.add(studentId: studentId, attendanceDate: day);
  }

  /// Removes one attendance record by ID.
  Future<void> removeAttendance(String recordId) {
    return _attendance.removeById(recordId);
  }

  Future<WeeklyAllowance> _allowanceFor(String studentId, DateTime day) async {
    final List<TeachingPeriod> periods = await _teachingPeriods.forStudent(
      studentId,
    );
    final List<RoutinePeriod> routines = await _routinePeriods.forStudent(
      studentId,
    );

    // Carry-over accumulates from the student's first active week, so fetch
    // attendance across the whole history; +14 days covers the current
    // week's end when a week spans a month boundary (Edge Case 11).
    DateTime rangeStart = DateUtil.addDays(day, 14);
    for (final TeachingPeriod period in periods) {
      if (period.startDate.isBefore(rangeStart)) {
        rangeStart = period.startDate;
      }
    }
    for (final RoutinePeriod routine in routines) {
      if (routine.startDate.isBefore(rangeStart)) {
        rangeStart = routine.startDate;
      }
    }
    final List<AttendanceRecord> history = await _attendance.forStudentBetween(
      studentId,
      rangeStart,
      DateUtil.addDays(day, 14),
    );
    return allowanceService.compute(
      date: day,
      periods: periods,
      routines: routines,
      attendance: history,
    );
  }
}
