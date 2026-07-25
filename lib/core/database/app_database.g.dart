// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LoansTable extends Loans with TableInfo<$LoansTable, Loan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lenderMeta = const VerificationMeta('lender');
  @override
  late final GeneratedColumn<String> lender = GeneratedColumn<String>(
    'lender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loanTypeMeta = const VerificationMeta(
    'loanType',
  );
  @override
  late final GeneratedColumn<int> loanType = GeneratedColumn<int>(
    'loan_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outstandingAmountMeta = const VerificationMeta(
    'outstandingAmount',
  );
  @override
  late final GeneratedColumn<double> outstandingAmount =
      GeneratedColumn<double>(
        'outstanding_amount',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _interestRateMeta = const VerificationMeta(
    'interestRate',
  );
  @override
  late final GeneratedColumn<double> interestRate = GeneratedColumn<double>(
    'interest_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emiAmountMeta = const VerificationMeta(
    'emiAmount',
  );
  @override
  late final GeneratedColumn<double> emiAmount = GeneratedColumn<double>(
    'emi_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDayMeta = const VerificationMeta('dueDay');
  @override
  late final GeneratedColumn<int> dueDay = GeneratedColumn<int>(
    'due_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
  static const VerificationMeta _reminderEnabledMeta = const VerificationMeta(
    'reminderEnabled',
  );
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
    'reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isClosedMeta = const VerificationMeta(
    'isClosed',
  );
  @override
  late final GeneratedColumn<bool> isClosed = GeneratedColumn<bool>(
    'is_closed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_closed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    lender,
    loanType,
    totalAmount,
    outstandingAmount,
    interestRate,
    emiAmount,
    dueDay,
    startDate,
    endDate,
    notes,
    reminderEnabled,
    isClosed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loans';
  @override
  VerificationContext validateIntegrity(
    Insertable<Loan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('lender')) {
      context.handle(
        _lenderMeta,
        lender.isAcceptableOrUnknown(data['lender']!, _lenderMeta),
      );
    } else if (isInserting) {
      context.missing(_lenderMeta);
    }
    if (data.containsKey('loan_type')) {
      context.handle(
        _loanTypeMeta,
        loanType.isAcceptableOrUnknown(data['loan_type']!, _loanTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_loanTypeMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('outstanding_amount')) {
      context.handle(
        _outstandingAmountMeta,
        outstandingAmount.isAcceptableOrUnknown(
          data['outstanding_amount']!,
          _outstandingAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_outstandingAmountMeta);
    }
    if (data.containsKey('interest_rate')) {
      context.handle(
        _interestRateMeta,
        interestRate.isAcceptableOrUnknown(
          data['interest_rate']!,
          _interestRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_interestRateMeta);
    }
    if (data.containsKey('emi_amount')) {
      context.handle(
        _emiAmountMeta,
        emiAmount.isAcceptableOrUnknown(data['emi_amount']!, _emiAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_emiAmountMeta);
    }
    if (data.containsKey('due_day')) {
      context.handle(
        _dueDayMeta,
        dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDayMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
        _reminderEnabledMeta,
        reminderEnabled.isAcceptableOrUnknown(
          data['reminder_enabled']!,
          _reminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('is_closed')) {
      context.handle(
        _isClosedMeta,
        isClosed.isAcceptableOrUnknown(data['is_closed']!, _isClosedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Loan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Loan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lender'],
      )!,
      loanType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loan_type'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      outstandingAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}outstanding_amount'],
      )!,
      interestRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}interest_rate'],
      )!,
      emiAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}emi_amount'],
      )!,
      dueDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_day'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      reminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_enabled'],
      )!,
      isClosed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_closed'],
      )!,
    );
  }

  @override
  $LoansTable createAlias(String alias) {
    return $LoansTable(attachedDatabase, alias);
  }
}

