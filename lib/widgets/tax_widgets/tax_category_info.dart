import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';

class TaxCategoryInfo extends StatelessWidget {
  final Receipt receipt;

  const TaxCategoryInfo({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculate tax statistics from tax lines
    final taxableCount = receipt.taxSummary?.taxableItemsCount ?? 0;
    final exemptCount = receipt.taxSummary?.exemptItemsCount ?? 0;
    final totalItems = taxableCount + exemptCount;
    final taxSaved = receipt.taxSummary?.totalTaxSaved ?? 0.0;

    final isOverallGood = exemptCount >= taxableCount || taxSaved > 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOverallGood ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isOverallGood ? Icons.check_circle : Icons.info,
            color:
                isOverallGood ? Colors.green.shade800 : Colors.orange.shade800,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOverallGood
                      ? 'Tax-Optimized Purchase'
                      : 'Tax-Heavy Purchase',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: isOverallGood
                        ? Colors.green.shade800
                        : Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  totalItems > 0
                      ? '${((taxableCount / totalItems) * 100).toStringAsFixed(0)}% of items are tax-claimable'
                      : 'No tax information available',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isOverallGood
                        ? Colors.green.shade800
                        : Colors.orange.shade800,
                  ),
                ),
                if (taxSaved > 0)
                  Text(
                    'Tax saved: RM${taxSaved.toStringAsFixed(2)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isOverallGood
                          ? Colors.green.shade800
                          : Colors.orange.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
