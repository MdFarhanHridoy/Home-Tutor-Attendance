/// Minimal English-only date formatting helpers (no `intl` dependency yet —
/// PRD v1 is English-only; introduce `intl` when localization lands).
class AppDateFormats {
  const AppDateFormats._();

  static const List<String> _months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<String> _monthsFull = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// e.g. `9 Sep 2026`.
  static String shortDate(DateTime date) =>
      '${date.day} ${_months[date.month - 1]} ${date.year}';

  /// e.g. `September 2026`.
  static String monthYear(int year, int month) =>
      '${_monthsFull[month - 1]} $year';

  /// e.g. `Sun, Tue, Thu`.
  static String weekdayList(Iterable<String> shortLabels) =>
      shortLabels.join(', ');
}
