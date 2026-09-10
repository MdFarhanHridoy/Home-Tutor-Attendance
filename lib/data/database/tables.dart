import 'package:drift/drift.dart';

import 'converters.dart';

/// Students (PRD §11.2). `routine_weekdays`/`weekly_days` are the CURRENT
/// routine snapshot; authoritative history lives in [RoutinePeriods].
@DataClassName('StudentRow')
class Students extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get weeklyDays => integer()();
  TextColumn get routineWeekdays => text().map(const WeekdayListConverter())();
  TextColumn get color => text()();
  BoolColumn get currentlyTeaching =>
      boolean().withDefault(const Constant(true))();
  TextColumn get startDate => text().map(const DateOnlyConverter())();
  TextColumn get phone => text().nullable()();
  TextColumn get guardianName => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}

/// Historical teaching periods (PRD §11.3): which ranges the tutor actively
/// taught a student.
@DataClassName('TeachingPeriodRow')
@TableIndex(
  name: 'idx_teaching_periods_student_dates',
  columns: {#studentId, #startDate, #endDate},
)
class TeachingPeriods extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text().references(Students, #id)();
  TextColumn get startDate => text().map(const DateOnlyConverter())();
  TextColumn get endDate => text().nullable().map(const DateOnlyConverter())();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}

/// Historical routine periods (PRD §31 Level B, §32): which weekly routine
/// was effective during which range.
@DataClassName('RoutinePeriodRow')
@TableIndex(
  name: 'idx_routine_periods_student_dates',
  columns: {#studentId, #startDate, #endDate},
)
class RoutinePeriods extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text().references(Students, #id)();
  TextColumn get startDate => text().map(const DateOnlyConverter())();
  TextColumn get endDate => text().nullable().map(const DateOnlyConverter())();
  IntColumn get weeklyDays => integer()();
  TextColumn get weekdays => text().map(const WeekdayListConverter())();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}

/// Attendance facts (PRD §11.5): a student was actually taught on a date.
/// UNIQUE (student_id, attendance_date) is enforced at the database level.
@DataClassName('AttendanceRecordRow')
@TableIndex(name: 'idx_attendance_date', columns: {#attendanceDate})
@TableIndex(
  name: 'idx_attendance_student_date',
  columns: {#studentId, #attendanceDate},
)
class AttendanceRecords extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text().references(Students, #id)();
  TextColumn get attendanceDate => text().map(const DateOnlyConverter())();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {studentId, attendanceDate},
  ];
}

/// Singleton app-settings row (PRD §11.6).
@DataClassName('AppSettingsRow')
class AppSettingsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get themeMode => text().withDefault(const Constant('dark'))();
  TextColumn get firstDayOfWeek =>
      text().withDefault(const Constant('friday'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{id};

  @override
  String get tableName => 'app_settings';
}
