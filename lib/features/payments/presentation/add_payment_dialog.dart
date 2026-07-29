import 'package:flutter/material.dart';
import 'package:loan_buddy/core/constants/payment_type.dart';

class AddPaymentDialog extends StatefulWidget {
  final double defaultAmount;
  final double outstandingAmount;

  const AddPaymentDialog({
    super.key,
    required this.defaultAmount,
    required this.outstandingAmount,
  });

  @override
  State<AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends State<AddPaymentDialog> {
  late TextEditingController amountController;

  DateTime paymentDate = DateTime.now();

  String paymentType = PaymentType.emi;

  final remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();

    amountController = TextEditingController(
      text: widget.defaultAmount.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(switch (paymentType) {
        PaymentType.emi => "Pay EMI",
        PaymentType.partPayment => "Part Payment",
        PaymentType.foreclosure => "Close Loan",
        _ => "Payment",
      }),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              readOnly: paymentType == PaymentType.foreclosure,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: "Payment Amount",
                prefixText: "₹ ",
                helperText: paymentType == PaymentType.foreclosure
                    ? "Outstanding balance will be paid."
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: paymentType,
              decoration: const InputDecoration(labelText: "Payment Type"),
              items: PaymentType.values
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  paymentType = value!;

                  switch (paymentType) {
                    case PaymentType.emi:
                      amountController.text = widget.defaultAmount
                          .toStringAsFixed(0);
                      break;

                    case PaymentType.partPayment:
                      amountController.clear();
                      break;

                    case PaymentType.foreclosure:
                      amountController.text = widget.outstandingAmount
                          .toStringAsFixed(0);
                      break;
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: remarksController,
              decoration: const InputDecoration(
                labelText: "Remarks (Optional)",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            final amount = double.tryParse(amountController.text);

            if (amount == null || amount <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Enter a valid payment amount.")),
              );
              return;
            }

            // Show confirmation only for foreclosure
            if (paymentType == PaymentType.foreclosure) {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Close Loan?"),
                  content: Text(
                    "This will pay the remaining outstanding amount of "
                    "₹${widget.outstandingAmount.toStringAsFixed(0)} and permanently close this loan.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Close Loan"),
                    ),
                  ],
                ),
              );

              if (!mounted) return;

              if (confirmed != true) return;
            }

            // ignore: use_build_context_synchronously
            Navigator.pop(context, {
              "amount": amount,
              "date": paymentDate,
              "type": paymentType,
              "remarks": remarksController.text,
            });
          },
          child: Text(
            paymentType == PaymentType.foreclosure
                ? "Close Loan"
                : "Save Payment",
          ),
        ),
      ],
    );
  }
}
