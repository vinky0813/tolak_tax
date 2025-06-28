import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';

class LineItemsCard extends StatelessWidget {
  final bool isEditing;
  final List<TextEditingController> descriptionControllers;
  final List<TextEditingController> quantityControllers;
  final List<TextEditingController> priceControllers;
  final VoidCallback onAddItem;
  final Function(int) onRemoveItem;

  const LineItemsCard({
    Key? key,
    required this.isEditing,
    required this.descriptionControllers,
    required this.quantityControllers,
    required this.priceControllers,
    required this.onAddItem,
    required this.onRemoveItem,
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
            if (descriptionControllers.isEmpty && !isEditing)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('No line items available.'),
              ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: descriptionControllers.length,
              itemBuilder: (context, index) {
                return _buildItemEntry(context, index);
              },
            ),

            if (isEditing) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onAddItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  Widget _buildItemEntry(BuildContext context, int index) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: isEditing
                    ? TextFormField(
                  controller: descriptionControllers[index],
                  decoration: const InputDecoration(labelText: 'Item Description'),
                )
                    : Text(
                  descriptionControllers[index].text,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              if (isEditing)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => onRemoveItem(index),
                ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: isEditing
                    ? TextFormField(
                  controller: quantityControllers[index],
                  decoration: const InputDecoration(labelText: 'Qty'),
                  keyboardType: TextInputType.number,
                )
                    : Text('Qty: ${quantityControllers[index].text}', style: theme.textTheme.bodySmall),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: isEditing
                    ? TextFormField(
                  controller: priceControllers[index],
                  decoration: const InputDecoration(labelText: 'Price', prefixText: '\$'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                )
                    : Text(
                  'Price: \$${double.tryParse(priceControllers[index].text)?.toStringAsFixed(2) ?? '0.00'}',
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
