import '../../core/utils/date_util.dart';

/// A calendar month (year + month) without day/time precision.
///
/// Used by monthly calculations (PRD §13) and the six-month goal window
/// (PRD §9.8). All derived dates are normalized date-only values.
class YearMonth {
  const YearMonth(this.year, this.month)
    : assert(year >= 1, 'year must be positive'),
      assert(month >= 1 && month <= 12, 'month must be 1-12');

  final int year;
  final int month;

  factory YearMonth.fromDateTime(DateTime date) =>
      YearMonth(date.year, date.month);

  /// First day of the month (date-only).
  DateTime get monthStart => DateTime.utc(year, month, 1);

  /// Last day of the month (date-only); handles month/year rollover and
  /// leap-year February.
  DateTime get monthEnd => DateTime.utc(year, month + 1, 0);

  /// The month immediately before this one.
  YearMonth previous() =>
      month == 1 ? YearMonth(year - 1, 12) : YearMonth(year, month - 1);

  /// The month immediately after this one.
  YearMonth next() =>
      month == 12 ? YearMonth(year + 1, 1) : YearMonth(year, month + 1);

  /// Whether [date] lies inside this month.
  bool contains(DateTime date) => date.year == year && date.month == month;

  @override
  bool operator ==(Object other) =>
      other is YearMonth && other.year == year && other.month == month;

  @override
  int get hashCode => Object.hash(year, month);

  @override
  String toString() => DateUtil.toIsoDate(monthStart).substring(0, 7);
}
