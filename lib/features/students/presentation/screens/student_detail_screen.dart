import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/student_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../domain/entities/routine_period.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/entities/teaching_period.dart';
import '../../../../domain/entities/weekday.dart';
import '../providers.dart';

/// Student details (PRD §9.7): profile, current routine, and full teaching
/// history; stop/resume teaching preserves history (PRD BR-08).
class StudentDetailScreen extends ConsumerWidget {
  const StudentDetailScreen({
    super.key,
    required this.studentId,
    this.currentLocation = AppRoutes.students,
  });

  final String studentId;
  final String currentLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Student>> studentsAsync = ref.watch(
      studentsStreamProvider,
    );
    final Student? student = studentsAsync.maybeWhen(
      data: (List<Student> students) =>
          students.where((Student s) => s.id == studentId).firstOrNull,
      orElse: () => null,
    );

    if (studentsAsync.isLoading) {
      return _scaffold(
        context,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (student == null) {
      return _scaffold(
        context,
        body: const Center(child: Text('Student not found')),
      );
    }

    return _scaffold(
      context,
      student: student,
      body: ListView(
        key: const Key('student-detail-scroll'),
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: colorFromHex(student.color),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  student.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              _StatusChip(teaching: student.currentlyTeaching),
            ],
          ),
          const SizedBox(height: 16),
          if (!student.currentlyTeaching)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Not currently teaching. All attendance and history are '
                  'preserved.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          _InfoCard(
            title: 'Routine',
            lines: <String>[
              '${student.weeklyDays} days per week',
              AppDateFormats.weekdayList(
                student.routineWeekdays.map((Weekday w) => w.fullLabel),
              ),
              'Teaching since ${AppDateFormats.shortDate(student.startDate)}',
            ],
          ),
          if (student.phone != null ||
              student.guardianName != null ||
              student.address != null)
            _InfoCard(
              title: 'Contact',
              lines: <String>[
                if (student.phone != null) 'Phone: ${student.phone}',
                if (student.guardianName != null)
                  'Guardian: ${student.guardianName}',
                if (student.address != null) 'Address: ${student.address}',
              ],
            ),
          if (student.notes != null && student.notes!.isNotEmpty)
            _InfoCard(title: 'Notes', lines: <String>[student.notes!]),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            key: const Key('student-edit-button'),
            onPressed: () async {
              await context.push(AppRoutes.studentEdit(studentId));
              ref.invalidate(teachingPeriodsForStudentProvider(studentId));
              ref.invalidate(routinePeriodsForStudentProvider(studentId));
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit student'),
          ),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            key: Key(
              student.currentlyTeaching ? 'stop-teaching' : 'resume-teaching',
            ),
            onPressed: () async {
              await ref
                  .read(studentManagementServiceProvider)
                  .setCurrentlyTeaching(
                    studentId: studentId,
                    teaching: !student.currentlyTeaching,
                  );
              ref.invalidate(teachingPeriodsForStudentProvider(studentId));
              ref.invalidate(routinePeriodsForStudentProvider(studentId));
            },
            icon: Icon(
              student.currentlyTeaching
                  ? Icons.pause_circle_outline
                  : Icons.play_circle_outline,
            ),
            label: Text(
              student.currentlyTeaching ? 'Stop teaching' : 'Resume teaching',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Teaching history',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ref
              .watch(teachingPeriodsForStudentProvider(studentId))
              .maybeWhen(
                data: (List<TeachingPeriod> periods) => Column(
                  children: <Widget>[
                    for (final TeachingPeriod period in periods)
                      ListTile(
                        dense: true,
                        leading: Icon(
                          period.isOpen ? Icons.play_arrow : Icons.check,
                        ),
                        title: Text(
                          '${AppDateFormats.shortDate(period.startDate)} – '
                          '${period.endDate == null ? 'ongoing' : AppDateFormats.shortDate(period.endDate!)}',
                        ),
                      ),
                  ],
                ),
                orElse: () => const Center(child: CircularProgressIndicator()),
              ),
          const SizedBox(height: 8),
          Text(
            'Routine history',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ref
              .watch(routinePeriodsForStudentProvider(studentId))
              .maybeWhen(
                data: (List<RoutinePeriod> routines) => Column(
                  children: <Widget>[
                    for (final RoutinePeriod routine in routines)
                      ListTile(
                        dense: true,
                        leading: Icon(
                          routine.isOpen ? Icons.play_arrow : Icons.check,
                        ),
                        title: Text(
                          '${AppDateFormats.shortDate(routine.startDate)} – '
                          '${routine.endDate == null ? 'ongoing' : AppDateFormats.shortDate(routine.endDate!)}',
                        ),
                        subtitle: Text(
                          '${routine.weeklyDays} days/week · '
                          '${AppDateFormats.weekdayList(routine.weekdays.map((Weekday w) => w.shortLabel))}',
                        ),
                      ),
                  ],
                ),
                orElse: () => const Center(child: CircularProgressIndicator()),
              ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _scaffold(
    BuildContext context, {
    required Widget body,
    Student? student,
  }) {
    return Scaffold(
      appBar: AppBar(title: Text(student?.name ?? 'Student')),
      drawer: student == null
          ? null
          : AppDrawer(currentLocation: currentLocation),
      body: body,
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.teaching});

  final bool teaching;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: teaching
            ? scheme.primaryContainer
            : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        teaching ? 'Active' : 'Inactive',
        style: TextStyle(color: scheme.onSurface),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            for (final String line in lines)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Text(line),
              ),
          ],
        ),
      ),
    );
  }
}
