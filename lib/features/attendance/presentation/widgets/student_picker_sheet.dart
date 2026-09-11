import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/student_colors.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../domain/repositories/attendance_repository.dart';
import '../../../../domain/services/attendance_workflow_service.dart';
import '../providers.dart';

/// Bottom sheet listing currently-teaching students with their weekly
/// allowance for the picked date (PRD §9.3).
///
/// - tapping an unrecorded student adds attendance (a confirmation dialog
///   appears first when the weekly routine is already fulfilled);
/// - tapping a recorded student surfaces duplicate protection
///   (PRD §11.5 UI level);
/// - the sheet stays open so several students can be recorded in a row.
class StudentPickerSheet extends ConsumerStatefulWidget {
  const StudentPickerSheet({required this.isoDate, super.key});

  final String isoDate;

  @override
  ConsumerState<StudentPickerSheet> createState() => _StudentPickerSheetState();
}

class _StudentPickerSheetState extends ConsumerState<StudentPickerSheet> {
  late final Future<List<AttendanceCandidate>> _candidates;

  @override
  void initState() {
    super.initState();
    _candidates = _load();
  }

  Future<List<AttendanceCandidate>> _load() {
    return ref
        .read(attendanceWorkflowServiceProvider)
        .pickerCandidatesForDate(DateUtil.fromIsoDate(widget.isoDate));
  }

  Future<void> _reload() async {
    final List<AttendanceCandidate> fresh = await _load();
    if (mounted) {
      setState(() => _savedCandidates = fresh);
    }
  }

  List<AttendanceCandidate>? _savedCandidates;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AttendanceCandidate>>(
      future: _candidates,
      builder:
          (
            BuildContext context,
            AsyncSnapshot<List<AttendanceCandidate>> snapshot,
          ) {
            final List<AttendanceCandidate>? candidates =
                _savedCandidates ?? snapshot.data;
            return SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 12),
                    Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Record attendance',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Expanded(
                      child: _content(
                        context,
                        snapshot.connectionState,
                        candidates,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
    );
  }

  Widget _content(
    BuildContext context,
    ConnectionState connectionState,
    List<AttendanceCandidate>? candidates,
  ) {
    if (candidates == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (candidates.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('No currently teaching students. Add students first.'),
        ),
      );
    }
    return ListView(
      key: const Key('student-picker'),
      children: <Widget>[
        for (final AttendanceCandidate candidate in candidates)
          _PickerRow(candidate: candidate, onTap: () => _handleTap(candidate)),
      ],
    );
  }

  Future<void> _handleTap(AttendanceCandidate candidate) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    if (candidate.recorded) {
      // UI-level duplicate protection (PRD §11.5).
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            '${candidate.student.name} is already recorded on this date',
          ),
        ),
      );
      return;
    }

    if (candidate.allowance.metRoutine) {
      final bool? proceed = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          title: const Text('Extra attendance?'),
          content: Text(
            '${candidate.student.name} has already met the weekly routine '
            '(${candidate.allowance.weeklyDays} day'
            '${candidate.allowance.weeklyDays == 1 ? '' : 's'}'
            '${candidate.allowance.carriedOver > 0 ? ' + ${candidate.allowance.carriedOver} carried' : ''}). '
            'Record extra attendance anyway?',
          ),
          actions: <Widget>[
            TextButton(
              key: const Key('cancel-extra'),
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: const Key('confirm-extra'),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Record extra'),
            ),
          ],
        ),
      );
      if (proceed != true) {
        return;
      }
    }

    try {
      await ref
          .read(attendanceWorkflowServiceProvider)
          .addAttendance(
            studentId: candidate.student.id,
            date: DateUtil.fromIsoDate(widget.isoDate),
          );
      await _reload();
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Recorded ${candidate.student.name}')),
        );
      }
    } on DuplicateAttendanceException {
      // Lost a race or state was stale — surface the domain guard.
      await _reload();
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              '${candidate.student.name} is already recorded on this date',
            ),
          ),
        );
      }
    }
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({required this.candidate, required this.onTap});

  final AttendanceCandidate candidate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String carried = candidate.allowance.carriedOver > 0
        ? ' · +${candidate.allowance.carriedOver} carried'
        : '';
    final String subtitle = candidate.allowance.weeklyDays == 0
        ? 'No routine this week'
        : '${candidate.allowance.usedThisWeek} of '
              '${candidate.allowance.weeklyDays} used this week$carried';

    return ListTile(
      key: Key('picker-row-${candidate.student.id}'),
      leading: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: colorFromHex(candidate.student.color),
          shape: BoxShape.circle,
        ),
      ),
      title: Text(candidate.student.name),
      subtitle: Text(subtitle),
      trailing: candidate.recorded
          ? Icon(Icons.check_circle, color: scheme.primary)
          : const Icon(Icons.add),
      onTap: onTap,
    );
  }
}
