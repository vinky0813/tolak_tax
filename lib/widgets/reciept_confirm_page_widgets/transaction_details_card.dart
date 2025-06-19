import 'package:flutter/material.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/date_field.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/detail_field.dart';

class TransactionDetailsCard extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController paymentMethodController;
  final TextEditingController currencyController;
  final bool isEditing;

  const TransactionDetailsCard({
    Key? key,
    required this.dateController,
    required this.paymentMethodController,
    required this.currencyController,
    required this.isEditing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Transaction Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DateField(
              controller: dateController,
              isEditing: isEditing,
            ),
            const SizedBox(height: 12),
            DetailField(
              label: 'Payment Method',
              controller: paymentMethodController,
              icon: Icons.payment,
              isEditing: isEditing,
            ),
            const SizedBox(height: 12),
            DetailField(
              label: 'Currency',
              controller: currencyController,
              icon: Icons.currency_exchange,
              isEditing: isEditing,
            ),
          ],
        ),
      ),
    );
  }
}
