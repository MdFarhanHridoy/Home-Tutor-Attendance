import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/student_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../domain/entities/attendance_record.dart';
import '../../../../domain/entities/student.dart';
import '../../../students/presentation/providers.dart';
import '../providers.dart';
import '../widgets/student_picker_sheet.dart';

/// Date details screen (PRD §9.3, §27): Google-style list of students taught
/// on one date, with add (picker) and remove (confirm) workflows.
class DateDetailScreen extends ConsumerWidget {
  const DateDetailScreen({super.key, required this.isoDate});

  final String isoDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime? date = _parse();
    if (date == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Invalid date')),
        body: const Center(child: Text('This date could not be read.')),
      );
    }

    final AsyncValue<List<AttendanceRecord>> recordsAsync = ref.watch(
      attendanceForDateProvider(isoDate),
    );
    final AsyncValue<List<Student>> studentsAsync = ref.watch(
      studentsStreamProvider,
    );

    return Scaffold(
      appBar: AppBar(title: Text(AppDateFormats.shortDate(date))),
      floatingActionButton: FloatingActionButton(
        key: const Key('add-attendance-fab'),
        tooltip: 'Record attendance',
        onPressed: () => _openPicker(context, ref),
        child: const Icon(Icons.add),
      ),
      body: recordsAsync.maybeWhen(
        data: (List<AttendanceRecord> records) {
          return studentsAsync.maybeWhen(
            data: (List<Student> students) =>
                _body(context, ref, records, students),
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
        error: (Object error, StackTrace _) => _ErrorView(message: '$error'),
        orElse: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    List<AttendanceRecord> records,
    List<Student> students,
  ) {
    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(Icons.event_available, size: 48),
            SizedBox(height: 8),
            Text('No attendance recorded for this date'),
            Text('Tap + to record attendance'),
          ],
        ),
      );
    }

    final Map<String, Student> studentById = <String, Student>{
      for (final Student student in students) student.id: student,
    };
    final List<(AttendanceRecord, Student?)> rows =
        records
            .map((AttendanceRecord r) => (r, studentById[r.studentId]))
            .toList()
          ..sort(
            ((AttendanceRecord, Student?) a, (AttendanceRecord, Student?) b) =>
                (a.$2?.name ?? '').compareTo(b.$2?.name ?? ''),
          );

    return ListView(
      padding: const EdgeInsets.all(12),
      children: <Widget>[
        for (final (AttendanceRecord record, Student? student) in rows)
          _AttendanceCard(
            key: Key('attendance-card-${record.studentId}'),
            record: record,
            student: student,
            onRemove: () => _confirmRemove(context, ref, record, student),
          ),
      ],
    );
  }

  void _openPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) =>
          StudentPickerSheet(isoDate: isoDate),
    );
  }

  Future<void> _confirmRemove(
    BuildContext context,
    WidgetRef ref,
    AttendanceRecord record,
    Student? student,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Remove attendance?'),
        content: Text(
          'Remove ${student?.name ?? 'this student'} from this date? '
          'This cannot be undone.',
        ),
        actions: <Widget>[
          TextButton(
            key: const Key('cancel-remove'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const Key('confirm-remove'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    await ref
        .read(attendanceWorkflowServiceProvider)
        .removeAttendance(record.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed ${student?.name ?? 'student'}')),
      );
    }
  }

  DateTime? _parse() {
    try {
      return DateUtil.fromIsoDate(isoDate);
    } on FormatException {
      return null;
    }
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text('Something went wrong loading attendance:\n$message'),
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard({
    required this.record,
    required this.student,
    required this.onRemove,
    super.key,
  });

  final AttendanceRecord record;
  final Student? student;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color color = student == null
        ? scheme.surfaceContainerHighest
        : colorFromHex(student!.color);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onRemove,
        child: Row(
          children: <Widget>[
            Container(width: 8, height: 56, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    student?.name ?? 'Unknown student',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Taught · tap to remove',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.check_circle, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
