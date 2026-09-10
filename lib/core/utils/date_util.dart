/// Date-only helpers enforcing the project's date semantics.
///
/// All business dates (teaching start/end, routine effective dates, attendance
/// dates) are calendar dates without time-of-day, normalized to UTC midnight
/// so comparisons never suffer timezone or DST shifts. Persistence uses the
/// `YYYY-MM-DD` textual form (implementation.md §6.2, PRD §10.2).
class DateUtil {
  const DateUtil._();

  /// Normalizes any [DateTime] to a UTC-midnight calendar date.
  static DateTime dateOnly(DateTime value) =>
      DateTime.utc(value.year, value.month, value.day);

  /// Formats a date as `YYYY-MM-DD`.
  static String toIsoDate(DateTime value) {
    final DateTime d = dateOnly(value);
    final String y = d.year.toString().padLeft(4, '0');
    final String m = d.month.toString().padLeft(2, '0');
    final String day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  /// Parses a `YYYY-MM-DD` string into a normalized date-only [DateTime].
  static DateTime fromIsoDate(String iso) {
    final List<String> parts = iso.split('-');
    if (parts.length != 3) {
      throw FormatException('Expected YYYY-MM-DD date, got: $iso');
    }
    return DateTime.utc(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  /// Adds [days] to a date-only value, returning a normalized date.
  /// (DateTime.utc arithmetic handles month/year/leap-day rollover.)
  static DateTime addDays(DateTime date, int days) =>
      DateTime.utc(date.year, date.month, date.day + days);

  /// Whether two values are the same calendar date.
  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
