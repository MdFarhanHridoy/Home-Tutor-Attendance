import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../domain/entities/attendance_record.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/entities/year_month.dart';
import '../../../students/presentation/providers.dart';
import '../providers.dart';
import '../widgets/monthly_calendar.dart';

/// Home is the monthly calendar and always the initial route (PRD §9.1,
/// AC-01). The AppBar carries the month/year; a slim row below it provides
/// month navigation and the Today shortcut (PRD §34 optional feature).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, this.currentLocation = AppRoutes.home});

  final String currentLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final YearMonth month = ref.watch(calendarControllerProvider);
    final DateTime today = ref.watch(calendarTodayProvider);
    final AsyncValue<List<Student>> studentsAsync = ref.watch(
      studentsStreamProvider,
    );
    final AsyncValue<List<AttendanceRecord>> attendanceAsync = ref.watch(
      monthAttendanceProvider(month),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppDateFormats.monthYear(month.year, month.month)),
      ),
      drawer: AppDrawer(currentLocation: currentLocation),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                key: const Key('prev-month'),
                tooltip: 'Previous month',
                icon: const Icon(Icons.chevron_left),
                onPressed: () => ref
                    .read(calendarControllerProvider.notifier)
                    .previousMonth(),
              ),
              Expanded(
                child: Center(
                  child: TextButton(
                    key: const Key('go-today'),
                    onPressed: () => ref
                        .read(calendarControllerProvider.notifier)
                        .goToToday(),
                    child: const Text('Today'),
                  ),
                ),
              ),
              IconButton(
                key: const Key('next-month'),
                tooltip: 'Next month',
                icon: const Icon(Icons.chevron_right),
                onPressed: () =>
                    ref.read(calendarControllerProvider.notifier).nextMonth(),
              ),
            ],
          ),
          Expanded(
            child: studentsAsync.maybeWhen(
              data: (List<Student> students) {
                return attendanceAsync.maybeWhen(
                  data: (List<AttendanceRecord> records) => _swipeableCalendar(
                    context,
                    ref,
                    month,
                    today,
                    records,
                    students,
                  ),
                  orElse: () =>
                      const Center(child: CircularProgressIndicator()),
                );
              },
              orElse: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  /// Wraps the calendar with horizontal swipe navigation (PRD §34 optional
  /// feature): fling left → next month, fling right → previous month.
  Widget _swipeableCalendar(
    BuildContext context,
    WidgetRef ref,
    YearMonth month,
    DateTime today,
    List<AttendanceRecord> records,
    List<Student> students,
  ) {
    return GestureDetector(
      key: const Key('calendar-swipe-area'),
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (DragEndDetails details) {
        final double? velocity = details.primaryVelocity;
        final CalendarController controller = ref.read(
          calendarControllerProvider.notifier,
        );
        if (velocity == null) {
          return;
        }
        if (velocity <= -250) {
          controller.nextMonth();
        } else if (velocity >= 250) {
          controller.previousMonth();
        }
      },
      child: _calendar(context, month, today, records, students),
    );
  }

  Widget _calendar(
    BuildContext context,
    YearMonth month,
    DateTime today,
    List<AttendanceRecord> records,
    List<Student> students,
  ) {
    final Map<String, Student> studentById = <String, Student>{
      for (final Student student in students) student.id: student,
    };

    // Group records by date; within a date, chips sort alphabetically by
    // student name (PRD §30).
    final Map<DateTime, List<AttendanceRecord>> byDate =
        <DateTime, List<AttendanceRecord>>{};
    for (final AttendanceRecord record in records) {
      byDate
          .putIfAbsent(record.attendanceDate, () => <AttendanceRecord>[])
          .add(record);
    }
    for (final List<AttendanceRecord> list in byDate.values) {
      list.sort((AttendanceRecord a, AttendanceRecord b) {
        final String nameA = studentById[a.studentId]?.name ?? '';
        final String nameB = studentById[b.studentId]?.name ?? '';
        return nameA.compareTo(nameB);
      });
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: MonthlyCalendar(
        month: month,
        today: today,
        recordsByDate: byDate,
        studentById: studentById,
        onDateSelected: (DateTime date) =>
            context.push(AppRoutes.dateDetail(date)),
      ),
    );
  }
}
