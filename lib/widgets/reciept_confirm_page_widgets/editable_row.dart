// lib/widgets/reciept_confirm_page_widgets/editable_row.dart

import 'package:flutter/material.dart';

class EditableRow extends StatelessWidget {
  final bool isEditing;
  final TextEditingController descriptionController;
  final TextEditingController amountController;
  final VoidCallback? onRemove;

  final String descriptionLabel;
  final String amountLabel;
  final String currencyPrefix;
  final Color viewModeBackgroundColor;
  final Color viewModeBorderColor;
  final Color viewModeAmountColor;

  const EditableRow({
    Key? key,
    required this.isEditing,
    required this.descriptionController,
    required this.amountController,
    this.onRemove,
    this.descriptionLabel = 'Description',
    this.amountLabel = 'Amount',
    this.currencyPrefix = '-\$',
    this.viewModeBackgroundColor = const Color(0x1AF44336),
    this.viewModeBorderColor = const Color(0x4DF44336),
    this.viewModeAmountColor = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return _buildEditingRow(context);
    } else {
      if (descriptionController.text.trim().isEmpty) {
        return const SizedBox.shrink();
      }
      return _buildViewingRow(context);
    }
  }

  Widget _buildEditingRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: descriptionLabel),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: amountController,
              decoration: InputDecoration(labelText: amountLabel),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          if (onRemove != null)
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }

  Widget _buildViewingRow(BuildContext context) {
    final theme = Theme.of(context);
    final amount = double.tryParse(amountController.text) ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: viewModeBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: viewModeBorderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              descriptionController.text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Text(
            '$currencyPrefix${amount.toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: viewModeAmountColor,
            ),
          ),
        ],
      ),
    );
  }
}