import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/providers.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../domain/entities/attendance_record.dart';
import '../../../../domain/entities/year_month.dart';

/// "Today" as a date-only value, resolved from device-local time
/// (PRD §10.2 timezone note). Override in tests for determinism.
final calendarTodayProvider = Provider<DateTime>((Ref ref) {
  return DateUtil.dateOnly(clock.now());
});

/// Which month the home calendar is showing; starts on the current month
/// (AC-01).
class CalendarController extends Notifier<YearMonth> {
  @override
  YearMonth build() => YearMonth.fromDateTime(ref.read(calendarTodayProvider));

  void previousMonth() {
    state = state.previous();
  }

  void nextMonth() {
    state = state.next();
  }

  void goToToday() {
    state = YearMonth.fromDateTime(ref.read(calendarTodayProvider));
  }
}

final calendarControllerProvider =
    NotifierProvider<CalendarController, YearMonth>(CalendarController.new);

/// Live attendance records inside the shown month (for calendar chips).
final monthAttendanceProvider =
    StreamProvider.family<List<AttendanceRecord>, YearMonth>((
      Ref ref,
      YearMonth month,
    ) {
      return ref
          .watch(attendanceRepositoryProvider)
          .watchBetween(month.monthStart, month.monthEnd);
    });
