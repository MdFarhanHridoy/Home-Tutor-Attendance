// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $StudentsTable extends Students
    with TableInfo<$StudentsTable, StudentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weeklyDaysMeta = const VerificationMeta(
    'weeklyDays',
  );
  @override
  late final GeneratedColumn<int> weeklyDays = GeneratedColumn<int>(
    'weekly_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<Weekday>, String>
  routineWeekdays = GeneratedColumn<String>(
    'routine_weekdays',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<Weekday>>($StudentsTable.$converterroutineWeekdays);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentlyTeachingMeta = const VerificationMeta(
    'currentlyTeaching',
  );
  @override
  late final GeneratedColumn<bool> currentlyTeaching = GeneratedColumn<bool>(
    'currently_teaching',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("currently_teaching" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> startDate =
      GeneratedColumn<String>(
        'start_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($StudentsTable.$converterstartDate);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _guardianNameMeta = const VerificationMeta(
    'guardianName',
  );
  @override
  late final GeneratedColumn<String> guardianName = GeneratedColumn<String>(
    'guardian_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    weeklyDays,
    routineWeekdays,
    color,
    currentlyTeaching,
    startDate,
    phone,
    guardianName,
    address,
    notes,
    createdAt,
    updatedAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('weekly_days')) {
      context.handle(
        _weeklyDaysMeta,
        weeklyDays.isAcceptableOrUnknown(data['weekly_days']!, _weeklyDaysMeta),
      );
    } else if (isInserting) {
      context.missing(_weeklyDaysMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('currently_teaching')) {
      context.handle(
        _currentlyTeachingMeta,
        currentlyTeaching.isAcceptableOrUnknown(
          data['currently_teaching']!,
          _currentlyTeachingMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('guardian_name')) {
      context.handle(
        _guardianNameMeta,
        guardianName.isAcceptableOrUnknown(
          data['guardian_name']!,
          _guardianNameMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      weeklyDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_days'],
      )!,
      routineWeekdays: $StudentsTable.$converterroutineWeekdays.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}routine_weekdays'],
        )!,
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      currentlyTeaching: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}currently_teaching'],
      )!,
      startDate: $StudentsTable.$converterstartDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}start_date'],
        )!,
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      guardianName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guardian_name'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<Weekday>, String> $converterroutineWeekdays =
      const WeekdayListConverter();
  static TypeConverter<DateTime, String> $converterstartDate =
      const DateOnlyConverter();
}

class StudentRow extends DataClass implements Insertable<StudentRow> {
  final String id;
  final String name;
  final int weeklyDays;
  final List<Weekday> routineWeekdays;
  final String color;
  final bool currentlyTeaching;
  final DateTime startDate;
  final String? phone;
  final String? guardianName;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  const StudentRow({
    required this.id,
    required this.name,
    required this.weeklyDays,
    required this.routineWeekdays,
    required this.color,
    required this.currentlyTeaching,
    required this.startDate,
    this.phone,
    this.guardianName,
    this.address,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['weekly_days'] = Variable<int>(weeklyDays);
    {
      map['routine_weekdays'] = Variable<String>(
        $StudentsTable.$converterroutineWeekdays.toSql(routineWeekdays),
      );
    }
    map['color'] = Variable<String>(color);
    map['currently_teaching'] = Variable<bool>(currentlyTeaching);
    {
      map['start_date'] = Variable<String>(
        $StudentsTable.$converterstartDate.toSql(startDate),
      );
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || guardianName != null) {
      map['guardian_name'] = Variable<String>(guardianName);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: Value(id),
      name: Value(name),
      weeklyDays: Value(weeklyDays),
      routineWeekdays: Value(routineWeekdays),
      color: Value(color),
      currentlyTeaching: Value(currentlyTeaching),
      startDate: Value(startDate),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      guardianName: guardianName == null && nullToAbsent
          ? const Value.absent()
          : Value(guardianName),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory StudentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      weeklyDays: serializer.fromJson<int>(json['weeklyDays']),
      routineWeekdays: serializer.fromJson<List<Weekday>>(
        json['routineWeekdays'],
      ),
      color: serializer.fromJson<String>(json['color']),
      currentlyTeaching: serializer.fromJson<bool>(json['currentlyTeaching']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      phone: serializer.fromJson<String?>(json['phone']),
      guardianName: serializer.fromJson<String?>(json['guardianName']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'weeklyDays': serializer.toJson<int>(weeklyDays),
      'routineWeekdays': serializer.toJson<List<Weekday>>(routineWeekdays),
      'color': serializer.toJson<String>(color),
      'currentlyTeaching': serializer.toJson<bool>(currentlyTeaching),
      'startDate': serializer.toJson<DateTime>(startDate),
      'phone': serializer.toJson<String?>(phone),
      'guardianName': serializer.toJson<String?>(guardianName),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  StudentRow copyWith({
    String? id,
    String? name,
    int? weeklyDays,
    List<Weekday>? routineWeekdays,
    String? color,
    bool? currentlyTeaching,
    DateTime? startDate,
    Value<String?> phone = const Value.absent(),
    Value<String?> guardianName = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => StudentRow(
    id: id ?? this.id,
    name: name ?? this.name,
    weeklyDays: weeklyDays ?? this.weeklyDays,
    routineWeekdays: routineWeekdays ?? this.routineWeekdays,
    color: color ?? this.color,
    currentlyTeaching: currentlyTeaching ?? this.currentlyTeaching,
    startDate: startDate ?? this.startDate,
    phone: phone.present ? phone.value : this.phone,
    guardianName: guardianName.present ? guardianName.value : this.guardianName,
    address: address.present ? address.value : this.address,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  StudentRow copyWithCompanion(StudentsCompanion data) {
    return StudentRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      weeklyDays: data.weeklyDays.present
          ? data.weeklyDays.value
          : this.weeklyDays,
      routineWeekdays: data.routineWeekdays.present
          ? data.routineWeekdays.value
          : this.routineWeekdays,
      color: data.color.present ? data.color.value : this.color,
      currentlyTeaching: data.currentlyTeaching.present
          ? data.currentlyTeaching.value
          : this.currentlyTeaching,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      phone: data.phone.present ? data.phone.value : this.phone,
      guardianName: data.guardianName.present
          ? data.guardianName.value
          : this.guardianName,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('weeklyDays: $weeklyDays, ')
          ..write('routineWeekdays: $routineWeekdays, ')
          ..write('color: $color, ')
          ..write('currentlyTeaching: $currentlyTeaching, ')
          ..write('startDate: $startDate, ')
          ..write('phone: $phone, ')
          ..write('guardianName: $guardianName, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    weeklyDays,
    routineWeekdays,
    color,
    currentlyTeaching,
    startDate,
    phone,
    guardianName,
    address,
    notes,
    createdAt,
    updatedAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.weeklyDays == this.weeklyDays &&
          other.routineWeekdays == this.routineWeekdays &&
          other.color == this.color &&
          other.currentlyTeaching == this.currentlyTeaching &&
          other.startDate == this.startDate &&
          other.phone == this.phone &&
          other.guardianName == this.guardianName &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt);
}

class StudentsCompanion extends UpdateCompanion<StudentRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> weeklyDays;
  final Value<List<Weekday>> routineWeekdays;
  final Value<String> color;
  final Value<bool> currentlyTeaching;
  final Value<DateTime> startDate;
  final Value<String?> phone;
  final Value<String?> guardianName;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.weeklyDays = const Value.absent(),
    this.routineWeekdays = const Value.absent(),
    this.color = const Value.absent(),
    this.currentlyTeaching = const Value.absent(),
    this.startDate = const Value.absent(),
    this.phone = const Value.absent(),
    this.guardianName = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentsCompanion.insert({
    required String id,
    required String name,
    required int weeklyDays,
    required List<Weekday> routineWeekdays,
    required String color,
    this.currentlyTeaching = const Value.absent(),
    required DateTime startDate,
    this.phone = const Value.absent(),
    this.guardianName = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       weeklyDays = Value(weeklyDays),
       routineWeekdays = Value(routineWeekdays),
       color = Value(color),
       startDate = Value(startDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<StudentRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? weeklyDays,
    Expression<String>? routineWeekdays,
    Expression<String>? color,
    Expression<bool>? currentlyTeaching,
    Expression<String>? startDate,
    Expression<String>? phone,
    Expression<String>? guardianName,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (weeklyDays != null) 'weekly_days': weeklyDays,
      if (routineWeekdays != null) 'routine_weekdays': routineWeekdays,
      if (color != null) 'color': color,
      if (currentlyTeaching != null) 'currently_teaching': currentlyTeaching,
      if (startDate != null) 'start_date': startDate,
      if (phone != null) 'phone': phone,
      if (guardianName != null) 'guardian_name': guardianName,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? weeklyDays,
    Value<List<Weekday>>? routineWeekdays,
    Value<String>? color,
    Value<bool>? currentlyTeaching,
    Value<DateTime>? startDate,
    Value<String?>? phone,
    Value<String?>? guardianName,
    Value<String?>? address,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return StudentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      routineWeekdays: routineWeekdays ?? this.routineWeekdays,
      color: color ?? this.color,
      currentlyTeaching: currentlyTeaching ?? this.currentlyTeaching,
      startDate: startDate ?? this.startDate,
      phone: phone ?? this.phone,
      guardianName: guardianName ?? this.guardianName,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (weeklyDays.present) {
      map['weekly_days'] = Variable<int>(weeklyDays.value);
    }
    if (routineWeekdays.present) {
      map['routine_weekdays'] = Variable<String>(
        $StudentsTable.$converterroutineWeekdays.toSql(routineWeekdays.value),
      );
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (currentlyTeaching.present) {
      map['currently_teaching'] = Variable<bool>(currentlyTeaching.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(
        $StudentsTable.$converterstartDate.toSql(startDate.value),
      );
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (guardianName.present) {
      map['guardian_name'] = Variable<String>(guardianName.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('weeklyDays: $weeklyDays, ')
          ..write('routineWeekdays: $routineWeekdays, ')
          ..write('color: $color, ')
          ..write('currentlyTeaching: $currentlyTeaching, ')
          ..write('startDate: $startDate, ')
          ..write('phone: $phone, ')
          ..write('guardianName: $guardianName, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TeachingPeriodsTable extends TeachingPeriods
    with TableInfo<$TeachingPeriodsTable, TeachingPeriodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeachingPeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> startDate =
      GeneratedColumn<String>(
        'start_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($TeachingPeriodsTable.$converterstartDate);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, String> endDate =
      GeneratedColumn<String>(
        'end_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($TeachingPeriodsTable.$converterendDaten);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    startDate,
    endDate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teaching_periods';
  @override
  VerificationContext validateIntegrity(
    Insertable<TeachingPeriodRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TeachingPeriodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeachingPeriodRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      startDate: $TeachingPeriodsTable.$converterstartDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}start_date'],
        )!,
      ),
      endDate: $TeachingPeriodsTable.$converterendDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}end_date'],
        ),
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TeachingPeriodsTable createAlias(String alias) {
    return $TeachingPeriodsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterstartDate =
      const DateOnlyConverter();
  static TypeConverter<DateTime, String> $converterendDate =
      const DateOnlyConverter();
  static TypeConverter<DateTime?, String?> $converterendDaten =
      NullAwareTypeConverter.wrap($converterendDate);
}

class TeachingPeriodRow extends DataClass
    implements Insertable<TeachingPeriodRow> {
  final String id;
  final String studentId;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TeachingPeriodRow({
    required this.id,
    required this.studentId,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    {
      map['start_date'] = Variable<String>(
        $TeachingPeriodsTable.$converterstartDate.toSql(startDate),
      );
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(
        $TeachingPeriodsTable.$converterendDaten.toSql(endDate),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TeachingPeriodsCompanion toCompanion(bool nullToAbsent) {
    return TeachingPeriodsCompanion(
      id: Value(id),
      studentId: Value(studentId),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TeachingPeriodRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeachingPeriodRow(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TeachingPeriodRow copyWith({
    String? id,
    String? studentId,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TeachingPeriodRow(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TeachingPeriodRow copyWithCompanion(TeachingPeriodsCompanion data) {
    return TeachingPeriodRow(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeachingPeriodRow(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, studentId, startDate, endDate, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeachingPeriodRow &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TeachingPeriodsCompanion extends UpdateCompanion<TeachingPeriodRow> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TeachingPeriodsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TeachingPeriodsCompanion.insert({
    required String id,
    required String studentId,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       startDate = Value(startDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TeachingPeriodRow> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TeachingPeriodsCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TeachingPeriodsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(
        $TeachingPeriodsTable.$converterstartDate.toSql(startDate.value),
      );
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(
        $TeachingPeriodsTable.$converterendDaten.toSql(endDate.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeachingPeriodsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutinePeriodsTable extends RoutinePeriods
    with TableInfo<$RoutinePeriodsTable, RoutinePeriodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinePeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> startDate =
      GeneratedColumn<String>(
        'start_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($RoutinePeriodsTable.$converterstartDate);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, String> endDate =
      GeneratedColumn<String>(
        'end_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($RoutinePeriodsTable.$converterendDaten);
  static const VerificationMeta _weeklyDaysMeta = const VerificationMeta(
    'weeklyDays',
  );
  @override
  late final GeneratedColumn<int> weeklyDays = GeneratedColumn<int>(
    'weekly_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<Weekday>, String> weekdays =
      GeneratedColumn<String>(
        'weekdays',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<Weekday>>($RoutinePeriodsTable.$converterweekdays);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    startDate,
    endDate,
    weeklyDays,
    weekdays,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_periods';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutinePeriodRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('weekly_days')) {
      context.handle(
        _weeklyDaysMeta,
        weeklyDays.isAcceptableOrUnknown(data['weekly_days']!, _weeklyDaysMeta),
      );
    } else if (isInserting) {
      context.missing(_weeklyDaysMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutinePeriodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutinePeriodRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      startDate: $RoutinePeriodsTable.$converterstartDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}start_date'],
        )!,
      ),
      endDate: $RoutinePeriodsTable.$converterendDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}end_date'],
        ),
      ),
      weeklyDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_days'],
      )!,
      weekdays: $RoutinePeriodsTable.$converterweekdays.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}weekdays'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RoutinePeriodsTable createAlias(String alias) {
    return $RoutinePeriodsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterstartDate =
      const DateOnlyConverter();
  static TypeConverter<DateTime, String> $converterendDate =
      const DateOnlyConverter();
  static TypeConverter<DateTime?, String?> $converterendDaten =
      NullAwareTypeConverter.wrap($converterendDate);
  static TypeConverter<List<Weekday>, String> $converterweekdays =
      const WeekdayListConverter();
}

class RoutinePeriodRow extends DataClass
    implements Insertable<RoutinePeriodRow> {
  final String id;
  final String studentId;
  final DateTime startDate;
  final DateTime? endDate;
  final int weeklyDays;
  final List<Weekday> weekdays;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RoutinePeriodRow({
    required this.id,
    required this.studentId,
    required this.startDate,
    this.endDate,
    required this.weeklyDays,
    required this.weekdays,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    {
      map['start_date'] = Variable<String>(
        $RoutinePeriodsTable.$converterstartDate.toSql(startDate),
      );
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(
        $RoutinePeriodsTable.$converterendDaten.toSql(endDate),
      );
    }
    map['weekly_days'] = Variable<int>(weeklyDays);
    {
      map['weekdays'] = Variable<String>(
        $RoutinePeriodsTable.$converterweekdays.toSql(weekdays),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RoutinePeriodsCompanion toCompanion(bool nullToAbsent) {
    return RoutinePeriodsCompanion(
      id: Value(id),
      studentId: Value(studentId),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      weeklyDays: Value(weeklyDays),
      weekdays: Value(weekdays),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RoutinePeriodRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutinePeriodRow(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      weeklyDays: serializer.fromJson<int>(json['weeklyDays']),
      weekdays: serializer.fromJson<List<Weekday>>(json['weekdays']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'weeklyDays': serializer.toJson<int>(weeklyDays),
      'weekdays': serializer.toJson<List<Weekday>>(weekdays),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RoutinePeriodRow copyWith({
    String? id,
    String? studentId,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    int? weeklyDays,
    List<Weekday>? weekdays,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RoutinePeriodRow(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    weeklyDays: weeklyDays ?? this.weeklyDays,
    weekdays: weekdays ?? this.weekdays,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RoutinePeriodRow copyWithCompanion(RoutinePeriodsCompanion data) {
    return RoutinePeriodRow(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      weeklyDays: data.weeklyDays.present
          ? data.weeklyDays.value
          : this.weeklyDays,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutinePeriodRow(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('weeklyDays: $weeklyDays, ')
          ..write('weekdays: $weekdays, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    studentId,
    startDate,
    endDate,
    weeklyDays,
    weekdays,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutinePeriodRow &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.weeklyDays == this.weeklyDays &&
          other.weekdays == this.weekdays &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutinePeriodsCompanion extends UpdateCompanion<RoutinePeriodRow> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<int> weeklyDays;
  final Value<List<Weekday>> weekdays;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RoutinePeriodsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.weeklyDays = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutinePeriodsCompanion.insert({
    required String id,
    required String studentId,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    required int weeklyDays,
    required List<Weekday> weekdays,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       startDate = Value(startDate),
       weeklyDays = Value(weeklyDays),
       weekdays = Value(weekdays),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RoutinePeriodRow> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<int>? weeklyDays,
    Expression<String>? weekdays,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (weeklyDays != null) 'weekly_days': weeklyDays,
      if (weekdays != null) 'weekdays': weekdays,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutinePeriodsCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<int>? weeklyDays,
    Value<List<Weekday>>? weekdays,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RoutinePeriodsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      weekdays: weekdays ?? this.weekdays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(
        $RoutinePeriodsTable.$converterstartDate.toSql(startDate.value),
      );
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(
        $RoutinePeriodsTable.$converterendDaten.toSql(endDate.value),
      );
    }
    if (weeklyDays.present) {
      map['weekly_days'] = Variable<int>(weeklyDays.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<String>(
        $RoutinePeriodsTable.$converterweekdays.toSql(weekdays.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinePeriodsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('weeklyDays: $weeklyDays, ')
          ..write('weekdays: $weekdays, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttendanceRecordsTable extends AttendanceRecords
    with TableInfo<$AttendanceRecordsTable, AttendanceRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> attendanceDate =
      GeneratedColumn<String>(
        'attendance_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>(
        $AttendanceRecordsTable.$converterattendanceDate,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    attendanceDate,
    createdAt,
    updatedAt,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttendanceRecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {studentId, attendanceDate},
  ];
  @override
  AttendanceRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceRecordRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      attendanceDate: $AttendanceRecordsTable.$converterattendanceDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}attendance_date'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $AttendanceRecordsTable createAlias(String alias) {
    return $AttendanceRecordsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterattendanceDate =
      const DateOnlyConverter();
}

class AttendanceRecordRow extends DataClass
    implements Insertable<AttendanceRecordRow> {
  final String id;
  final String studentId;
  final DateTime attendanceDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? note;
  const AttendanceRecordRow({
    required this.id,
    required this.studentId,
    required this.attendanceDate,
    required this.createdAt,
    required this.updatedAt,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    {
      map['attendance_date'] = Variable<String>(
        $AttendanceRecordsTable.$converterattendanceDate.toSql(attendanceDate),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  AttendanceRecordsCompanion toCompanion(bool nullToAbsent) {
    return AttendanceRecordsCompanion(
      id: Value(id),
      studentId: Value(studentId),
      attendanceDate: Value(attendanceDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory AttendanceRecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceRecordRow(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      attendanceDate: serializer.fromJson<DateTime>(json['attendanceDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'attendanceDate': serializer.toJson<DateTime>(attendanceDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  AttendanceRecordRow copyWith({
    String? id,
    String? studentId,
    DateTime? attendanceDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> note = const Value.absent(),
  }) => AttendanceRecordRow(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    attendanceDate: attendanceDate ?? this.attendanceDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    note: note.present ? note.value : this.note,
  );
  AttendanceRecordRow copyWithCompanion(AttendanceRecordsCompanion data) {
    return AttendanceRecordRow(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      attendanceDate: data.attendanceDate.present
          ? data.attendanceDate.value
          : this.attendanceDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceRecordRow(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('attendanceDate: $attendanceDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, studentId, attendanceDate, createdAt, updatedAt, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceRecordRow &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.attendanceDate == this.attendanceDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.note == this.note);
}

class AttendanceRecordsCompanion extends UpdateCompanion<AttendanceRecordRow> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<DateTime> attendanceDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> note;
  final Value<int> rowid;
  const AttendanceRecordsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.attendanceDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttendanceRecordsCompanion.insert({
    required String id,
    required String studentId,
    required DateTime attendanceDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       attendanceDate = Value(attendanceDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AttendanceRecordRow> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? attendanceDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (attendanceDate != null) 'attendance_date': attendanceDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttendanceRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<DateTime>? attendanceDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return AttendanceRecordsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      attendanceDate: attendanceDate ?? this.attendanceDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (attendanceDate.present) {
      map['attendance_date'] = Variable<String>(
        $AttendanceRecordsTable.$converterattendanceDate.toSql(
          attendanceDate.value,
        ),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('attendanceDate: $attendanceDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('dark'),
  );
  static const VerificationMeta _firstDayOfWeekMeta = const VerificationMeta(
    'firstDayOfWeek',
  );
  @override
  late final GeneratedColumn<String> firstDayOfWeek = GeneratedColumn<String>(
    'first_day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('friday'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    firstDayOfWeek,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('first_day_of_week')) {
      context.handle(
        _firstDayOfWeekMeta,
        firstDayOfWeek.isAcceptableOrUnknown(
          data['first_day_of_week']!,
          _firstDayOfWeekMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      firstDayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_day_of_week'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsRow extends DataClass implements Insertable<AppSettingsRow> {
  final int id;
  final String themeMode;
  final String firstDayOfWeek;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AppSettingsRow({
    required this.id,
    required this.themeMode,
    required this.firstDayOfWeek,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['first_day_of_week'] = Variable<String>(firstDayOfWeek);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      firstDayOfWeek: Value(firstDayOfWeek),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsRow(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      firstDayOfWeek: serializer.fromJson<String>(json['firstDayOfWeek']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<String>(themeMode),
      'firstDayOfWeek': serializer.toJson<String>(firstDayOfWeek),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSettingsRow copyWith({
    int? id,
    String? themeMode,
    String? firstDayOfWeek,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AppSettingsRow(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppSettingsRow copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      firstDayOfWeek: data.firstDayOfWeek.present
          ? data.firstDayOfWeek.value
          : this.firstDayOfWeek,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsRow(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('firstDayOfWeek: $firstDayOfWeek, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, themeMode, firstDayOfWeek, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsRow &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.firstDayOfWeek == this.firstDayOfWeek &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsRow> {
  final Value<int> id;
  final Value<String> themeMode;
  final Value<String> firstDayOfWeek;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AppSettingsTableCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.firstDayOfWeek = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.firstDayOfWeek = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AppSettingsRow> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
    Expression<String>? firstDayOfWeek,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (firstDayOfWeek != null) 'first_day_of_week': firstDayOfWeek,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? themeMode,
    Value<String>? firstDayOfWeek,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return AppSettingsTableCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (firstDayOfWeek.present) {
      map['first_day_of_week'] = Variable<String>(firstDayOfWeek.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('firstDayOfWeek: $firstDayOfWeek, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $TeachingPeriodsTable teachingPeriods = $TeachingPeriodsTable(
    this,
  );
  late final $RoutinePeriodsTable routinePeriods = $RoutinePeriodsTable(this);
  late final $AttendanceRecordsTable attendanceRecords =
      $AttendanceRecordsTable(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  late final Index idxTeachingPeriodsStudentDates = Index(
    'idx_teaching_periods_student_dates',
    'CREATE INDEX idx_teaching_periods_student_dates ON teaching_periods (student_id, start_date, end_date)',
  );
  late final Index idxRoutinePeriodsStudentDates = Index(
    'idx_routine_periods_student_dates',
    'CREATE INDEX idx_routine_periods_student_dates ON routine_periods (student_id, start_date, end_date)',
  );
  late final Index idxAttendanceDate = Index(
    'idx_attendance_date',
    'CREATE INDEX idx_attendance_date ON attendance_records (attendance_date)',
  );
  late final Index idxAttendanceStudentDate = Index(
    'idx_attendance_student_date',
    'CREATE INDEX idx_attendance_student_date ON attendance_records (student_id, attendance_date)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    students,
    teachingPeriods,
    routinePeriods,
    attendanceRecords,
    appSettingsTable,
    idxTeachingPeriodsStudentDates,
    idxRoutinePeriodsStudentDates,
    idxAttendanceDate,
    idxAttendanceStudentDate,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$StudentsTableCreateCompanionBuilder =
    StudentsCompanion Function({
      required String id,
      required String name,
      required int weeklyDays,
      required List<Weekday> routineWeekdays,
      required String color,
      Value<bool> currentlyTeaching,
      required DateTime startDate,
      Value<String?> phone,
      Value<String?> guardianName,
      Value<String?> address,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$StudentsTableUpdateCompanionBuilder =
    StudentsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> weeklyDays,
      Value<List<Weekday>> routineWeekdays,
      Value<String> color,
      Value<bool> currentlyTeaching,
      Value<DateTime> startDate,
      Value<String?> phone,
      Value<String?> guardianName,
      Value<String?> address,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

final class $$StudentsTableReferences
    extends BaseReferences<_$AppDatabase, $StudentsTable, StudentRow> {
  $$StudentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TeachingPeriodsTable, List<TeachingPeriodRow>>
  _teachingPeriodsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.teachingPeriods,
    aliasName: 'students__id__teaching_periods__student_id',
  );

  $$TeachingPeriodsTableProcessedTableManager get teachingPeriodsRefs {
    final manager = $$TeachingPeriodsTableTableManager(
      $_db,
      $_db.teachingPeriods,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _teachingPeriodsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoutinePeriodsTable, List<RoutinePeriodRow>>
  _routinePeriodsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routinePeriods,
    aliasName: 'students__id__routine_periods__student_id',
  );

  $$RoutinePeriodsTableProcessedTableManager get routinePeriodsRefs {
    final manager = $$RoutinePeriodsTableTableManager(
      $_db,
      $_db.routinePeriods,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_routinePeriodsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AttendanceRecordsTable, List<AttendanceRecordRow>>
  _attendanceRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.attendanceRecords,
        aliasName: 'students__id__attendance_records__student_id',
      );

  $$AttendanceRecordsTableProcessedTableManager get attendanceRecordsRefs {
    final manager = $$AttendanceRecordsTableTableManager(
      $_db,
      $_db.attendanceRecords,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _attendanceRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyDays => $composableBuilder(
    column: $table.weeklyDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Weekday>, List<Weekday>, String>
  get routineWeekdays => $composableBuilder(
    column: $table.routineWeekdays,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get currentlyTeaching => $composableBuilder(
    column: $table.currentlyTeaching,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get startDate =>
      $composableBuilder(
        column: $table.startDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get guardianName => $composableBuilder(
    column: $table.guardianName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> teachingPeriodsRefs(
    Expression<bool> Function($$TeachingPeriodsTableFilterComposer f) f,
  ) {
    final $$TeachingPeriodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teachingPeriods,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeachingPeriodsTableFilterComposer(
            $db: $db,
            $table: $db.teachingPeriods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> routinePeriodsRefs(
    Expression<bool> Function($$RoutinePeriodsTableFilterComposer f) f,
  ) {
    final $$RoutinePeriodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routinePeriods,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinePeriodsTableFilterComposer(
            $db: $db,
            $table: $db.routinePeriods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> attendanceRecordsRefs(
    Expression<bool> Function($$AttendanceRecordsTableFilterComposer f) f,
  ) {
    final $$AttendanceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendanceRecords,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.attendanceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyDays => $composableBuilder(
    column: $table.weeklyDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routineWeekdays => $composableBuilder(
    column: $table.routineWeekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get currentlyTeaching => $composableBuilder(
    column: $table.currentlyTeaching,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get guardianName => $composableBuilder(
    column: $table.guardianName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get weeklyDays => $composableBuilder(
    column: $table.weeklyDays,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<Weekday>, String> get routineWeekdays =>
      $composableBuilder(
        column: $table.routineWeekdays,
        builder: (column) => column,
      );

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get currentlyTeaching => $composableBuilder(
    column: $table.currentlyTeaching,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DateTime, String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get guardianName => $composableBuilder(
    column: $table.guardianName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> teachingPeriodsRefs<T extends Object>(
    Expression<T> Function($$TeachingPeriodsTableAnnotationComposer a) f,
  ) {
    final $$TeachingPeriodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teachingPeriods,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeachingPeriodsTableAnnotationComposer(
            $db: $db,
            $table: $db.teachingPeriods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> routinePeriodsRefs<T extends Object>(
    Expression<T> Function($$RoutinePeriodsTableAnnotationComposer a) f,
  ) {
    final $$RoutinePeriodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routinePeriods,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinePeriodsTableAnnotationComposer(
            $db: $db,
            $table: $db.routinePeriods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> attendanceRecordsRefs<T extends Object>(
    Expression<T> Function($$AttendanceRecordsTableAnnotationComposer a) f,
  ) {
    final $$AttendanceRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.attendanceRecords,
          getReferencedColumn: (t) => t.studentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AttendanceRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.attendanceRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StudentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentsTable,
          StudentRow,
          $$StudentsTableFilterComposer,
          $$StudentsTableOrderingComposer,
          $$StudentsTableAnnotationComposer,
          $$StudentsTableCreateCompanionBuilder,
          $$StudentsTableUpdateCompanionBuilder,
          (StudentRow, $$StudentsTableReferences),
          StudentRow,
          PrefetchHooks Function({
            bool teachingPeriodsRefs,
            bool routinePeriodsRefs,
            bool attendanceRecordsRefs,
          })
        > {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> weeklyDays = const Value.absent(),
                Value<List<Weekday>> routineWeekdays = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<bool> currentlyTeaching = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> guardianName = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion(
                id: id,
                name: name,
                weeklyDays: weeklyDays,
                routineWeekdays: routineWeekdays,
                color: color,
                currentlyTeaching: currentlyTeaching,
                startDate: startDate,
                phone: phone,
                guardianName: guardianName,
                address: address,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int weeklyDays,
                required List<Weekday> routineWeekdays,
                required String color,
                Value<bool> currentlyTeaching = const Value.absent(),
                required DateTime startDate,
                Value<String?> phone = const Value.absent(),
                Value<String?> guardianName = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion.insert(
                id: id,
                name: name,
                weeklyDays: weeklyDays,
                routineWeekdays: routineWeekdays,
                color: color,
                currentlyTeaching: currentlyTeaching,
                startDate: startDate,
                phone: phone,
                guardianName: guardianName,
                address: address,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StudentsTable, StudentRow>(table),
                  $$StudentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                teachingPeriodsRefs = false,
                routinePeriodsRefs = false,
                attendanceRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (teachingPeriodsRefs) db.teachingPeriods,
                    if (routinePeriodsRefs) db.routinePeriods,
                    if (attendanceRecordsRefs) db.attendanceRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (teachingPeriodsRefs)
                        await $_getPrefetchedData<
                          StudentRow,
                          $StudentsTable,
                          TeachingPeriodRow
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._teachingPeriodsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).teachingPeriodsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (routinePeriodsRefs)
                        await $_getPrefetchedData<
                          StudentRow,
                          $StudentsTable,
                          RoutinePeriodRow
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._routinePeriodsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).routinePeriodsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (attendanceRecordsRefs)
                        await $_getPrefetchedData<
                          StudentRow,
                          $StudentsTable,
                          AttendanceRecordRow
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._attendanceRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).attendanceRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StudentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentsTable,
      StudentRow,
      $$StudentsTableFilterComposer,
      $$StudentsTableOrderingComposer,
      $$StudentsTableAnnotationComposer,
      $$StudentsTableCreateCompanionBuilder,
      $$StudentsTableUpdateCompanionBuilder,
      (StudentRow, $$StudentsTableReferences),
      StudentRow,
      PrefetchHooks Function({
        bool teachingPeriodsRefs,
        bool routinePeriodsRefs,
        bool attendanceRecordsRefs,
      })
    >;
typedef $$TeachingPeriodsTableCreateCompanionBuilder =
    TeachingPeriodsCompanion Function({
      required String id,
      required String studentId,
      required DateTime startDate,
      Value<DateTime?> endDate,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TeachingPeriodsTableUpdateCompanionBuilder =
    TeachingPeriodsCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TeachingPeriodsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TeachingPeriodsTable,
          TeachingPeriodRow
        > {
  $$TeachingPeriodsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('teaching_periods__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<String>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TeachingPeriodsTableFilterComposer
    extends Composer<_$AppDatabase, $TeachingPeriodsTable> {
  $$TeachingPeriodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get startDate =>
      $composableBuilder(
        column: $table.startDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, String> get endDate =>
      $composableBuilder(
        column: $table.endDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeachingPeriodsTableOrderingComposer
    extends Composer<_$AppDatabase, $TeachingPeriodsTable> {
  $$TeachingPeriodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeachingPeriodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeachingPeriodsTable> {
  $$TeachingPeriodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeachingPeriodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeachingPeriodsTable,
          TeachingPeriodRow,
          $$TeachingPeriodsTableFilterComposer,
          $$TeachingPeriodsTableOrderingComposer,
          $$TeachingPeriodsTableAnnotationComposer,
          $$TeachingPeriodsTableCreateCompanionBuilder,
          $$TeachingPeriodsTableUpdateCompanionBuilder,
          (TeachingPeriodRow, $$TeachingPeriodsTableReferences),
          TeachingPeriodRow,
          PrefetchHooks Function({bool studentId})
        > {
  $$TeachingPeriodsTableTableManager(
    _$AppDatabase db,
    $TeachingPeriodsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeachingPeriodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeachingPeriodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeachingPeriodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TeachingPeriodsCompanion(
                id: id,
                studentId: studentId,
                startDate: startDate,
                endDate: endDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TeachingPeriodsCompanion.insert(
                id: id,
                studentId: studentId,
                startDate: startDate,
                endDate: endDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TeachingPeriodsTable, TeachingPeriodRow>(table),
                  $$TeachingPeriodsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (studentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.studentId,
                                referencedTable:
                                    $$TeachingPeriodsTableReferences
                                        ._studentIdTable(db),
                                referencedColumn:
                                    $$TeachingPeriodsTableReferences
                                        ._studentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TeachingPeriodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeachingPeriodsTable,
      TeachingPeriodRow,
      $$TeachingPeriodsTableFilterComposer,
      $$TeachingPeriodsTableOrderingComposer,
      $$TeachingPeriodsTableAnnotationComposer,
      $$TeachingPeriodsTableCreateCompanionBuilder,
      $$TeachingPeriodsTableUpdateCompanionBuilder,
      (TeachingPeriodRow, $$TeachingPeriodsTableReferences),
      TeachingPeriodRow,
      PrefetchHooks Function({bool studentId})
    >;
typedef $$RoutinePeriodsTableCreateCompanionBuilder =
    RoutinePeriodsCompanion Function({
      required String id,
      required String studentId,
      required DateTime startDate,
      Value<DateTime?> endDate,
      required int weeklyDays,
      required List<Weekday> weekdays,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RoutinePeriodsTableUpdateCompanionBuilder =
    RoutinePeriodsCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<int> weeklyDays,
      Value<List<Weekday>> weekdays,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RoutinePeriodsTableReferences
    extends
        BaseReferences<_$AppDatabase, $RoutinePeriodsTable, RoutinePeriodRow> {
  $$RoutinePeriodsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('routine_periods__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<String>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoutinePeriodsTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinePeriodsTable> {
  $$RoutinePeriodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get startDate =>
      $composableBuilder(
        column: $table.startDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, String> get endDate =>
      $composableBuilder(
        column: $table.endDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get weeklyDays => $composableBuilder(
    column: $table.weeklyDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Weekday>, List<Weekday>, String>
  get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutinePeriodsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinePeriodsTable> {
  $$RoutinePeriodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyDays => $composableBuilder(
    column: $table.weeklyDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutinePeriodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinePeriodsTable> {
  $$RoutinePeriodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get weeklyDays => $composableBuilder(
    column: $table.weeklyDays,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<Weekday>, String> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutinePeriodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutinePeriodsTable,
          RoutinePeriodRow,
          $$RoutinePeriodsTableFilterComposer,
          $$RoutinePeriodsTableOrderingComposer,
          $$RoutinePeriodsTableAnnotationComposer,
          $$RoutinePeriodsTableCreateCompanionBuilder,
          $$RoutinePeriodsTableUpdateCompanionBuilder,
          (RoutinePeriodRow, $$RoutinePeriodsTableReferences),
          RoutinePeriodRow,
          PrefetchHooks Function({bool studentId})
        > {
  $$RoutinePeriodsTableTableManager(
    _$AppDatabase db,
    $RoutinePeriodsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinePeriodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinePeriodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinePeriodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<int> weeklyDays = const Value.absent(),
                Value<List<Weekday>> weekdays = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinePeriodsCompanion(
                id: id,
                studentId: studentId,
                startDate: startDate,
                endDate: endDate,
                weeklyDays: weeklyDays,
                weekdays: weekdays,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                required int weeklyDays,
                required List<Weekday> weekdays,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RoutinePeriodsCompanion.insert(
                id: id,
                studentId: studentId,
                startDate: startDate,
                endDate: endDate,
                weeklyDays: weeklyDays,
                weekdays: weekdays,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutinePeriodsTable, RoutinePeriodRow>(table),
                  $$RoutinePeriodsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (studentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.studentId,
                                referencedTable: $$RoutinePeriodsTableReferences
                                    ._studentIdTable(db),
                                referencedColumn:
                                    $$RoutinePeriodsTableReferences
                                        ._studentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RoutinePeriodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutinePeriodsTable,
      RoutinePeriodRow,
      $$RoutinePeriodsTableFilterComposer,
      $$RoutinePeriodsTableOrderingComposer,
      $$RoutinePeriodsTableAnnotationComposer,
      $$RoutinePeriodsTableCreateCompanionBuilder,
      $$RoutinePeriodsTableUpdateCompanionBuilder,
      (RoutinePeriodRow, $$RoutinePeriodsTableReferences),
      RoutinePeriodRow,
      PrefetchHooks Function({bool studentId})
    >;
typedef $$AttendanceRecordsTableCreateCompanionBuilder =
    AttendanceRecordsCompanion Function({
      required String id,
      required String studentId,
      required DateTime attendanceDate,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$AttendanceRecordsTableUpdateCompanionBuilder =
    AttendanceRecordsCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<DateTime> attendanceDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$AttendanceRecordsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AttendanceRecordsTable,
          AttendanceRecordRow
        > {
  $$AttendanceRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('attendance_records__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<String>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttendanceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String>
  get attendanceDate => $composableBuilder(
    column: $table.attendanceDate,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attendanceDate => $composableBuilder(
    column: $table.attendanceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get attendanceDate =>
      $composableBuilder(
        column: $table.attendanceDate,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttendanceRecordsTable,
          AttendanceRecordRow,
          $$AttendanceRecordsTableFilterComposer,
          $$AttendanceRecordsTableOrderingComposer,
          $$AttendanceRecordsTableAnnotationComposer,
          $$AttendanceRecordsTableCreateCompanionBuilder,
          $$AttendanceRecordsTableUpdateCompanionBuilder,
          (AttendanceRecordRow, $$AttendanceRecordsTableReferences),
          AttendanceRecordRow,
          PrefetchHooks Function({bool studentId})
        > {
  $$AttendanceRecordsTableTableManager(
    _$AppDatabase db,
    $AttendanceRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<DateTime> attendanceDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendanceRecordsCompanion(
                id: id,
                studentId: studentId,
                attendanceDate: attendanceDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required DateTime attendanceDate,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendanceRecordsCompanion.insert(
                id: id,
                studentId: studentId,
                attendanceDate: attendanceDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AttendanceRecordsTable, AttendanceRecordRow>(
                    table,
                  ),
                  $$AttendanceRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (studentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.studentId,
                                referencedTable:
                                    $$AttendanceRecordsTableReferences
                                        ._studentIdTable(db),
                                referencedColumn:
                                    $$AttendanceRecordsTableReferences
                                        ._studentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AttendanceRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttendanceRecordsTable,
      AttendanceRecordRow,
      $$AttendanceRecordsTableFilterComposer,
      $$AttendanceRecordsTableOrderingComposer,
      $$AttendanceRecordsTableAnnotationComposer,
      $$AttendanceRecordsTableCreateCompanionBuilder,
      $$AttendanceRecordsTableUpdateCompanionBuilder,
      (AttendanceRecordRow, $$AttendanceRecordsTableReferences),
      AttendanceRecordRow,
      PrefetchHooks Function({bool studentId})
    >;
typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<String> firstDayOfWeek,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<String> firstDayOfWeek,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstDayOfWeek => $composableBuilder(
    column: $table.firstDayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstDayOfWeek => $composableBuilder(
    column: $table.firstDayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get firstDayOfWeek => $composableBuilder(
    column: $table.firstDayOfWeek,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsRow,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            AppSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsTableTable,
              AppSettingsRow
            >,
          ),
          AppSettingsRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    _$AppDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> firstDayOfWeek = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AppSettingsTableCompanion(
                id: id,
                themeMode: themeMode,
                firstDayOfWeek: firstDayOfWeek,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> firstDayOfWeek = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => AppSettingsTableCompanion.insert(
                id: id,
                themeMode: themeMode,
                firstDayOfWeek: firstDayOfWeek,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTableTable, AppSettingsRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsTableTable,
                    AppSettingsRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTableTable,
      AppSettingsRow,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        AppSettingsRow,
        BaseReferences<_$AppDatabase, $AppSettingsTableTable, AppSettingsRow>,
      ),
      AppSettingsRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$TeachingPeriodsTableTableManager get teachingPeriods =>
      $$TeachingPeriodsTableTableManager(_db, _db.teachingPeriods);
  $$RoutinePeriodsTableTableManager get routinePeriods =>
      $$RoutinePeriodsTableTableManager(_db, _db.routinePeriods);
  $$AttendanceRecordsTableTableManager get attendanceRecords =>
      $$AttendanceRecordsTableTableManager(_db, _db.attendanceRecords);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
}
