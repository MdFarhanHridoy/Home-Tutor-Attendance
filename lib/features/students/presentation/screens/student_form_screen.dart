import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/student_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/entities/weekday.dart';
import '../../../calendar/presentation/providers.dart';
import '../providers.dart';

/// Add/Edit student form (PRD §9.6, AC-09).
///
/// Create mode opens initial teaching/routine periods from the chosen start
/// date. Edit mode supports profile changes, routine changes (new routine
/// period effective today — history preserved), and the currently-teaching
/// toggle (closes/reopens periods via the service).
class StudentFormScreen extends ConsumerStatefulWidget {
  const StudentFormScreen.create({super.key}) : studentId = null;

  const StudentFormScreen.edit({super.key, required this.studentId});

  final String? studentId;

  @override
  ConsumerState<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends ConsumerState<StudentFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _guardianController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  int _weeklyDays = 3;
  Set<Weekday> _selectedWeekdays = <Weekday>{
    Weekday.monday,
    Weekday.wednesday,
    Weekday.friday,
  };
  String _color = studentColorPalette.first;
  late DateTime _startDate; // set in initState from the injectable "today"
  bool _currentlyTeaching = true;
  bool _initialized = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _startDate = ref.read(calendarTodayProvider);
  }

  bool get _isEdit => widget.studentId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _guardianController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _hydrate(Student student) {
    _nameController.text = student.name;
    _phoneController.text = student.phone ?? '';
    _guardianController.text = student.guardianName ?? '';
    _addressController.text = student.address ?? '';
    _notesController.text = student.notes ?? '';
    _weeklyDays = student.weeklyDays;
    _selectedWeekdays = Set<Weekday>.of(student.routineWeekdays);
    _color = student.color;
    _currentlyTeaching = student.currentlyTeaching;
  }

  bool get _routineValid => _selectedWeekdays.length == _weeklyDays;

  Future<void> _pickStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(_startDate.year + 2, 12, 31),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || !_routineValid) {
      return;
    }
    setState(() => _saving = true);
    final service = ref.read(studentManagementServiceProvider);
    try {
      if (!_isEdit) {
        await service.createStudent(
          name: _nameController.text,
          weeklyDays: _weeklyDays,
          routineWeekdays: _selectedWeekdays.toList(),
          color: _color,
          startDate: _startDate,
          phone: _phoneController.text,
          guardianName: _guardianController.text,
          address: _addressController.text,
          notes: _notesController.text,
        );
      } else {
        final String id = widget.studentId!;
        await service.updateProfile(
          studentId: id,
          name: _nameController.text,
          color: _color,
          phone: _phoneController.text,
          guardianName: _guardianController.text,
          address: _addressController.text,
          notes: _notesController.text,
        );
        if (_routineChanged) {
          await service.changeRoutine(
            studentId: id,
            weeklyDays: _weeklyDays,
            weekdays: _selectedWeekdays.toList(),
          );
        }
        if (_teachingChanged) {
          await service.setCurrentlyTeaching(
            studentId: id,
            teaching: _currentlyTeaching,
          );
        }
      }
      if (mounted) {
        context.pop();
      }
    } catch (error) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save student: $error')),
        );
      }
    }
  }

  bool get _routineChanged {
    final Student? student = _loadedStudent;
    return student != null &&
        (student.weeklyDays != _weeklyDays ||
            !_sameSet(student.routineWeekdays, _selectedWeekdays));
  }

  bool get _teachingChanged =>
      _loadedStudent != null &&
      _loadedStudent!.currentlyTeaching != _currentlyTeaching;

  Student? _loadedStudent;

  bool _sameSet(List<Weekday> a, Set<Weekday> b) {
    return a.length == b.length && a.toSet().containsAll(b);
  }

  @override
  Widget build(BuildContext context) {
    if (_isEdit && !_initialized) {
      // Hydrate once from the live student list (the stream is already
      // maintained by the students feature providers).
      final AsyncValue<List<Student>> studentsAsync = ref.watch(
        studentsStreamProvider,
      );
      studentsAsync.whenData((List<Student> students) {
        for (final Student student in students) {
          if (student.id == widget.studentId) {
            _loadedStudent = student;
            _hydrate(student);
            _initialized = true;
            break;
          }
        }
      });
      if (!_initialized) {
        if (studentsAsync.hasError) {
          return _scaffold(
            body: Center(child: Text('Error: ${studentsAsync.error}')),
          );
        }
        return _scaffold(
          body: const Center(child: CircularProgressIndicator()),
        );
      }
    }

    return _scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          key: const Key('student-form-scroll'),
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              key: const Key('student-name-field'),
              controller: _nameController,
              maxLength: 100, // matches the database column constraint
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Student name',
                border: OutlineInputBorder(),
                counterText: '',
              ),
              textCapitalization: TextCapitalization.words,
              validator: (String? value) =>
                  (value ?? '').trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            if (!_isEdit) ...<Widget>[
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Teaching start date',
                  border: OutlineInputBorder(),
                ),
                child: InkWell(
                  key: const Key('student-start-date'),
                  onTap: _pickStartDate,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.event),
                        const SizedBox(width: 8),
                        Text(AppDateFormats.shortDate(_startDate)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            DropdownButtonFormField<int>(
              key: const Key('student-weekly-days'),
              initialValue: _weeklyDays,
              decoration: const InputDecoration(
                labelText: 'Days per week',
                border: OutlineInputBorder(),
              ),
              items: <DropdownMenuItem<int>>[
                for (int days = 1; days <= 7; days++)
                  DropdownMenuItem<int>(value: days, child: Text('$days')),
              ],
              onChanged: (int? value) {
                if (value != null) {
                  setState(() => _weeklyDays = value);
                }
              },
            ),
            const SizedBox(height: 8),
            Text(
              _routineValid
                  ? 'Routine weekdays'
                  : 'Routine weekdays — select $_weeklyDays '
                        '(${_selectedWeekdays.length} selected)',
              key: const Key('weekday-hint'),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: <Widget>[
                for (final Weekday weekday in Weekday.values)
                  FilterChip(
                    label: Text(weekday.shortLabel),
                    selected: _selectedWeekdays.contains(weekday),
                    onSelected: (bool selected) {
                      setState(() {
                        final Set<Weekday> updated = Set<Weekday>.of(
                          _selectedWeekdays,
                        );
                        if (selected) {
                          updated.add(weekday);
                        } else {
                          updated.remove(weekday);
                        }
                        _selectedWeekdays = updated;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Color', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                for (final String hex in studentColorPalette)
                  _ColorOption(
                    hex: hex,
                    selected: _color == hex,
                    onTap: () => setState(() => _color = hex),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isEdit) ...<Widget>[
              SwitchListTile(
                key: const Key('student-active-switch'),
                title: const Text('Currently teaching'),
                subtitle: const Text(
                  'Stopping keeps all attendance and history intact',
                ),
                value: _currentlyTeaching,
                onChanged: (bool value) =>
                    setState(() => _currentlyTeaching = value),
              ),
              const SizedBox(height: 8),
            ],
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _guardianController,
              decoration: const InputDecoration(
                labelText: 'Guardian name (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('student-save-button'),
              onPressed: _saving || !_routineValid ? null : _save,
              child: Text(_saving ? 'Saving…' : 'Save student'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _scaffold({required Widget body}) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit student' : 'Add student')),
      body: body,
    );
  }
}

class _ColorOption extends StatelessWidget {
  const _ColorOption({
    required this.hex,
    required this.selected,
    required this.onTap,
  });

  final String hex;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colorFromHex(hex),
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.onSurface
                : Colors.transparent,
            width: 3,
          ),
        ),
      ),
    );
  }
}
