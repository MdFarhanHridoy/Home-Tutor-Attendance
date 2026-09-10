import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/utils/date_util.dart';
import '../../domain/entities/weekday.dart';

/// Maps date-only [DateTime]s to `YYYY-MM-DD` TEXT columns (PRD §10.2).
class DateOnlyConverter implements TypeConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromSql(String fromDb) => DateUtil.fromIsoDate(fromDb);

  @override
  String toSql(DateTime value) => DateUtil.toIsoDate(value);
}

/// Maps weekday lists to JSON TEXT columns using the PRD 0–6 codes
/// (0 = Monday … 6 = Sunday).
class WeekdayListConverter implements TypeConverter<List<Weekday>, String> {
  const WeekdayListConverter();

  @override
  List<Weekday> fromSql(String fromDb) {
    final List<dynamic> decoded = jsonDecode(fromDb) as List<dynamic>;
    return decoded
        .map((dynamic code) => Weekday.fromCode(code as int))
        .toList();
  }

  @override
  String toSql(List<Weekday> value) =>
      jsonEncode(value.map((Weekday w) => w.code).toList());
}
