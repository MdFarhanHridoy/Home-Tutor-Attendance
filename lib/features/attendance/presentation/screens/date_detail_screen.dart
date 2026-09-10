import 'package:flutter/material.dart';

import '../../../../core/utils/date_format.dart';
import '../../../../core/utils/date_util.dart';

/// Date details screen (PRD §9.3 / §27): attendance list for one date.
///
/// Phase 4 establishes the route and shell; Phase 5 implements the
/// attendance list, student picker, and add/remove workflow.
class DateDetailScreen extends StatelessWidget {
  const DateDetailScreen({super.key, required this.isoDate});

  final String isoDate;

  @override
  Widget build(BuildContext context) {
    final DateTime? date = _parse();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          date == null ? 'Invalid date' : AppDateFormats.shortDate(date),
        ),
      ),
      body: Center(
        child: date == null
            ? const Text('This date could not be read.')
            : const Text('Attendance for this date will appear here.'),
      ),
    );
  }

  DateTime? _parse() {
    try {
      return DateUtil.fromIsoDate(isoDate);
    } on FormatException {
      return null;
    }
  }
}
