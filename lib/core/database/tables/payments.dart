import 'package:drift/drift.dart';

class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get loanId => integer()();

  RealColumn get amount => real()();

  DateTimeColumn get paymentDate => dateTime()();

  DateTimeColumn get emiForMonth => dateTime()();

  TextColumn get paymentType =>
      text().withDefault(const Constant('EMI'))();

  TextColumn get remarks => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}