import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/student_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/services/monthly_goal_service.dart';
import '../../../students/presentation/providers.dart';
import '../providers.dart';

/// Monthly Attendance Goal screen (PRD §9.8, §44): the last six months,
/// newest first, with per-student actual/scheduled/percentage rows and an
/// overall summary per month.
class MonthlyGoalScreen extends ConsumerWidget {
  const MonthlyGoalScreen({
    super.key,
    this.currentLocation = AppRoutes.monthlyGoal,
  });

  final String currentLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<MonthGoalSummary>> summariesAsync = ref.watch(
      monthlyGoalSummariesProvider,
    );
    final AsyncValue<List<Student>> studentsAsync = ref.watch(
      studentsStreamProvider,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Attendance Goal')),
      drawer: AppDrawer(currentLocation: currentLocation),
      body: studentsAsync.maybeWhen(
        data: (List<Student> students) {
          if (students.isEmpty) {
            return const _EmptyView();
          }
          return summariesAsync.maybeWhen(
            data: (List<MonthGoalSummary> summaries) => ListView(
              padding: const EdgeInsets.all(12),
              children: <Widget>[
                for (final MonthGoalSummary summary in summaries)
                  _MonthCard(summary: summary),
              ],
            ),
            error: (Object error, StackTrace _) =>
                _ErrorView(message: '$error'),
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
        orElse: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          Icon(Icons.insights, size: 48),
          SizedBox(height: 8),
          Text('No attendance data yet'),
          Text('Students and their monthly attendance will appear here'),
        ],
      ),
    );
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
        child: Text('Something went wrong loading summaries:\n$message'),
      ),
    );
  }
}

class _MonthCard extends StatelessWidget {
  const _MonthCard({required this.summary});

  final MonthGoalSummary summary;

  String get _monthKey =>
      '${summary.month.year}-${summary.month.month.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String overall = summary.overallPercentage == null
        ? '${summary.totalAttended} / ${summary.totalScheduled} · —'
        : '${summary.totalAttended} / ${summary.totalScheduled} · '
              '${summary.overallPercentage!.round()}%';

    return Card(
      key: Key('goal-month-$_monthKey'),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    AppDateFormats.monthYear(
                      summary.month.year,
                      summary.month.month,
                    ),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  overall,
                  key: Key('goal-overall-$_monthKey'),
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: scheme.primary),
                ),
              ],
            ),
            const Divider(height: 12),
            for (final StudentMonthGoal row in summary.students)
              _StudentRow(
                key: Key('goal-row-${row.student.id}-$_monthKey'),
                row: row,
              ),
            if (summary.students.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No students this month',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({required this.row, super.key});

  final StudentMonthGoal row;

  @override
  Widget build(BuildContext context) {
    final String trailing = row.percentage == null
        ? '${row.attendedCount} / ${row.scheduledCount} · —'
        : '${row.attendedCount} / ${row.scheduledCount} · '
              '${row.percentage!.round()}%';

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: colorFromHex(row.student.color),
          shape: BoxShape.circle,
        ),
      ),
      title: Text(
        row.student.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(trailing, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
