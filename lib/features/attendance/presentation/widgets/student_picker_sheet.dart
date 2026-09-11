import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/student_colors.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../domain/repositories/attendance_repository.dart';
import '../../../../domain/services/attendance_workflow_service.dart';
import '../providers.dart';

/// Bottom sheet listing currently-teaching students (PRD §9.3).
///
/// v1.2: attendance may be recorded for any student on any date — the
/// weekly cap was removed. Tapping a recorded student surfaces duplicate
/// protection (PRD §11.5 UI level); the sheet stays open so several
/// students can be recorded in a row.
class StudentPickerSheet extends ConsumerStatefulWidget {
  const StudentPickerSheet({required this.isoDate, super.key});

  final String isoDate;

  @override
  ConsumerState<StudentPickerSheet> createState() => _StudentPickerSheetState();
}

class _StudentPickerSheetState extends ConsumerState<StudentPickerSheet> {
  late final Future<List<AttendanceCandidate>> _candidates;
  List<AttendanceCandidate>? _savedCandidates;

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
                    Expanded(child: _content(context, candidates)),
                  ],
                ),
              ),
            );
          },
    );
  }

  Widget _content(BuildContext context, List<AttendanceCandidate>? candidates) {
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
    final int days = candidate.student.weeklyDays;
    final String subtitle = '$days day${days == 1 ? '' : 's'} per week';

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
