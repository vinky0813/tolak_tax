import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/models/tax_classification_model.dart';
import 'package:tolak_tax/widgets/section_container.dart';
import 'package:tolak_tax/widgets/tax_widgets/tax_overview_card.dart';
import 'package:tolak_tax/widgets/tax_widgets/tax_summary_metrics.dart';
import 'package:tolak_tax/widgets/tax_widgets/tax_breakdown_items.dart';
import 'package:tolak_tax/widgets/tax_widgets/tax_category_info.dart';
import 'package:tolak_tax/widgets/tax_widgets/tax_calculation_details.dart';
import 'package:tolak_tax/widgets/tax_widgets/tax_insights.dart';

class TaxDetailsScreen extends StatelessWidget {
  final Receipt receipt;

  const TaxDetailsScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/receipt-details',
            arguments: receipt),
        icon: const Icon(Icons.receipt_long),
        label: const Text('Receipt Details'),
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tax Overview Section
                    SectionContainer(
                      title: 'Tax Overview',
                      child: Column(
                        children: [
                          TaxOverviewCard(receipt: receipt),
                          const SizedBox(height: 16),
                          TaxSummaryMetrics(receipt: receipt),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tax Breakdown by Items
                    if (receipt.lineItems.isNotEmpty)
                      SectionContainer(
                        title: 'Tax Breakdown by Items',
                        child: TaxBreakdownItems(receipt: receipt),
                      ),
                    const SizedBox(height: 16),

                    // Tax Classification
                    SectionContainer(
                      title: 'Tax Classification',
                      child: Column(
                        children: [
                          _buildTaxClassificationInfo(context),
                          const SizedBox(height: 12),
                          TaxCategoryInfo(receipt: receipt),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tax Calculation Details
                    SectionContainer(
                      title: 'Tax Calculation Details',
                      child: TaxCalculationDetails(receipt: receipt),
                    ),
                    const SizedBox(height: 16),

                    // Tax Insights & Tips
                    SectionContainer(
                      title: 'Tax Insights',
                      child: Column(
                        children: [
                          TaxInsights(receipt: receipt),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxClassificationInfo(BuildContext context) {
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

// Extension to add missing color scheme properties
extension ColorSchemeExtension on ColorScheme {
  Color? get successContainer => brightness == Brightness.light
      ? Colors.green.shade100
      : Colors.green.shade900;

  Color? get onSuccessContainer => brightness == Brightness.light
      ? Colors.green.shade800
      : Colors.green.shade100;

  Color? get warningContainer => brightness == Brightness.light
      ? Colors.orange.shade100
      : Colors.orange.shade900;

  Color? get onWarningContainer => brightness == Brightness.light
      ? Colors.orange.shade800
      : Colors.orange.shade100;
}
