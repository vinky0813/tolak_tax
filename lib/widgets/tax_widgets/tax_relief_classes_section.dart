import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/widgets/section_container.dart';
import 'package:tolak_tax/models/tax_classification_model.dart';
import 'package:tolak_tax/widgets/tax_widgets/tax_relief_progress_widget.dart';

class TaxReliefClassesSection extends StatelessWidget {
  final List<Receipt> receipts;
  final Map<String, dynamic> yearlyData;

  const TaxReliefClassesSection({
    super.key,
    required this.receipts,
    required this.yearlyData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taxReliefData = _calculateTaxReliefClassesBreakdown(receipts);
    final taxClassification = TaxClassifcation();

    // Get all available tax relief classes to show both used and unused ones
    final allTaxClasses = taxClassification.reliefLimits.keys.toList();

    return SectionContainer(
      title: 'Tax Relief Progress',
      child: taxReliefData.isEmpty
          ? Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.info_outline,
                      size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'No tax relief classes identified',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    'Add more receipts with tax information to see your utilized tax relief classes',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Show used tax relief classes with progress row by row
                ...taxReliefData.entries.map((entry) {
                  final taxClass = entry.key;
                  final description =
                      taxClassification.taxReliefClasses[taxClass] ??
                          'Unknown tax class';
                  final reliefLimit =
                      taxClassification.getEffectiveReliefLimit(taxClass);
                  final spentAmount =
                      calculateSpentAmountForTaxClass(receipts, taxClass);
                  final color = Colors.blue;

                  return TaxReliefProgressWidget(
                    taxClass: taxClass,
                    description: description,
                    spentAmount: spentAmount,
                    reliefLimit: reliefLimit.toDouble(),
                    color: color,
                  );
                }).toList(),

                // Show unused tax relief classes (optional - you can remove this if you don't want to show them)
                const SizedBox(height: 16),
                ExpansionTile(
                  title: Text(
                    'Available Tax Relief Classes',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Tap to see unused tax relief opportunities',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  children: [
                    ...allTaxClasses
                        .where(
                            (taxClass) => !taxReliefData.containsKey(taxClass))
                        .map((taxClass) {
                      final description =
                          taxClassification.taxReliefClasses[taxClass] ??
                              'Unknown tax class';
                      final reliefLimit =
                          taxClassification.getEffectiveReliefLimit(taxClass);
                      final color = Colors.grey;

                      return TaxReliefProgressWidget(
                        taxClass: taxClass,
                        description: description,
                        spentAmount: 0.0,
                        reliefLimit: reliefLimit.toDouble(),
                        color: color.withOpacity(0.5),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
    );
  }

  Map<String, Map<String, dynamic>> _calculateTaxReliefClassesBreakdown(
      List<Receipt> receipts) {
    final Map<String, Map<String, dynamic>> taxReliefData = {};

    for (var receipt in receipts) {
      for (var item in receipt.lineItems) {
        if (item.taxLine != null &&
            item.taxLine!.taxEligible &&
            item.taxLine!.taxClass.isNotEmpty &&
            item.taxLine!.taxClass != 'NA') {
          final taxClass = item.taxLine!.taxClass;

          if (!taxReliefData.containsKey(taxClass)) {
            taxReliefData[taxClass] = {
              'receipts': <String>{}, // Using Set to avoid duplicate receipts
              'items': 0,
              'taxSaved': 0.0,
            };
          }

          (taxReliefData[taxClass]!['receipts'] as Set<String>)
              .add(receipt.merchantName + receipt.transactionDatetime);
          taxReliefData[taxClass]!['items']++;
          taxReliefData[taxClass]!['taxSaved'] += item.taxLine!.taxAmount;
        }
      }
    }

    final result = <String, Map<String, dynamic>>{};
    for (var entry in taxReliefData.entries) {
      result[entry.key] = {
        'receipts': (entry.value['receipts'] as Set<String>).length,
        'items': entry.value['items'],
        'taxSaved': entry.value['taxSaved'],
      };
    }

    final sortedEntries = result.entries.toList()
      ..sort((a, b) => b.value['taxSaved'].compareTo(a.value['taxSaved']));

    return Map.fromEntries(sortedEntries);
  }

  double calculateSpentAmountForTaxClass(
      List<Receipt> receipts, String taxClass) {
    double totalSpent = 0.0;

    for (var receipt in receipts) {
      for (var item in receipt.lineItems) {
        if (item.taxLine != null &&
            item.taxLine!.taxEligible &&
            item.taxLine!.taxClass == taxClass) {
          // Add the item total price
          totalSpent += item.totalPrice;
        }
      }
    }

    return totalSpent;
  }
}
