import 'package:flutter/material.dart';
import 'package:tolak_tax/data/dummy_receipt_data.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/utils/category_helper.dart';
import 'package:tolak_tax/widgets/date_range_selector.dart';
import 'package:tolak_tax/widgets/monthly_expense_trend_chart.dart';
import 'package:tolak_tax/widgets/summary_card.dart';
import '../widgets/expenses_by_category_chart.dart';
import '../widgets/quick_actionbutton.dart';
import 'package:tolak_tax/services/receipt_service.dart';
import 'package:provider/provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime? startDate;
  DateTime? endDate;

  double getTotalAmount(List<Receipt> data) {
    return data.fold(0.0, (sum, item) {
      final amount = double.tryParse(item.totalAmount.toString()) ?? 0.0;
      return sum + amount;
    });
  }

  List<Receipt> getfilteredReceipts(List<Receipt> receipts) {
    return receipts.where((receipt) {
      if (startDate == null || endDate == null) return true;
      final transactionDatetime = DateTime.parse(receipt.transactionDatetime);
      return transactionDatetime
              .isAfter(startDate!.subtract(const Duration(days: 1))) &&
          transactionDatetime.isBefore(endDate!.add(const Duration(days: 1)));
    }).toList();
  }

  Map<String, double> _groupReceipts(filteredReceipts) {
    final Map<String, double> groupedData = {};
    for (var receipt in filteredReceipts) {
      groupedData.update(
          receipt.expenseCategory, (value) => value + receipt.totalAmount,
          ifAbsent: () => receipt.totalAmount);
    }
    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final receiptService = Provider.of<ReceiptService?>(context, listen: true);

    List<Receipt> receipts = receiptService?.getCachedReceipts() ?? [];
    List<Receipt> filteredReceipts = getfilteredReceipts(receipts);

    final groupedData = _groupReceipts(filteredReceipts);
    final colorScheme = theme.colorScheme;
    final totalAmount = getTotalAmount(filteredReceipts);

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 120,
              backgroundColor: theme.primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Reports',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
                titlePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              foregroundColor: colorScheme.onPrimary,
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: DateRangeSelector(
                        onRangeSelected: (start, end) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                startDate = start;
                                endDate = end;
                              });
                            }
                          });
                        },
                      ),
                    ),

                    // ==== Total Expenses Section ====
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // LEFT Container
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                spacing: 12,
                                children: [
                                  SummaryCard(
                                    width: 85,
                                    icon: Icons.receipt_long,
                                    label: 'Total Receipts',
                                    value: filteredReceipts.length.toString(),
                                    color: colorScheme.primary,
                                  ),
                                  SummaryCard(
                                    width: 85,
                                    icon: Icons.attach_money,
                                    label: 'Total Amount',
                                    value:
                                        'RM ${totalAmount.toStringAsFixed(2)}',
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // RIGHT Container
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: QuickActionButton(
                                  icon: Icons.calculate,
                                  label: 'Tax Report',
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/tax-report',
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Expenses by Category',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 300,
                            child: ExpensesByCategoryChart(
                                receipts: filteredReceipts),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: groupedData.entries.map((entry) {
                          final color =
                              CategoryHelper.getCategoryColor(entry.key);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: theme.textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  'RM ${entry.value.toStringAsFixed(2)}',
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Expense Trend',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 300,
                            child: MonthlyExpenseTrendChart(receipts: receipts),
                          ),
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
