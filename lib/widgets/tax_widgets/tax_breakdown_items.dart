import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';

class TaxBreakdownItems extends StatelessWidget {
  final Receipt receipt;

  const TaxBreakdownItems({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildTaxBreakdownItems(context),
    );
  }

  List<Widget> _buildTaxBreakdownItems(BuildContext context) {
    final theme = Theme.of(context);

    return receipt.lineItems.map((item) {
      final taxLine = item.taxLine;
      final isTaxable = taxLine?.taxEligible ?? false;
      final taxAmount = taxLine?.taxAmount ?? 0.0;

      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isTaxable
                ? theme.colorScheme.outline.withOpacity(0.3)
                : theme.colorScheme.error.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.description,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Qty: ${item.quantity.toStringAsFixed(0)} × RM${item.originalUnitPrice.toStringAsFixed(2)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isTaxable
                            ? Colors.green.shade100
                            : theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isTaxable ? 'CLAIMABLE' : 'EXEMPT',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isTaxable
                              ? Colors.green.shade800
                              : theme.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isTaxable) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Tax: RM${taxAmount.toStringAsFixed(2)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            if (taxLine != null && isTaxable) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade100.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tax Class: ${taxLine.taxClass}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (taxLine.taxClassDescription.isNotEmpty)
                      Text(
                        taxLine.taxClassDescription,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    }).toList();
  }
}
