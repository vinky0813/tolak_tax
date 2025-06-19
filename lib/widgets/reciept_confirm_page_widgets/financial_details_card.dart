import 'package:flutter/material.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/detail_field.dart';

class FinancialDetailsCard extends StatefulWidget {
  final TextEditingController subtotalController;
  final TextEditingController taxAmountController;
  final TextEditingController totalAmountController;
  final bool isEditing;

  const FinancialDetailsCard({
    Key? key,
    required this.subtotalController,
    required this.taxAmountController,
    required this.totalAmountController,
    required this.isEditing,
  }) : super(key: key);

  @override
  State<FinancialDetailsCard> createState() => _FinancialDetailsCardState();
}

class _FinancialDetailsCardState extends State<FinancialDetailsCard> {
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
                  Icons.calculate,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Financial Details',
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
              DetailField(
                label: 'Subtotal',
                controller: widget.subtotalController,
                icon: Icons.receipt,
                isEditing: widget.isEditing,
                isAmount: true,
              ),
              const SizedBox(height: 12),
              DetailField(
                label: 'Tax Amount',
                controller: widget.taxAmountController,
                icon: Icons.percent,
                isEditing: widget.isEditing,
                isAmount: true,
              ),
              const SizedBox(height: 12),
              DetailField(
                label: 'Total Amount',
                controller: widget.totalAmountController,
                icon: Icons.attach_money,
                isRequired: true,
                isEditing: widget.isEditing,
                isAmount: true,
                isTotal: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
