import '../entities/teaching_period.dart';

/// Storage contract for historical teaching periods (PRD §11.3).
abstract class TeachingPeriodsRepository {
  /// Inserts a new period or persists changes to an existing one (e.g.
  /// closing the open period when teaching stops).
  Future<void> save(TeachingPeriod period);

  /// All periods for a student, oldest first.
  Future<List<TeachingPeriod>> forStudent(String studentId);

  /// The period that is still open (ongoing teaching), or null.
  Future<TeachingPeriod?> openPeriodForStudent(String studentId);
}
