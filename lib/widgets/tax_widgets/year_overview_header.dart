import 'package:flutter/material.dart';

class YearOverviewHeader extends StatelessWidget {
  final int selectedYear;
  final Map<String, dynamic> yearlyData;

  const YearOverviewHeader({
    super.key,
    required this.selectedYear,
    required this.yearlyData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assessment,
                color: theme.colorScheme.onPrimaryContainer,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Tax Year $selectedYear',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Total Tax Claimable: RM ${yearlyData['totalTaxSaved'].toStringAsFixed(2)}',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'From ${yearlyData['totalReceipts']} receipts • ${yearlyData['totalClaimableItems']} claimable items',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
