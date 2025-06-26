import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';

class TaxOverviewCard extends StatelessWidget {
  final Receipt receipt;
  const TaxOverviewCard({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final totalTaxAmount = receipt.taxSummary?.totalTaxSaved ?? 0.0;
    final totalAmount =
        receipt.lineItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    final taxPercentage =
        totalAmount > 0 ? (totalTaxAmount / totalAmount * 100) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long,
                  color: colorScheme.onPrimaryContainer, size: 24),
              const SizedBox(width: 8),
              Text(
                'Total Tax Claimable',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'RM ${totalTaxAmount.toStringAsFixed(2)}',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${taxPercentage.toStringAsFixed(1)}% of total amount',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimaryContainer.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
