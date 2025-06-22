import 'package:flutter/material.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/detail_field.dart';

class AdditionalInfoCard extends StatelessWidget {
  final TextEditingController expenseCategoryController;
  final bool isEditing;

  const AdditionalInfoCard({
    Key? key,
    required this.expenseCategoryController,
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
                  Icons.info_outline,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Additional Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DetailField(
              label: 'Expense Category',
              controller: expenseCategoryController,
              icon: Icons.category,
              isEditing: isEditing,
            ),
          ],
        ),
      ),
    );
  }
}
