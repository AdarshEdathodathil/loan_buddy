import 'package:drift/drift.dart';

class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get loanId => integer()();

  RealColumn get amount => real()();

  DateTimeColumn get paymentDate => dateTime()();

  /// Which EMI month this payment belongs to
  DateTimeColumn get emiForMonth => dateTime()();

  /// EMI, Part Payment, Prepayment, etc.
  TextColumn get paymentType =>
      text().withDefault(const Constant('EMI'))();

  TextColumn get remarks =>
      text().nullable()();

  BoolColumn get isEmi =>
      boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}