class PaymentType {
  const PaymentType._();

  static const emi = 'EMI';
  static const partPayment = 'Part Payment';
  static const foreclosure = 'Loan Foreclosure';

  static const values = [
    emi,
    partPayment,
    foreclosure,
  ];
}