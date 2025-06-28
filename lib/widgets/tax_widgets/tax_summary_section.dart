import 'package:flutter/material.dart';
import 'package:tolak_tax/widgets/section_container.dart';
import 'package:tolak_tax/widgets/summary_card.dart';
import 'package:tolak_tax/widgets/tax_widgets/metric_card.dart';

class TaxSummarySection extends StatelessWidget {
  final Map<String, dynamic> yearlyData;

  const TaxSummarySection({
    super.key,
    required this.yearlyData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionContainer(
      title: 'Tax Summary',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  width: double.infinity,
                  icon: Icons.receipt_long,
                  label: 'Total Receipts',
                  value: yearlyData['totalReceipts'].toString(),
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  width: double.infinity,
                  icon: Icons.attach_money,
                  label: 'Total Spent',
                  value: 'RM ${yearlyData['totalSpent'].toStringAsFixed(0)}',
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: 'Tax Claimable Items',
                  value: yearlyData['totalClaimableItems'].toString(),
                  icon: Icons.check_circle,
                  bgColor: Colors.green.shade100,
                  textColor: Colors.green.shade800,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  title: 'Non Claimable Items',
                  value: yearlyData['totalNonClaimableItems'].toString(),
                  icon: Icons.cancel,
                  bgColor: theme.colorScheme.errorContainer,
                  textColor: theme.colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'Tax Efficiency Rate',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${yearlyData['taxEfficiencyRate'].toStringAsFixed(1)}%',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'of your total spending is tax-claimable',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.blue.shade600,
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
