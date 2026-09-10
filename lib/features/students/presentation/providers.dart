import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/providers.dart';
import '../../../../domain/entities/routine_period.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/entities/teaching_period.dart';
import '../../../../domain/services/student_management_service.dart';

/// Use-case service for student management.
final studentManagementServiceProvider = Provider<StudentManagementService>((
  Ref ref,
) {
  return StudentManagementService(
    studentsRepository: ref.watch(studentsRepositoryProvider),
    teachingPeriodsRepository: ref.watch(teachingPeriodsRepositoryProvider),
    routinePeriodsRepository: ref.watch(routinePeriodsRepositoryProvider),
  );
});

/// Live list of all students.
final studentsStreamProvider = StreamProvider<List<Student>>(
  (Ref ref) => ref.watch(studentsRepositoryProvider).watchAll(),
);

/// Teaching-period history for one student.
final teachingPeriodsForStudentProvider =
    FutureProvider.family<List<TeachingPeriod>, String>((
      Ref ref,
      String studentId,
    ) {
      return ref.watch(teachingPeriodsRepositoryProvider).forStudent(studentId);
    });

/// Routine-period history for one student.
final routinePeriodsForStudentProvider =
    FutureProvider.family<List<RoutinePeriod>, String>((
      Ref ref,
      String studentId,
    ) {
      return ref.watch(routinePeriodsRepositoryProvider).forStudent(studentId);
    });
