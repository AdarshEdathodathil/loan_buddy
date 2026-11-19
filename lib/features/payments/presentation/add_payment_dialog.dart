import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/constants/payment_type.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';
import 'package:intl/intl.dart';

class AddPaymentDialog extends ConsumerStatefulWidget {
  final double defaultAmount;
  final double outstandingAmount;

  const AddPaymentDialog({
    super.key,
    required this.defaultAmount,
    required this.outstandingAmount,
  });

  @override
  ConsumerState<AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends ConsumerState<AddPaymentDialog> {
  late TextEditingController amountController;

  DateTime paymentDate = DateTime.now();

  String paymentType = PaymentType.emi;

  final remarksController = TextEditingController();

  Future<void> _pickPaymentDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: paymentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selected != null) setState(() => paymentDate = selected);
  }

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
    final currency = ref.watch(currencyProvider);
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
                prefixText: "${currency.symbol} ",
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
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              leading: const Icon(Icons.event_outlined),
              title: const Text('Payment date'),
              subtitle: Text(DateFormat('d MMM yyyy').format(paymentDate)),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: _pickPaymentDate,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: remarksController,
              decoration: const InputDecoration(
                labelText: "Remarks (Optional)",
                prefixIcon: Icon(Icons.notes_rounded),
              ),
            ),
            if (paymentType != PaymentType.foreclosure) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'The outstanding balance updates immediately after this payment is saved.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],
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

            if (paymentType != PaymentType.foreclosure &&
                amount > widget.outstandingAmount) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Payment cannot exceed the outstanding balance.",
                  ),
                ),
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
                    "${CurrencyFormatter.format(widget.outstandingAmount, currency)} "
                    "and permanently close this loan.",
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
