import '../entities/routine_period.dart';

/// Storage contract for historical routine periods (PRD §31 Level B, §32).
abstract class RoutinePeriodsRepository {
  /// Inserts a new routine period or persists changes to an existing one
  /// (e.g. closing the previous routine when it changes).
  Future<void> save(RoutinePeriod period);

  /// All routine periods for a student, oldest first.
  Future<List<RoutinePeriod>> forStudent(String studentId);

  /// The routine period that is still open, or null.
  Future<RoutinePeriod?> openPeriodForStudent(String studentId);
}
