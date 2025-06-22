import 'package:flutter/material.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/date_field.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/detail_field.dart';

class TransactionDetailsCard extends StatefulWidget {
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
  State<TransactionDetailsCard> createState() => _TransactionDetailsCardState();
}

class _TransactionDetailsCardState extends State<TransactionDetailsCard> {
  bool _isExpanded = true;

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
                Expanded(
                  child: Text(
                    'Transaction Details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              DateField(
                controller: widget.dateController,
                isEditing: widget.isEditing,
              ),
              const SizedBox(height: 12),
              DetailField(
                label: 'Payment Method',
                controller: widget.paymentMethodController,
                icon: Icons.payment,
                isEditing: widget.isEditing,
              ),
              const SizedBox(height: 12),
              DetailField(
                label: 'Currency',
                controller: widget.currencyController,
                icon: Icons.currency_exchange,
                isEditing: widget.isEditing,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