class Loan extends DataClass implements Insertable<Loan> {
  final int id;
  final String name;
  final String lender;
  final int loanType;
  final double totalAmount;
  final double outstandingAmount;
  final double interestRate;
  final double emiAmount;
  final int dueDay;
  final DateTime startDate;
  final DateTime endDate;
  final String? notes;
  final bool reminderEnabled;
  final bool isClosed;
  const Loan({
    required this.id,
    required this.name,
    required this.lender,
    required this.loanType,
    required this.totalAmount,
    required this.outstandingAmount,
    required this.interestRate,
    required this.emiAmount,
    required this.dueDay,
    required this.startDate,
    required this.endDate,
    this.notes,
    required this.reminderEnabled,
    required this.isClosed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['lender'] = Variable<String>(lender);
    map['loan_type'] = Variable<int>(loanType);
    map['total_amount'] = Variable<double>(totalAmount);
    map['outstanding_amount'] = Variable<double>(outstandingAmount);
    map['interest_rate'] = Variable<double>(interestRate);
    map['emi_amount'] = Variable<double>(emiAmount);
    map['due_day'] = Variable<int>(dueDay);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    map['is_closed'] = Variable<bool>(isClosed);
    return map;
  }

  LoansCompanion toCompanion(bool nullToAbsent) {
    return LoansCompanion(
      id: Value(id),
      name: Value(name),
      lender: Value(lender),
      loanType: Value(loanType),
      totalAmount: Value(totalAmount),
      outstandingAmount: Value(outstandingAmount),
      interestRate: Value(interestRate),
      emiAmount: Value(emiAmount),
      dueDay: Value(dueDay),
      startDate: Value(startDate),
      endDate: Value(endDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      reminderEnabled: Value(reminderEnabled),
      isClosed: Value(isClosed),
    );
  }

  factory Loan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Loan(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      lender: serializer.fromJson<String>(json['lender']),
      loanType: serializer.fromJson<int>(json['loanType']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      outstandingAmount: serializer.fromJson<double>(json['outstandingAmount']),
      interestRate: serializer.fromJson<double>(json['interestRate']),
      emiAmount: serializer.fromJson<double>(json['emiAmount']),
      dueDay: serializer.fromJson<int>(json['dueDay']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      isClosed: serializer.fromJson<bool>(json['isClosed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'lender': serializer.toJson<String>(lender),
      'loanType': serializer.toJson<int>(loanType),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'outstandingAmount': serializer.toJson<double>(outstandingAmount),
      'interestRate': serializer.toJson<double>(interestRate),
      'emiAmount': serializer.toJson<double>(emiAmount),
      'dueDay': serializer.toJson<int>(dueDay),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'notes': serializer.toJson<String?>(notes),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'isClosed': serializer.toJson<bool>(isClosed),
    };
  }

  Loan copyWith({
    int? id,
    String? name,
    String? lender,
    int? loanType,
    double? totalAmount,
    double? outstandingAmount,
    double? interestRate,
    double? emiAmount,
    int? dueDay,
    DateTime? startDate,
    DateTime? endDate,
    Value<String?> notes = const Value.absent(),
    bool? reminderEnabled,
    bool? isClosed,
  }) => Loan(
    id: id ?? this.id,
    name: name ?? this.name,
    lender: lender ?? this.lender,
    loanType: loanType ?? this.loanType,
    totalAmount: totalAmount ?? this.totalAmount,
    outstandingAmount: outstandingAmount ?? this.outstandingAmount,
    interestRate: interestRate ?? this.interestRate,
    emiAmount: emiAmount ?? this.emiAmount,
    dueDay: dueDay ?? this.dueDay,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    notes: notes.present ? notes.value : this.notes,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    isClosed: isClosed ?? this.isClosed,
  );
  Loan copyWithCompanion(LoansCompanion data) {
    return Loan(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      lender: data.lender.present ? data.lender.value : this.lender,
      loanType: data.loanType.present ? data.loanType.value : this.loanType,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      outstandingAmount: data.outstandingAmount.present
          ? data.outstandingAmount.value
          : this.outstandingAmount,
      interestRate: data.interestRate.present
          ? data.interestRate.value
          : this.interestRate,
      emiAmount: data.emiAmount.present ? data.emiAmount.value : this.emiAmount,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      isClosed: data.isClosed.present ? data.isClosed.value : this.isClosed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Loan(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lender: $lender, ')
          ..write('loanType: $loanType, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('outstandingAmount: $outstandingAmount, ')
          ..write('interestRate: $interestRate, ')
          ..write('emiAmount: $emiAmount, ')
          ..write('dueDay: $dueDay, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('notes: $notes, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('isClosed: $isClosed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    lender,
    loanType,
    totalAmount,
    outstandingAmount,
    interestRate,
    emiAmount,
    dueDay,
    startDate,
    endDate,
    notes,
    reminderEnabled,
    isClosed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Loan &&
          other.id == this.id &&
          other.name == this.name &&
          other.lender == this.lender &&
          other.loanType == this.loanType &&
          other.totalAmount == this.totalAmount &&
          other.outstandingAmount == this.outstandingAmount &&
          other.interestRate == this.interestRate &&
          other.emiAmount == this.emiAmount &&
          other.dueDay == this.dueDay &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.notes == this.notes &&
          other.reminderEnabled == this.reminderEnabled &&
          other.isClosed == this.isClosed);
}

class LoansCompanion extends UpdateCompanion<Loan> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> lender;
  final Value<int> loanType;
  final Value<double> totalAmount;
  final Value<double> outstandingAmount;
  final Value<double> interestRate;
  final Value<double> emiAmount;
  final Value<int> dueDay;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String?> notes;
  final Value<bool> reminderEnabled;
  final Value<bool> isClosed;
  const LoansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.lender = const Value.absent(),
    this.loanType = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.outstandingAmount = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.emiAmount = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.isClosed = const Value.absent(),
  });
  LoansCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String lender,
    required int loanType,
    required double totalAmount,
    required double outstandingAmount,
    required double interestRate,
    required double emiAmount,
    required int dueDay,
    required DateTime startDate,
    required DateTime endDate,
    this.notes = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.isClosed = const Value.absent(),
  }) : name = Value(name),
       lender = Value(lender),
       loanType = Value(loanType),
       totalAmount = Value(totalAmount),
       outstandingAmount = Value(outstandingAmount),
       interestRate = Value(interestRate),
       emiAmount = Value(emiAmount),
       dueDay = Value(dueDay),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<Loan> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? lender,
    Expression<int>? loanType,
    Expression<double>? totalAmount,
    Expression<double>? outstandingAmount,
    Expression<double>? interestRate,
    Expression<double>? emiAmount,
    Expression<int>? dueDay,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? notes,
    Expression<bool>? reminderEnabled,
    Expression<bool>? isClosed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (lender != null) 'lender': lender,
      if (loanType != null) 'loan_type': loanType,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (outstandingAmount != null) 'outstanding_amount': outstandingAmount,
      if (interestRate != null) 'interest_rate': interestRate,
      if (emiAmount != null) 'emi_amount': emiAmount,
      if (dueDay != null) 'due_day': dueDay,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (notes != null) 'notes': notes,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (isClosed != null) 'is_closed': isClosed,
    });
  }

  LoansCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? lender,
    Value<int>? loanType,
    Value<double>? totalAmount,
    Value<double>? outstandingAmount,
    Value<double>? interestRate,
    Value<double>? emiAmount,
    Value<int>? dueDay,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<String?>? notes,
    Value<bool>? reminderEnabled,
    Value<bool>? isClosed,
  }) {
    return LoansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      lender: lender ?? this.lender,
      loanType: loanType ?? this.loanType,
      totalAmount: totalAmount ?? this.totalAmount,
      outstandingAmount: outstandingAmount ?? this.outstandingAmount,
      interestRate: interestRate ?? this.interestRate,
      emiAmount: emiAmount ?? this.emiAmount,
      dueDay: dueDay ?? this.dueDay,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      isClosed: isClosed ?? this.isClosed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lender.present) {
      map['lender'] = Variable<String>(lender.value);
    }
    if (loanType.present) {
      map['loan_type'] = Variable<int>(loanType.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (outstandingAmount.present) {
      map['outstanding_amount'] = Variable<double>(outstandingAmount.value);
    }
    if (interestRate.present) {
      map['interest_rate'] = Variable<double>(interestRate.value);
    }
    if (emiAmount.present) {
      map['emi_amount'] = Variable<double>(emiAmount.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (isClosed.present) {
      map['is_closed'] = Variable<bool>(isClosed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lender: $lender, ')
          ..write('loanType: $loanType, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('outstandingAmount: $outstandingAmount, ')
          ..write('interestRate: $interestRate, ')
          ..write('emiAmount: $emiAmount, ')
          ..write('dueDay: $dueDay, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('notes: $notes, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('isClosed: $isClosed')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _loanIdMeta = const VerificationMeta('loanId');
  @override
  late final GeneratedColumn<int> loanId = GeneratedColumn<int>(
    'loan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
    'payment_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emiForMonthMeta = const VerificationMeta(
    'emiForMonth',
  );
  @override
  late final GeneratedColumn<DateTime> emiForMonth = GeneratedColumn<DateTime>(
    'emi_for_month',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentTypeMeta = const VerificationMeta(
    'paymentType',
  );
  @override
  late final GeneratedColumn<String> paymentType = GeneratedColumn<String>(
    'payment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EMI'),
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    loanId,
    amount,
    paymentDate,
    emiForMonth,
    paymentType,
    remarks,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('loan_id')) {
      context.handle(
        _loanIdMeta,
        loanId.isAcceptableOrUnknown(data['loan_id']!, _loanIdMeta),
      );
    } else if (isInserting) {
      context.missing(_loanIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentDateMeta);
    }
    if (data.containsKey('emi_for_month')) {
      context.handle(
        _emiForMonthMeta,
        emiForMonth.isAcceptableOrUnknown(
          data['emi_for_month']!,
          _emiForMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_emiForMonthMeta);
    }
    if (data.containsKey('payment_type')) {
      context.handle(
        _paymentTypeMeta,
        paymentType.isAcceptableOrUnknown(
          data['payment_type']!,
          _paymentTypeMeta,
        ),
      );
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      loanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loan_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_date'],
      )!,
      emiForMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}emi_for_month'],
      )!,
      paymentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_type'],
      )!,
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final int id;
  final int loanId;
  final double amount;
  final DateTime paymentDate;
  final DateTime emiForMonth;
  final String paymentType;
  final String? remarks;
  final DateTime createdAt;
  const Payment({
    required this.id,
    required this.loanId,
    required this.amount,
    required this.paymentDate,
    required this.emiForMonth,
    required this.paymentType,
    this.remarks,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['loan_id'] = Variable<int>(loanId);
    map['amount'] = Variable<double>(amount);
    map['payment_date'] = Variable<DateTime>(paymentDate);
    map['emi_for_month'] = Variable<DateTime>(emiForMonth);
    map['payment_type'] = Variable<String>(paymentType);
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      loanId: Value(loanId),
      amount: Value(amount),
      paymentDate: Value(paymentDate),
      emiForMonth: Value(emiForMonth),
      paymentType: Value(paymentType),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      createdAt: Value(createdAt),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      loanId: serializer.fromJson<int>(json['loanId']),
      amount: serializer.fromJson<double>(json['amount']),
      paymentDate: serializer.fromJson<DateTime>(json['paymentDate']),
      emiForMonth: serializer.fromJson<DateTime>(json['emiForMonth']),
      paymentType: serializer.fromJson<String>(json['paymentType']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'loanId': serializer.toJson<int>(loanId),
      'amount': serializer.toJson<double>(amount),
      'paymentDate': serializer.toJson<DateTime>(paymentDate),
      'emiForMonth': serializer.toJson<DateTime>(emiForMonth),
      'paymentType': serializer.toJson<String>(paymentType),
      'remarks': serializer.toJson<String?>(remarks),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Payment copyWith({
    int? id,
    int? loanId,
    double? amount,
    DateTime? paymentDate,
    DateTime? emiForMonth,
    String? paymentType,
    Value<String?> remarks = const Value.absent(),
    DateTime? createdAt,
  }) => Payment(
    id: id ?? this.id,
    loanId: loanId ?? this.loanId,
    amount: amount ?? this.amount,
    paymentDate: paymentDate ?? this.paymentDate,
    emiForMonth: emiForMonth ?? this.emiForMonth,
    paymentType: paymentType ?? this.paymentType,
    remarks: remarks.present ? remarks.value : this.remarks,
    createdAt: createdAt ?? this.createdAt,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      loanId: data.loanId.present ? data.loanId.value : this.loanId,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      emiForMonth: data.emiForMonth.present
          ? data.emiForMonth.value
          : this.emiForMonth,
      paymentType: data.paymentType.present
          ? data.paymentType.value
          : this.paymentType,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('amount: $amount, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('emiForMonth: $emiForMonth, ')
          ..write('paymentType: $paymentType, ')
          ..write('remarks: $remarks, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    loanId,
    amount,
    paymentDate,
    emiForMonth,
    paymentType,
    remarks,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.loanId == this.loanId &&
          other.amount == this.amount &&
          other.paymentDate == this.paymentDate &&
          other.emiForMonth == this.emiForMonth &&
          other.paymentType == this.paymentType &&
          other.remarks == this.remarks &&
          other.createdAt == this.createdAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<int> loanId;
  final Value<double> amount;
  final Value<DateTime> paymentDate;
  final Value<DateTime> emiForMonth;
  final Value<String> paymentType;
  final Value<String?> remarks;
  final Value<DateTime> createdAt;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.loanId = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.emiForMonth = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.remarks = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int loanId,
    required double amount,
    required DateTime paymentDate,
    required DateTime emiForMonth,
    this.paymentType = const Value.absent(),
    this.remarks = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : loanId = Value(loanId),
       amount = Value(amount),
       paymentDate = Value(paymentDate),
       emiForMonth = Value(emiForMonth);
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<int>? loanId,
    Expression<double>? amount,
    Expression<DateTime>? paymentDate,
    Expression<DateTime>? emiForMonth,
    Expression<String>? paymentType,
    Expression<String>? remarks,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loanId != null) 'loan_id': loanId,
      if (amount != null) 'amount': amount,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (emiForMonth != null) 'emi_for_month': emiForMonth,
      if (paymentType != null) 'payment_type': paymentType,
      if (remarks != null) 'remarks': remarks,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? loanId,
    Value<double>? amount,
    Value<DateTime>? paymentDate,
    Value<DateTime>? emiForMonth,
    Value<String>? paymentType,
    Value<String?>? remarks,
    Value<DateTime>? createdAt,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      loanId: loanId ?? this.loanId,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      emiForMonth: emiForMonth ?? this.emiForMonth,
      paymentType: paymentType ?? this.paymentType,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (loanId.present) {
      map['loan_id'] = Variable<int>(loanId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    if (emiForMonth.present) {
      map['emi_for_month'] = Variable<DateTime>(emiForMonth.value);
    }
    if (paymentType.present) {
      map['payment_type'] = Variable<String>(paymentType.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('amount: $amount, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('emiForMonth: $emiForMonth, ')
          ..write('paymentType: $paymentType, ')
          ..write('remarks: $remarks, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LoansTable loans = $LoansTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [loans, payments];
}

typedef $$LoansTableCreateCompanionBuilder =
    LoansCompanion Function({
      Value<int> id,
      required String name,
      required String lender,
      required int loanType,
      required double totalAmount,
      required double outstandingAmount,
      required double interestRate,
      required double emiAmount,
      required int dueDay,
      required DateTime startDate,
      required DateTime endDate,
      Value<String?> notes,
      Value<bool> reminderEnabled,
      Value<bool> isClosed,
    });
typedef $$LoansTableUpdateCompanionBuilder =
    LoansCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> lender,
      Value<int> loanType,
      Value<double> totalAmount,
      Value<double> outstandingAmount,
      Value<double> interestRate,
      Value<double> emiAmount,
      Value<int> dueDay,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<String?> notes,
      Value<bool> reminderEnabled,
      Value<bool> isClosed,
    });

class $$LoansTableFilterComposer extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lender => $composableBuilder(
    column: $table.lender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loanType => $composableBuilder(
    column: $table.loanType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get outstandingAmount => $composableBuilder(
    column: $table.outstandingAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get emiAmount => $composableBuilder(
    column: $table.emiAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LoansTableOrderingComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lender => $composableBuilder(
    column: $table.lender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loanType => $composableBuilder(
    column: $table.loanType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get outstandingAmount => $composableBuilder(
    column: $table.outstandingAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get emiAmount => $composableBuilder(
    column: $table.emiAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LoansTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get lender =>
      $composableBuilder(column: $table.lender, builder: (column) => column);

  GeneratedColumn<int> get loanType =>
      $composableBuilder(column: $table.loanType, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get outstandingAmount => $composableBuilder(
    column: $table.outstandingAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get emiAmount =>
      $composableBuilder(column: $table.emiAmount, builder: (column) => column);

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => column);
}

class $$LoansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoansTable,
          Loan,
          $$LoansTableFilterComposer,
          $$LoansTableOrderingComposer,
          $$LoansTableAnnotationComposer,
          $$LoansTableCreateCompanionBuilder,
          $$LoansTableUpdateCompanionBuilder,
          (Loan, BaseReferences<_$AppDatabase, $LoansTable, Loan>),
          Loan,
          PrefetchHooks Function()
        > {
  $$LoansTableTableManager(_$AppDatabase db, $LoansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> lender = const Value.absent(),
                Value<int> loanType = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> outstandingAmount = const Value.absent(),
                Value<double> interestRate = const Value.absent(),
                Value<double> emiAmount = const Value.absent(),
                Value<int> dueDay = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<bool> isClosed = const Value.absent(),
              }) => LoansCompanion(
                id: id,
                name: name,
                lender: lender,
                loanType: loanType,
                totalAmount: totalAmount,
                outstandingAmount: outstandingAmount,
                interestRate: interestRate,
                emiAmount: emiAmount,
                dueDay: dueDay,
                startDate: startDate,
                endDate: endDate,
                notes: notes,
                reminderEnabled: reminderEnabled,
                isClosed: isClosed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String lender,
                required int loanType,
                required double totalAmount,
                required double outstandingAmount,
                required double interestRate,
                required double emiAmount,
                required int dueDay,
                required DateTime startDate,
                required DateTime endDate,
                Value<String?> notes = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<bool> isClosed = const Value.absent(),
              }) => LoansCompanion.insert(
                id: id,
                name: name,
                lender: lender,
                loanType: loanType,
                totalAmount: totalAmount,
                outstandingAmount: outstandingAmount,
                interestRate: interestRate,
                emiAmount: emiAmount,
                dueDay: dueDay,
                startDate: startDate,
                endDate: endDate,
                notes: notes,
                reminderEnabled: reminderEnabled,
                isClosed: isClosed,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LoansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoansTable,
      Loan,
      $$LoansTableFilterComposer,
      $$LoansTableOrderingComposer,
      $$LoansTableAnnotationComposer,
      $$LoansTableCreateCompanionBuilder,
      $$LoansTableUpdateCompanionBuilder,
      (Loan, BaseReferences<_$AppDatabase, $LoansTable, Loan>),
      Loan,
      PrefetchHooks Function()
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      required int loanId,
      required double amount,
      required DateTime paymentDate,
      required DateTime emiForMonth,
      Value<String> paymentType,
      Value<String?> remarks,
      Value<DateTime> createdAt,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      Value<int> loanId,
      Value<double> amount,
      Value<DateTime> paymentDate,
      Value<DateTime> emiForMonth,
      Value<String> paymentType,
      Value<String?> remarks,
      Value<DateTime> createdAt,
    });

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
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

  ColumnFilters<int> get loanId => $composableBuilder(
    column: $table.loanId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get emiForMonth => $composableBuilder(
    column: $table.emiForMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
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

  ColumnOrderings<int> get loanId => $composableBuilder(
    column: $table.loanId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get emiForMonth => $composableBuilder(
    column: $table.emiForMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get loanId =>
      $composableBuilder(column: $table.loanId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get emiForMonth => $composableBuilder(
    column: $table.emiForMonth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
          Payment,
          PrefetchHooks Function()
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> loanId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> paymentDate = const Value.absent(),
                Value<DateTime> emiForMonth = const Value.absent(),
                Value<String> paymentType = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                loanId: loanId,
                amount: amount,
                paymentDate: paymentDate,
                emiForMonth: emiForMonth,
                paymentType: paymentType,
                remarks: remarks,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int loanId,
                required double amount,
                required DateTime paymentDate,
                required DateTime emiForMonth,
                Value<String> paymentType = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                loanId: loanId,
                amount: amount,
                paymentDate: paymentDate,
                emiForMonth: emiForMonth,
                paymentType: paymentType,
                remarks: remarks,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
      Payment,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LoansTableTableManager get loans =>
      $$LoansTableTableManager(_db, _db.loans);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
}
