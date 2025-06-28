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
import 'package:tolak_tax/widgets/tax_widgets/tax_classification_info.dart';

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
        onPressed: () => Navigator.pop(context),
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
                onPressed: () => Navigator.pop(context),
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
                          TaxClassificationInfo(receipt: receipt),
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
}
