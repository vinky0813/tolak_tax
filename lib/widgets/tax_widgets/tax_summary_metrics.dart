import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/widgets/tax_widgets/metric_card.dart';

class TaxSummaryMetrics extends StatelessWidget {
  final Receipt receipt;

  const TaxSummaryMetrics({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final taxSummary = receipt.taxSummary;

    return Row(
      children: [
        Expanded(
          child: MetricCard(
            title: 'Taxable Items',
            value: '${taxSummary?.taxableItemsCount ?? 0}',
            icon: Icons.check_circle,
            bgColor: Colors.green.shade100,
            textColor: Colors.green.shade800,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MetricCard(
            title: 'Non-Taxable Items',
            value: '${taxSummary?.exemptItemsCount ?? 0}',
            icon: Icons.calculate,
            bgColor: colorScheme.errorContainer,
            textColor: colorScheme.onErrorContainer,
          ),
        ),
      ],
    );
  }
}
