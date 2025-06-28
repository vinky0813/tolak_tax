import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/services/receipt_service.dart';
import 'package:tolak_tax/widgets/section_container.dart';
import 'package:tolak_tax/widgets/summary_card.dart';
import 'package:tolak_tax/widgets/tax_widgets/metric_card.dart';
import 'package:tolak_tax/models/tax_classification_model.dart';
import 'package:tolak_tax/widgets/tax_widgets/tax_relief_progress_widget.dart';

class TaxReportScreen extends StatefulWidget {
  const TaxReportScreen({super.key});

  @override
  State<TaxReportScreen> createState() => _TaxReportScreenState();
}

class _TaxReportScreenState extends State<TaxReportScreen> {
  int selectedYear = DateTime.now().year;
  final List<int> availableYears = List.generate(
    5,
    (index) => DateTime.now().year - index,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final receiptService = Provider.of<ReceiptService>(context, listen: true);

    List<Receipt> allReceipts = receiptService.getCachedReceipts();
    List<Receipt> yearReceipts =
        _filterReceiptsByYear(allReceipts, selectedYear);

    final yearlyTaxData = _calculateYearlyTaxData(yearReceipts);

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Tax Report',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  _buildYearSelector(theme),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Year Overview Header
                      _buildYearOverviewHeader(theme, yearlyTaxData),
                      const SizedBox(height: 20),

                      // Tax Summary Cards
                      _buildTaxSummarySection(theme, yearlyTaxData),
                      const SizedBox(height: 20),

                      // Tax Relief Classes Breakdown
                      _buildTaxReliefClassesSection(
                          theme, yearReceipts, yearlyTaxData),
                      const SizedBox(height: 20),

                      // Claimable Receipts
                      _buildClaimableReceiptsSection(theme, yearReceipts),
                      const SizedBox(height: 20),

                      // Tax Insights and Recommendations
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearSelector(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedYear,
          dropdownColor: theme.colorScheme.surface,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
          icon: Icon(Icons.keyboard_arrow_down,
              color: theme.colorScheme.onPrimary),
          items: availableYears
              .map((year) => DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  ))
              .toList(),
          onChanged: (newYear) {
            if (newYear != null) {
              setState(() {
                selectedYear = newYear;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildYearOverviewHeader(
      ThemeData theme, Map<String, dynamic> yearlyData) {
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

  Widget _buildTaxSummarySection(
      ThemeData theme, Map<String, dynamic> yearlyData) {
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
                  title: 'Non-Claimable Items',
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

  Widget _buildTaxReliefClassesSection(ThemeData theme, List<Receipt> receipts,
      Map<String, dynamic> yearlyData) {
    final taxReliefData = _calculateTaxReliefClassesBreakdown(receipts);
    final taxClassification = TaxClassifcation();

    // Get all available tax relief classes to show both used and unused ones
    final allTaxClasses = taxClassification.reliefLimits.keys.toList();

    // Define colors for different tax classes
    final taxClassColors = {
      'B': Colors.blue,
      'C': Colors.purple,
      'D': Colors.green,
      'E': Colors.orange,
      'F': Colors.red,
      'G': Colors.teal,
      'H': Colors.indigo,
      'I': Colors.amber,
      'J': Colors.cyan,
      'K': Colors.pink,
    };

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
                      taxClassification.reliefLimits[taxClass] ?? 0;
                  final spentAmount =
                      _calculateSpentAmountForTaxClass(receipts, taxClass);
                  final color = taxClassColors[taxClass] ?? Colors.blue;

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
                          taxClassification.reliefLimits[taxClass] ?? 0;
                      final color = taxClassColors[taxClass] ?? Colors.grey;

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

  Widget _buildClaimableReceiptsSection(
      ThemeData theme, List<Receipt> receipts) {
    final claimableReceipts = receipts
        .where((receipt) =>
            receipt.taxSummary != null && receipt.taxSummary!.totalTaxSaved > 0)
        .toList();

    // Sort by tax saved (highest first)
    claimableReceipts.sort((a, b) =>
        b.taxSummary!.totalTaxSaved.compareTo(a.taxSummary!.totalTaxSaved));

    return SectionContainer(
      title: 'Claimable Receipts (${claimableReceipts.length})',
      child: claimableReceipts.isEmpty
          ? Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'No claimable receipts found',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    'Add receipts with tax-claimable items to see them here',
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
                ...claimableReceipts.take(10).map((receipt) {
                  final taxSummary = receipt.taxSummary!;
                  final date = DateTime.parse(receipt.transactionDatetime);
                  final formattedDate = DateFormat('MMM dd, yyyy').format(date);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.store,
                            color: Colors.green.shade700,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                receipt.merchantName,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formattedDate,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${taxSummary.taxableItemsCount} claimable items • RM ${receipt.totalAmount.toStringAsFixed(2)} total',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.green.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'RM ${taxSummary.totalTaxSaved.toStringAsFixed(2)}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'tax saved',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.green.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                if (claimableReceipts.length > 10)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          // TODO: Navigate to full receipts list
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Showing top 10 of ${claimableReceipts.length} claimable receipts'),
                            ),
                          );
                        },
                        child: Text(
                          'View all ${claimableReceipts.length} claimable receipts',
                          style: TextStyle(color: Colors.green.shade700),
                        ),
                      ),
                    ),
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

    // Convert receipt sets to counts and sort by tax saved
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

  /// Calculate the total spent amount for a specific tax classification
  double _calculateSpentAmountForTaxClass(
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

  // Helper methods for data calculation
  List<Receipt> _filterReceiptsByYear(List<Receipt> receipts, int year) {
    return receipts.where((receipt) {
      final date = DateTime.parse(receipt.transactionDatetime);
      return date.year == year;
    }).toList();
  }

  Map<String, dynamic> _calculateYearlyTaxData(List<Receipt> receipts) {
    double totalTaxSaved = 0.0;
    double totalSpent = 0.0;
    int totalClaimableItems = 0;
    int totalNonClaimableItems = 0;

    for (var receipt in receipts) {
      totalSpent += receipt.totalAmount;
      totalTaxSaved += receipt.taxSummary?.totalTaxSaved ?? 0.0;
      totalClaimableItems += receipt.taxSummary?.taxableItemsCount ?? 0;
      totalNonClaimableItems += receipt.taxSummary?.exemptItemsCount ?? 0;
    }

    final taxEfficiencyRate =
        totalSpent > 0 ? (totalTaxSaved / totalSpent * 100) : 0.0;

    return {
      'totalReceipts': receipts.length,
      'totalTaxSaved': totalTaxSaved,
      'totalSpent': totalSpent,
      'totalClaimableItems': totalClaimableItems,
      'totalNonClaimableItems': totalNonClaimableItems,
      'taxEfficiencyRate': taxEfficiencyRate,
    };
  }
}
