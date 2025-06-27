import 'package:flutter/material.dart';
import 'package:tolak_tax/models/tax_classification_model.dart';
import 'package:tolak_tax/models/receipt_model.dart';

class TaxClassificationInfo extends StatelessWidget {
  final Receipt receipt;

  const TaxClassificationInfo({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get tax classes from tax lines
    final taxClasses = receipt.lineItems
        .where((item) => item.taxLine != null)
        .map((item) => item.taxLine!.taxClass)
        .toSet()
        .toList();
    taxClasses.remove('NA');

    if (taxClasses.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Tax Classification',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'No tax classification available',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.category, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Tax Classifications',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (taxClasses[0] == 'NA')
            Text(
              'No tax classes found',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            )
          else
            ...taxClasses.map((taxClass) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${taxClass} : ${TaxClassifcation().taxReliefClasses[taxClass]}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
