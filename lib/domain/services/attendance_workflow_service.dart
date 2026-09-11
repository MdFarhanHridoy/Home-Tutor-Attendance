import '../../core/utils/date_util.dart';
import '../entities/attendance_record.dart';
import '../entities/routine_period.dart';
import '../entities/student.dart';
import '../entities/year_month.dart';
import '../repositories/attendance_repository.dart';
import '../repositories/routine_periods_repository.dart';
import '../repositories/students_repository.dart';
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

/// Use-case layer for the date attendance workflow (PRD §9.3, §27).
///
/// Assembles picker rows (students + weekly allowance + recorded flag) and
/// performs add/remove with duplicate protection delegated to the
/// repository/database constraints.
class AttendanceWorkflowService {
  AttendanceWorkflowService({
    required StudentsRepository studentsRepository,
    required RoutinePeriodsRepository routinePeriodsRepository,
    required AttendanceRepository attendanceRepository,
    this.allowanceService = const WeeklyAllowanceService(),
  }) : _students = studentsRepository,
       _routinePeriods = routinePeriodsRepository,
       _attendance = attendanceRepository;

  final StudentsRepository _students;
  final RoutinePeriodsRepository _routinePeriods;
  final AttendanceRepository _attendance;

  /// Weekly-cap computation (injectable for tests).
  final WeeklyAllowanceService allowanceService;

  /// Currently-teaching students, alphabetical, with their weekly allowance
  /// and whether they are already recorded on [date] (PRD §9.3).
  Future<List<AttendanceCandidate>> pickerCandidatesForDate(
    DateTime date,
  ) async {
    final DateTime day = DateUtil.dateOnly(date);
    final YearMonth month = YearMonth.fromDateTime(day);

    final List<Student> students = await _students.findAll();
    final List<Student> teaching =
        students.where((Student s) => s.currentlyTeaching).toList()
          ..sort((Student a, Student b) => a.name.compareTo(b.name));
    if (teaching.isEmpty) {
      return const <AttendanceCandidate>[];
    }

    final List<AttendanceRecord> monthRecords = await _attendance.between(
      month.monthStart,
      month.monthEnd,
    );
    final List<AttendanceRecord> dayRecords = await _attendance.forDate(day);
    final Set<String> recordedStudentIds = dayRecords
        .map((AttendanceRecord r) => r.studentId)
        .toSet();

    final List<AttendanceCandidate> candidates = <AttendanceCandidate>[];
    for (final Student student in teaching) {
      final List<RoutinePeriod> routines = await _routinePeriods.forStudent(
        student.id,
      );
      final List<AttendanceRecord> studentMonthRecords = monthRecords
          .where((AttendanceRecord r) => r.studentId == student.id)
          .toList();
      candidates.add(
        AttendanceCandidate(
          student: student,
          allowance: allowanceService.compute(
            date: day,
            routines: routines,
            attendance: studentMonthRecords,
          ),
          recorded: recordedStudentIds.contains(student.id),
        ),
      );
    }
    return candidates;
  }

  /// Adds an attendance record; throws [DuplicateAttendanceException] when
  /// the student already has one for the date.
  Future<AttendanceRecord> addAttendance({
    required String studentId,
    required DateTime date,
  }) {
    return _attendance.add(studentId: studentId, attendanceDate: date);
  }

  /// Removes one attendance record by ID.
  Future<void> removeAttendance(String recordId) {
    return _attendance.removeById(recordId);
  }
}
