import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/student_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/entities/weekday.dart';
import '../providers.dart';

/// Students List screen (PRD §9.5, §29, §30).
///
/// Active students are listed first (alphabetical), inactive students below
/// (alphabetical); search is case-insensitive and matches partial names.
class StudentsScreen extends ConsumerStatefulWidget {
  const StudentsScreen({super.key, this.currentLocation = AppRoutes.home});

  final String currentLocation;

  @override
  ConsumerState<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends ConsumerState<StudentsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Student>> studentsAsync = ref.watch(
      studentsStreamProvider,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      drawer: AppDrawer(currentLocation: widget.currentLocation),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add student',
        onPressed: () => context.push(AppRoutes.studentNew),
        child: const Icon(Icons.person_add),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              key: const Key('students-search-field'),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search students',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (String value) =>
                  setState(() => _query = value.trim().toLowerCase()),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: studentsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object error, StackTrace _) =>
                  _ErrorView(message: '$error'),
              data: (List<Student> students) =>
                  _StudentList(students: students, query: _query),
            ),
          ),
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
        child: Text('Something went wrong loading students:\n$message'),
      ),
    );
  }
}

class _StudentList extends StatelessWidget {
  const _StudentList({required this.students, required this.query});

  final List<Student> students;
  final String query;

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.people_outline, size: 48),
            SizedBox(height: 8),
            Text('No students yet'),
            Text('Tap + to add your first student'),
          ],
        ),
      );
    }

    final List<Student> visible = query.isEmpty
        ? students
        : students
              .where((Student s) => s.name.toLowerCase().contains(query))
              .toList();
    if (visible.isEmpty) {
      return const Center(child: Text('No students match your search'));
    }

    final List<Student> active =
        visible.where((Student s) => s.currentlyTeaching).toList()
          ..sort((Student a, Student b) => a.name.compareTo(b.name));
    final List<Student> inactive =
        visible.where((Student s) => !s.currentlyTeaching).toList()
          ..sort((Student a, Student b) => a.name.compareTo(b.name));

    return ListView(
      children: <Widget>[
        if (active.isNotEmpty) ...<Widget>[
          const _SectionHeader('Currently teaching'),
          for (final Student student in active) _StudentTile(student: student),
        ],
        if (inactive.isNotEmpty) ...<Widget>[
          const _SectionHeader('Inactive'),
          for (final Student student in inactive)
            _StudentTile(student: student),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _StudentTile extends StatelessWidget {
  const _StudentTile({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final String routineSummary = student.routineWeekdays.isEmpty
        ? '${student.weeklyDays} days/week'
        : '${student.weeklyDays} days/week · '
              '${AppDateFormats.weekdayList(student.routineWeekdays.map((Weekday w) => w.shortLabel))}';

    return ListTile(
      leading: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: colorFromHex(student.color),
          shape: BoxShape.circle,
        ),
      ),
      title: Text(student.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        routineSummary,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: student.currentlyTeaching ? null : const Text('Inactive'),
      onTap: () => context.push(AppRoutes.studentDetail(student.id)),
    );
  }
}
