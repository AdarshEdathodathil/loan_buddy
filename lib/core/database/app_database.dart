import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/payments.dart';

part 'app_database.g.dart';

class Loans extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get lender => text()();

  IntColumn get loanType => integer()();

  RealColumn get totalAmount => real()();

  RealColumn get outstandingAmount => real()();

  RealColumn get interestRate => real()();

  RealColumn get emiAmount => real()();

  IntColumn get dueDay => integer()();

  DateTimeColumn get startDate => dateTime()();

  DateTimeColumn get endDate => dateTime()();

  TextColumn get notes => text().nullable()();

  BoolColumn get reminderEnabled =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get isClosed =>
      boolean().withDefault(const Constant(false))();
}

@DriftDatabase(
  tables: [
    Loans,
    Payments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File(
      p.join(dir.path, 'loan_buddy.sqlite'),
    );

    return NativeDatabase(file);
  });
}