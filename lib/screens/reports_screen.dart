import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/utils/category_helper.dart';
import 'package:tolak_tax/widgets/date_range_selector.dart';
import 'package:tolak_tax/widgets/month_dropdown.dart';
import 'package:tolak_tax/widgets/monthly_expense_trend_chart.dart';
import 'package:tolak_tax/widgets/summary_card.dart';
import 'package:tolak_tax/widgets/year_dropdown.dart';
import '../widgets/expenses_by_category_chart.dart';
import '../widgets/quick_actionbutton.dart';

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
      final amount = double.tryParse(item.amount.toString()) ?? 0.0;
      return sum + amount;
    });
  }

  final receipts = [
    Receipt.fromMap({
      'title': 'Starbucks Coffee',
      'date': '2025-05-25',
      'amount': 12.50,
      'category': 'food'
    }),
    Receipt.fromMap({
      'title': 'Office Supplies',
      'date': '2025-05-23',
      'amount': 98.75,
      'category': 'shopping'
    }),
    Receipt.fromMap({
      'title': 'Electricity Bill',
      'date': '2025-05-20',
      'amount': 150.00,
      'category': 'utilities'
    }),
    Receipt.fromMap({
      'title': 'Netflix Subscription',
      'date': '2025-05-19',
      'amount': 17.00,
      'category': 'entertainment'
    }),
    Receipt.fromMap({
      'title': 'Grab Ride',
      'date': '2025-05-18',
      'amount': 9.30,
      'category': 'transport'
    }),
    Receipt.fromMap({
      'title': 'Lunch at Nando\'s',
      'date': '2025-05-17',
      'amount': 35.00,
      'category': 'food'
    }),
    Receipt.fromMap({
      'title': 'Shopee Purchase',
      'date': '2025-05-15',
      'amount': 65.90,
      'category': 'shopping'
    }),
    Receipt.fromMap({
      'title': 'Celcom Postpaid',
      'date': '2025-05-13',
      'amount': 89.00,
      'category': 'utilities'
    }),
    Receipt.fromMap({
      'title': 'Cinema Tickets',
      'date': '2025-05-12',
      'amount': 28.00,
      'category': 'entertainment'
    }),
    Receipt.fromMap({
      'title': 'Petrol',
      'date': '2025-05-10',
      'amount': 120.00,
      'category': 'transport'
    }),
    Receipt.fromMap({
      'title': 'Grocery Shopping',
      'date': '2025-05-08',
      'amount': 210.40,
      'category': 'food'
    }),
    Receipt.fromMap({
      'title': 'Spotify Family Plan',
      'date': '2025-05-05',
      'amount': 22.40,
      'category': 'entertainment'
    }),
    Receipt.fromMap({
      'title': 'Parking Fee',
      'date': '2025-05-04',
      'amount': 3.50,
      'category': 'transport'
    }),
    Receipt.fromMap({
      'title': 'Electric Kettle',
      'date': '2025-05-02',
      'amount': 79.99,
      'category': 'shopping'
    }),
    Receipt.fromMap({
      'title': 'Water Bill',
      'date': '2025-04-29',
      'amount': 30.60,
      'category': 'utilities'
    }),
    Receipt.fromMap({
      'title': 'Dinner at Sushi King',
      'date': '2025-04-28',
      'amount': 47.25,
      'category': 'food'
    }),
    Receipt.fromMap({
      'title': 'Bookstore',
      'date': '2025-04-27',
      'amount': 54.90,
      'category': 'shopping'
    }),
  ];

  List<Receipt> get filteredReceipts {
    return receipts.where((receipt) {
      if (startDate == null || endDate == null) return true;
      return receipt.date.isAfter(startDate!.subtract(const Duration(days: 1))) &&
          receipt.date.isBefore(endDate!.add(const Duration(days: 1)));
    }).toList();
  }


  Map<String, double> _groupReceipts() {
    final Map<String, double> groupedData = {};
    for (var receipt in filteredReceipts) {
      groupedData.update(receipt.category, (value) => value + receipt.amount,
          ifAbsent: () => receipt.amount);
    }
    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupedData = _groupReceipts();
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
                titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              foregroundColor: colorScheme.onPrimary,
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.background,
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
                                    value: 'RM ${totalAmount.toStringAsFixed(2)}',
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
                                  label: 'Generate Report',
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/generate-report');
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
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 300,
                            child: ExpensesByCategoryChart(receipts: filteredReceipts),
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
                      final color = CategoryHelper.getCategoryColor(entry.key);
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
                  )
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
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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