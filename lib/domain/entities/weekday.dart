/// The seven weekdays of a routine.
///
/// [code] follows the PRD §11.4 convention (0 = Monday … 6 = Sunday);
/// [dateTimeValue] maps onto [DateTime.weekday] (1 = Monday … 7 = Sunday).
enum Weekday {
  monday(0, DateTime.monday, 'Mon', 'Monday'),
  tuesday(1, DateTime.tuesday, 'Tue', 'Tuesday'),
  wednesday(2, DateTime.wednesday, 'Wed', 'Wednesday'),
  thursday(3, DateTime.thursday, 'Thu', 'Thursday'),
  friday(4, DateTime.friday, 'Fri', 'Friday'),
  saturday(5, DateTime.saturday, 'Sat', 'Saturday'),
  sunday(6, DateTime.sunday, 'Sun', 'Sunday');

  const Weekday(this.code, this.dateTimeValue, this.shortLabel, this.fullLabel);

  final int code;
  final int dateTimeValue;
  final String shortLabel;
  final String fullLabel;

  /// Resolves a PRD weekday code (0–6). Throws [ArgumentError] otherwise.
  static Weekday fromCode(int code) {
    for (final Weekday weekday in values) {
      if (weekday.code == code) {
        return weekday;
      }
    }
    throw ArgumentError('Invalid weekday code: $code');
  }

  /// Resolves the weekday of a calendar date.
  static Weekday fromDateTime(DateTime date) {
    for (final Weekday weekday in values) {
      if (weekday.dateTimeValue == date.weekday) {
        return weekday;
      }
    }
    throw ArgumentError('Invalid DateTime.weekday: ${date.weekday}');
  }
}
