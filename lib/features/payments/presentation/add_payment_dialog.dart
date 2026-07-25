import 'package:flutter/material.dart';

class AddPaymentDialog extends StatefulWidget {
  final double defaultAmount;

  const AddPaymentDialog({
    super.key,
    required this.defaultAmount,
  });

  @override
  State<AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends State<AddPaymentDialog> {
  late TextEditingController amountController;

  DateTime paymentDate = DateTime.now();

  String paymentType = "EMI";

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
      title: const Text("Pay EMI"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Payment Amount",
                prefixText: "₹ ",
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: paymentType,
              decoration: const InputDecoration(
                labelText: "Payment Type",
              ),
              items: const [
                DropdownMenuItem(
                  value: "EMI",
                  child: Text("EMI"),
                ),
                DropdownMenuItem(
                  value: "Part Payment",
                  child: Text("Part Payment"),
                ),
                DropdownMenuItem(
                  value: "Prepayment",
                  child: Text("Prepayment"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  paymentType = value!;
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
          onPressed: () {
            Navigator.pop(context, {
              "amount": double.parse(amountController.text),
              "date": paymentDate,
              "type": paymentType,
              "remarks": remarksController.text,
            });
          },
          child: const Text("Pay EMI"),
        ),
      ],
    );
  }
}