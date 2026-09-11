import '../../core/utils/date_util.dart';
import '../entities/attendance_record.dart';
import '../entities/student.dart';
import '../repositories/attendance_repository.dart';
import '../repositories/students_repository.dart';

/// One candidate row of the attendance picker for a single date.
class AttendanceCandidate {
  const AttendanceCandidate({required this.student, required this.recorded});

  final Student student;
  final bool recorded;
}

/// Use-case layer for the date attendance workflow (PRD §9.3, §27; v1.2
/// amendment: attendance may be recorded for any student on any date —
/// no weekly cap).
///
/// Duplicate protection stays (UI + repository + database constraint).
class AttendanceWorkflowService {
  AttendanceWorkflowService({
    required StudentsRepository studentsRepository,
    required AttendanceRepository attendanceRepository,
  }) : _students = studentsRepository,
       _attendance = attendanceRepository;

  final StudentsRepository _students;
  final AttendanceRepository _attendance;

  /// Currently-teaching students, alphabetical, with whether they are
  /// already recorded on [date] (PRD §9.3).
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
    return <AttendanceCandidate>[
      for (final Student student in teaching)
        AttendanceCandidate(
          student: student,
          recorded: recordedStudentIds.contains(student.id),
        ),
    ];
  }

  /// Adds an attendance record; throws [DuplicateAttendanceException] when
  /// the student already has one for the date (PRD §11.5). No other limits
  /// apply (v1.2).
  Future<AttendanceRecord> addAttendance({
    required String studentId,
    required DateTime date,
  }) {
    return _attendance.add(
      studentId: studentId,
      attendanceDate: DateUtil.dateOnly(date),
    );
  }

  /// Removes one attendance record by ID.
  Future<void> removeAttendance(String recordId) {
    return _attendance.removeById(recordId);
  }
}
