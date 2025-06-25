import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/widgets/receipt_item.dart';
import 'package:tolak_tax/widgets/section_container.dart';

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
                          _buildTaxOverviewCard(context),
                          const SizedBox(height: 16),
                          _buildTaxSummaryMetrics(context),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tax Breakdown by Items
                    if (receipt.lineItems.isNotEmpty)
                      SectionContainer(
                        title: 'Tax Breakdown by Items',
                        child: Column(
                          children: _buildTaxBreakdownItems(context),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Tax Classification
                    SectionContainer(
                      title: 'Tax Classification',
                      child: Column(
                        children: [
                          _buildTaxClassificationInfo(context),
                          const SizedBox(height: 12),
                          _buildCategoryTaxInfo(context),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tax Calculation Details
                    SectionContainer(
                      title: 'Tax Calculation Details',
                      child: Column(
                        children: _buildTaxCalculationDetails(context),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tax Insights & Tips
                    SectionContainer(
                      title: 'Tax Insights & Tips',
                      child: Column(
                        children: [
                          _buildTaxInsights(context),
                          const SizedBox(height: 12),
                          _buildTaxTips(context),
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

  Widget _buildTaxOverviewCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate tax amount from individual tax lines
    final totalTaxAmount = receipt.taxSummary?.totalTaxSaved ?? 0.0;

    // Calculate total amount from line items
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

  Widget _buildTaxSummaryMetrics(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final taxSummary = receipt.taxSummary;

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            context,
            'Taxable Items',
            '${taxSummary?.taxableItemsCount ?? 0}',
            Icons.check_circle,
            colorScheme.successContainer ?? Colors.green.shade100,
            colorScheme.onSuccessContainer ?? Colors.green.shade800,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            context,
            'Tax-Exempt Items',
            '${taxSummary?.exemptItemsCount ?? 0}',
            Icons.calculate,
            colorScheme.errorContainer,
            colorScheme.onErrorContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value,
      IconData icon, Color bgColor, Color textColor) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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
                            ? theme.colorScheme.successContainer
                            : theme.colorScheme.errorContainer ??
                                Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isTaxable ? 'CLAIMABLE' : 'TAX-EXEMPT',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isTaxable
                              ? theme.colorScheme.onSuccessContainer
                              : theme.colorScheme.onErrorContainer ??
                                  Colors.green.shade800,
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
                  color: theme.colorScheme.successContainer?.withOpacity(0.5),
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

  Widget _buildTaxClassificationInfo(BuildContext context) {
    final theme = Theme.of(context);

    // Get tax classes from tax lines
    final taxClasses = receipt.lineItems
        .where((item) => item.taxLine != null)
        .map((item) => item.taxLine!.taxClass)
        .toSet()
        .toList();

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
          ...taxClasses.map((taxClass) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '• ${taxClass}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCategoryTaxInfo(BuildContext context) {
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
        color: isOverallGood
            ? theme.colorScheme.successContainer ?? Colors.green.shade100
            : theme.colorScheme.warningContainer ?? Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isOverallGood ? Icons.check_circle : Icons.info,
            color: isOverallGood
                ? theme.colorScheme.onSuccessContainer ?? Colors.green.shade800
                : theme.colorScheme.onWarningContainer ??
                    Colors.orange.shade800,
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
                        ? theme.colorScheme.onSuccessContainer ??
                            Colors.green.shade800
                        : theme.colorScheme.onWarningContainer ??
                            Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  totalItems > 0
                      ? '${((exemptCount / totalItems) * 100).toStringAsFixed(0)}% of items are tax-exempt'
                      : 'No tax information available',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isOverallGood
                        ? theme.colorScheme.onSuccessContainer ??
                            Colors.green.shade800
                        : theme.colorScheme.onWarningContainer ??
                            Colors.orange.shade800,
                  ),
                ),
                if (taxSaved > 0)
                  Text(
                    'Tax saved: RM${taxSaved.toStringAsFixed(2)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isOverallGood
                          ? theme.colorScheme.onSuccessContainer ??
                              Colors.green.shade800
                          : theme.colorScheme.onWarningContainer ??
                              Colors.orange.shade800,
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

  List<Widget> _buildTaxCalculationDetails(BuildContext context) {
    // Calculate subtotal from line items before tax
    final subtotal = receipt.lineItems.fold(
        0.0,
        (sum, item) =>
            sum + (item.totalPrice - (item.taxLine?.taxAmount ?? 0.0)));

    // Calculate tax amount from tax lines
    final taxAmount = receipt.lineItems
        .where((item) => item.taxLine != null)
        .fold(0.0, (sum, item) => sum + (item.taxLine?.taxAmount ?? 0.0));

    // Calculate total from line items
    final total =
        receipt.lineItems.fold(0.0, (sum, item) => sum + item.totalPrice);

    return [
      ReceiptItem(
        icon: Icons.receipt_long,
        label: "Subtotal (Before Tax)",
        value: 'RM ${subtotal.toStringAsFixed(2)}',
      ),
      if (receipt.overallDiscounts != null &&
          receipt.overallDiscounts!.isNotEmpty)
        ...receipt.overallDiscounts!.map((discount) => ReceiptItem(
              icon: Icons.discount,
              label: "Discount: ${discount.description}",
              value: '-RM ${discount.amount.toStringAsFixed(2)}',
            )),
      const Divider(height: 16),
      ReceiptItem(
        icon: Icons.calculate,
        label: "Tax Applied",
        value: 'RM ${taxAmount.toStringAsFixed(2)}',
      ),
      ReceiptItem(
        icon: Icons.percent,
        label: "Effective Tax Rate",
        value:
            '${subtotal > 0 ? (taxAmount / subtotal * 100).toStringAsFixed(2) : '0.00'}%',
      ),
      const Divider(height: 16),
      ReceiptItem(
        icon: Icons.attach_money,
        label: "Final Total",
        value: 'RM ${total.toStringAsFixed(2)}',
      ),
    ];
  }

  Widget _buildTaxInsights(BuildContext context) {
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

  Widget _buildTaxTips(BuildContext context) {
    final theme = Theme.of(context);
    final tips = _generateTaxTips();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates,
                  color: theme.colorScheme.onSecondaryContainer, size: 20),
              const SizedBox(width: 8),
              Text(
                'Tax Tips',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('💡 ', style: TextStyle(fontSize: 12)),
                    Expanded(
                      child: Text(
                        tip,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
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
          'Your effective tax rate for this transaction is ${taxRate.toStringAsFixed(1)}%');
    }

    if (exemptCount > 0) {
      insights.add(
          'You have $exemptCount tax-exempt items that helped reduce your tax burden');
    }

    if (taxableCount > exemptCount) {
      insights.add(
          'Most items in this receipt are taxable - consider tax-exempt alternatives where possible');
    }

    if (taxSummary?.totalTaxSaved != null && taxSummary!.totalTaxSaved > 0) {
      insights.add(
          'You saved RM${taxSummary.totalTaxSaved.toStringAsFixed(2)} in taxes on this purchase');
    }

    // Get insights from tax classes
    final taxClasses = receipt.lineItems
        .where((item) => item.taxLine != null)
        .map((item) => item.taxLine!.taxClass)
        .toSet();

    if (taxClasses.isNotEmpty) {
      insights.add('Tax classes involved: ${taxClasses.join(', ')}');
    }

    return insights.isEmpty
        ? ['Keep this receipt for tax record-keeping purposes']
        : insights;
  }

  List<String> _generateTaxTips() {
    final tips = <String>[];

    tips.add('Keep all receipts organized for easy tax filing');
    tips.add('Consider using expense tracking apps to categorize purchases');

    // Get tax-related tips based on tax lines
    final taxableItems = receipt.lineItems
        .where((item) => item.taxLine != null && item.taxLine!.taxEligible)
        .toList();
    final exemptItems = receipt.lineItems
        .where((item) => item.taxLine != null && !item.taxLine!.taxEligible)
        .toList();

    if (taxableItems.isNotEmpty) {
      tips.add(
          'Document business purpose for taxable items to maximize deductions');
    }

    if (exemptItems.isNotEmpty) {
      tips.add(
          'Tax-exempt items can help reduce overall tax burden - look for similar alternatives');
    }

    // Get specific tax class advice
    final taxClasses = receipt.lineItems
        .where((item) => item.taxLine != null)
        .map((item) => item.taxLine!.taxClass)
        .toSet();

    for (final taxClass in taxClasses) {
      switch (taxClass.toLowerCase()) {
        case 'food':
        case 'meals':
          tips.add(
              'Business meals may have special deduction rules - consult tax guidelines');
          break;
        case 'supplies':
        case 'office':
          tips.add(
              'Office supplies are typically fully deductible for business use');
          break;
        case 'transport':
        case 'travel':
          tips.add('Keep detailed travel logs for transportation expenses');
          break;
      }
    }

    tips.add('Review tax regulations annually as they may change');

    return tips;
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
