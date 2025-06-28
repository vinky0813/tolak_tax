import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/services/receipt_service.dart';
import 'package:tolak_tax/widgets/tax_widgets/year_overview_header.dart';
import 'package:tolak_tax/widgets/tax_widgets/tax_summary_section.dart';
import 'package:tolak_tax/widgets/tax_widgets/tax_relief_classes_section.dart';
import 'package:tolak_tax/widgets/tax_widgets/claimable_receipts_section.dart';

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

    List<Receipt> yearReceipts = receiptService.getReceiptsByYear(selectedYear);
    final yearlyTaxData = receiptService.getYearlyTaxData(selectedYear);

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
                      YearOverviewHeader(
                        selectedYear: selectedYear,
                        yearlyData: yearlyTaxData,
                      ),
                      const SizedBox(height: 20),

                      // Tax Summary Cards
                      TaxSummarySection(yearlyData: yearlyTaxData),
                      const SizedBox(height: 20),

                      // Tax Relief Classes Breakdown
                      TaxReliefClassesSection(
                        receipts: yearReceipts,
                        yearlyData: yearlyTaxData,
                      ),
                      const SizedBox(height: 20),

                      // Claimable Receipts
                      ClaimableReceiptsSection(receipts: yearReceipts),
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
}
