/// The seven weekdays of a routine.
///
/// [code] follows the PRD §11.4 convention (0 = Monday … 6 = Sunday);
/// [dateTimeValue] maps onto [DateTime.weekday] (1 = Monday … 7 = Sunday).
enum Weekday {
  monday(0, DateTime.monday, 'Mon'),
  tuesday(1, DateTime.tuesday, 'Tue'),
  wednesday(2, DateTime.wednesday, 'Wed'),
  thursday(3, DateTime.thursday, 'Thu'),
  friday(4, DateTime.friday, 'Fri'),
  saturday(5, DateTime.saturday, 'Sat'),
  sunday(6, DateTime.sunday, 'Sun');

  const Weekday(this.code, this.dateTimeValue, this.shortLabel);

  final int code;
  final int dateTimeValue;
  final String shortLabel;

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
