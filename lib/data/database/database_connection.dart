import 'package:drift/drift.dart' show QueryExecutor;
import 'package:drift_flutter/drift_flutter.dart';

/// Opens the on-device database connection (PRD §22: local-first; the file
/// remains the source of truth). Native SQLite is provided through the
/// sqlite3 build hooks pulled in by drift_flutter.
QueryExecutor openAppDatabaseConnection() =>
    driftDatabase(name: 'home_tutor_attendance');
