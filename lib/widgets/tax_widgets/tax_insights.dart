import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';

class TaxInsights extends StatelessWidget {
  final Receipt receipt;

  const TaxInsights({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final insights = _generateTaxInsights();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb,
                  color: theme.colorScheme.onPrimaryContainer, size: 20),
              const SizedBox(width: 8),
              Text(
                'Tax Insights',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...insights.map((insight) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                        )),
                    Expanded(
                      child: Text(
                        insight,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  List<String> _generateTaxInsights() {
    final insights = <String>[];

    // Calculate tax amount from tax lines
    final taxAmount = receipt.lineItems
        .where((item) => item.taxLine != null)
        .fold(0.0, (sum, item) => sum + (item.taxLine?.taxAmount ?? 0.0));

    // Calculate total amount from line items
    final totalAmount =
        receipt.lineItems.fold(0.0, (sum, item) => sum + item.totalPrice);

    final taxSummary = receipt.taxSummary;
    final taxableCount = taxSummary?.taxableItemsCount ?? 0;
    final exemptCount = taxSummary?.exemptItemsCount ?? 0;

    if (taxAmount > 0 && totalAmount > 0) {
      final taxRate = (taxAmount / totalAmount * 100);
      insights.add(
          'Your effective "save rate" for this transaction is ${taxRate.toStringAsFixed(1)}%');
    }

    if (taxableCount > 0) {
      insights.add(
          'You have $taxableCount tax-claimable items that helped reduce your tax burden');
    }

    if (exemptCount > taxableCount) {
      insights.add(
          'Most items in this receipt are non-claimable - consider tax-claimable alternatives where possible');
    }

    if (taxSummary?.totalTaxSaved != null && taxSummary!.totalTaxSaved > 0) {
      insights.add(
          'You saved RM${taxSummary.totalTaxSaved.toStringAsFixed(2)} in taxes on this purchase');
    }

    final taxClasses = receipt.lineItems
        .where((item) => item.taxLine != null)
        .map((item) => item.taxLine!.taxClass)
        .toSet();

    taxClasses.remove('NA');

    if (taxClasses.isNotEmpty) {
      insights.add('Tax classes involved: ${taxClasses.join(', ')}');
    }

    return insights.isEmpty
        ? ['Keep this receipt for tax record-keeping purposes']
        : insights;
  }
}
