import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/editable_row.dart';

class DiscountsCard extends StatelessWidget {
  final bool isEditing;
  final List<TextEditingController> descriptionControllers;
  final List<TextEditingController> amountControllers;
  final VoidCallback onAddDiscount;
  final Function(int) onRemoveDiscount;

  const DiscountsCard({
    Key? key,
    required this.isEditing,
    required this.descriptionControllers,
    required this.amountControllers,
    required this.onAddDiscount,
    required this.onRemoveDiscount,
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
                  Icons.discount,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Discounts',
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
                child: Text('No discounts applied.'),
              ),

            for (int i = 0; i < descriptionControllers.length; i++)
              EditableRow(
                isEditing: isEditing,
                descriptionController: descriptionControllers[i],
                amountController: amountControllers[i],
                descriptionLabel: 'Discount Description',
                onRemove: () => onRemoveDiscount(i),
              ),
            if (isEditing)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onAddDiscount,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Discount'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
