import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';

class LineItemsCard extends StatelessWidget {
  final List<LineItem> lineItems;
  final bool isEditing;
  final List<TextEditingController> descriptionControllers;
  final List<TextEditingController> quantityControllers;
  final List<TextEditingController> priceControllers;

  const LineItemsCard({
    Key? key,
    required this.lineItems,
    required this.isEditing,
    required this.descriptionControllers,
    required this.quantityControllers,
    required this.priceControllers,
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
            for (int i = 0; i < lineItems.length; i++) _buildLineItem(i, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItem(int index, ThemeData theme) {
    final currentItem = lineItems[index];

    return isEditing
        ? Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              children: [
                TextFormField(
                  controller: descriptionControllers[index],
                  decoration: const InputDecoration(
                      labelText: 'Description',
                      border: InputBorder.none,
                      isDense: true),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: quantityControllers[index],
                        decoration: const InputDecoration(
                            labelText: 'Qty',
                            border: InputBorder.none,
                            isDense: true),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: priceControllers[index],
                        decoration: const InputDecoration(
                            labelText: 'Price',
                            prefixText: '\$',
                            border: InputBorder.none,
                            isDense: true),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        : Container(
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
                  currentItem.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Qty: ${currentItem.quantity} × \$${currentItem.originalUnitPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      '\$${currentItem.totalPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (currentItem.lineItemDiscountAmount != null &&
                    currentItem.lineItemDiscountAmount! > 0)
                  Text(
                    'Discount: -\$${currentItem.lineItemDiscountAmount!.toStringAsFixed(2)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          );
  }
}
