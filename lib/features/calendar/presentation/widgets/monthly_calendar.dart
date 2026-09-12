import 'package:flutter/material.dart';

import '../../../../core/constants/student_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../domain/entities/attendance_record.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/entities/weekday.dart';
import '../../../../domain/entities/year_month.dart';

/// Dense monthly calendar grid, Samsung-inspired (PRD §9.1, §26).
///
/// - weeks always start on Friday (BR-11, AC-21);
/// - up to six week rows, variable when fewer are needed;
/// - today's day number is circled (AC-02);
/// - each date cell lists attendance chips in the students' colors and
///   collapses extras behind "+N more".
///
/// The widget is pure: it renders exactly the month, records, and students
/// it is given — all calendar math stays here, all data assembly stays with
/// the caller.
class MonthlyCalendar extends StatelessWidget {
  const MonthlyCalendar({
    required this.month,
    required this.today,
    required this.recordsByDate,
    required this.studentById,
    required this.onDateSelected,
    super.key,
  });

  /// Weekday column order, Friday-first (BR-11).
  static const List<Weekday> weekOrder = <Weekday>[
    Weekday.friday,
    Weekday.saturday,
    Weekday.sunday,
    Weekday.monday,
    Weekday.tuesday,
    Weekday.wednesday,
    Weekday.thursday,
  ];

  /// Attendance chips fully rendered per cell before the "+N more"
  /// overflow (user request 2026-09-12: up to five names fit a date cell).
  static const int maxVisibleChips = 5;

  final YearMonth month;
  final DateTime today;
  final Map<DateTime, List<AttendanceRecord>> recordsByDate;
  final Map<String, Student> studentById;
  final void Function(DateTime date) onDateSelected;

  /// Blank cells before the first day of the month (Friday-first layout).
  int get leadingBlanks =>
      weekOrder.indexOf(Weekday.fromDateTime(month.monthStart));

  /// Number of week rows needed for this month (max 6).
  int get rowCount => (leadingBlanks + month.monthEnd.day + 6) ~/ 7;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Column(
      children: <Widget>[
        Row(
          key: const Key('weekday-header'),
          children: <Widget>[
            for (final Weekday weekday in weekOrder)
              Expanded(
                child: Center(
                  child: Text(
                    weekday.shortLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Column(
            children: <Widget>[
              for (int row = 0; row < rowCount; row++)
                Expanded(
                  child: Row(
                    children: <Widget>[
                      for (int column = 0; column < 7; column++)
                        Expanded(child: _cell(context, row * 7 + column)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cell(BuildContext context, int cellIndex) {
    final int day = cellIndex - leadingBlanks + 1;
    if (day < 1 || day > month.monthEnd.day) {
      return const SizedBox.expand();
    }

    final DateTime date = DateTime.utc(month.year, month.month, day);
    final bool isToday = DateUtil.isSameDay(date, today);
    final List<AttendanceRecord> records =
        recordsByDate[date] ?? const <AttendanceRecord>[];

    return Semantics(
      label: _semanticLabel(date, isToday, records.length),
      button: true,
      excludeSemantics: true,
      child: InkWell(
        key: Key('cal-day-${DateUtil.toIsoDate(date)}'),
        onTap: () => onDateSelected(date),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          // The cell keeps its full-width layout but scales down (never
          // up) when five chips plus the day badge exceed the available
          // cell height, so no date cell ever overflows.
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.topStart,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _dayBadge(context, day, isToday),
                      for (
                        int i = 0;
                        i < records.length && i < maxVisibleChips;
                        i++
                      )
                        _Chip(
                          record: records[i],
                          student: studentById[records[i].studentId],
                        ),
                      if (records.length > maxVisibleChips)
                        Padding(
                          padding: const EdgeInsets.only(top: 1, left: 2),
                          child: Text(
                            '+${records.length - maxVisibleChips} more',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  fontSize: 9,
                                ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Screen-reader label for a day cell, e.g.
  /// "9 Sep 2026, today, 2 students recorded".
  String _semanticLabel(DateTime date, bool isToday, int recordCount) {
    final String base = AppDateFormats.shortDate(date);
    final List<String> parts = <String>[
      if (isToday) '$base, today' else base,
      if (recordCount > 0)
        '$recordCount ${recordCount == 1 ? 'student' : 'students'} recorded',
    ];
    return parts.join(', ');
  }

  Widget _dayBadge(BuildContext context, int day, bool isToday) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    if (isToday) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          key: const Key('today-marker'),
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.primary,
          ),
          child: Text(
            '$day',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: scheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text('$day', style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.record, required this.student});

  final AttendanceRecord record;
  final Student? student;

  @override
  Widget build(BuildContext context) {
    final String name = student?.name ?? 'Unknown';
    final String firstName = name.trim().split(' ').first;
    final Color color = student == null
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : colorFromHex(student!.color);
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Container(
        height: 14,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        alignment: AlignmentDirectional.centerStart,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          firstName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.black87, fontSize: 9.5),
        ),
      ),
    );
  }
}
