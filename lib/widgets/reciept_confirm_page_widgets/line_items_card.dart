import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';

class LineItemsCard extends StatelessWidget {
  final List<LineItem> lineItems;

  const LineItemsCard({
    Key? key,
    required this.lineItems,
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
                  Icons.list_alt,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Line Items',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...lineItems.map((item) => _buildLineItem(item, theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItem(LineItem item, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Qty: ${item.quantity} × \$${item.originalUnitPrice.toStringAsFixed(2)}',
                style: theme.textTheme.bodySmall,
              ),
              Text(
                '\$${item.totalPrice.toStringAsFixed(2)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (item.lineItemDiscountAmount != null &&
              item.lineItemDiscountAmount! > 0)
            Text(
              'Discount: -\$${item.lineItemDiscountAmount!.toStringAsFixed(2)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
