import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/widgets/gamified_progress.dart';
import 'package:tolak_tax/widgets/quick_actionbutton.dart';
import 'package:tolak_tax/widgets/recent_receipts_list.dart';
import 'package:tolak_tax/widgets/section_container.dart';
import 'package:tolak_tax/widgets/summary_card.dart';
import 'package:tolak_tax/widgets/weekly_barchart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Dummy data for demo
    final int totalReceipts = 24;
    final double totalExpenses = 1523.75;
    final double totalTax = 123.45;
    final double taxDue = 40.00;
    final double totalMakanExpenses = 200.00;

    final recentReceipts = [
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
      Receipt.fromMap({
        'title': 'Groceries',
        'date': '2025-05-26',
        'amount': 45.00,
        'category': 'food',
      }),
      Receipt.fromMap({
        'title': 'Online Shopping',
        'date': '2025-05-27',
        'amount': 120.90,
        'category': 'shopping',
      }),
      Receipt.fromMap({
        'title': 'Electric Bill',
        'date': '2025-05-28',
        'amount': 75.50,
        'category': 'utilities',
      }),
      Receipt.fromMap({
        'title': 'Lunch with friends',
        'date': '2025-05-29',
        'amount': 28.40,
        'category': 'food',
      }),
      Receipt.fromMap({
        'title': 'Train ride',
        'date': '2025-06-2',
        'amount': 6.80,
        'category': 'transport',
        'imageUrl': 'https://via.placeholder.com/300x180.png?text=Receipt+Image',
      }),
      Receipt.fromMap({
        'title': 'Movie ticket',
        'date': '2025-06-03',
        'amount': 15.00,
        'category': 'entertainment',
        'imageUrl': 'https://via.placeholder.com/300x180.png?text=Receipt+Image',
      }),
      Receipt.fromMap({
        'title': 'Taxi',
        'date': '2025-06-04',
        'amount': 18.20,
        'category': 'transport',
        'imageUrl': 'https://via.placeholder.com/300x180.png?text=Receipt+Image',
      }),
    ];

    final userName = 'John';

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 260,
              backgroundColor: colorScheme.primary,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, right: 10),
                  child: IconButton(
                    icon: const Icon(Icons.settings),
                    color: colorScheme.onPrimary,
                    onPressed: () {
                      // handle go to settings
                      print("Settings button tapped");
                    },
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: colorScheme.primary,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor:
                                  colorScheme.onPrimary.withAlpha(40),
                              child: Icon(Icons.person,
                                  size: 32, color: colorScheme.onPrimary),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome!',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color:
                                        colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  userName,
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        WeeklyBarChart(receipts: recentReceipts,),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Summary Cards
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
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
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 12,
                          children: [
                            SummaryCard(
                              width: 70,
                                icon: Icons.receipt_long,
                                label: 'Receipts',
                                value: totalReceipts.toString(),
                                color: colorScheme.primary),
                            SummaryCard(
                                width: 70,
                                icon: Icons.money_off,
                                label: 'Expenses',
                                value: 'RM ${totalExpenses.toStringAsFixed(2)}',
                                color: Colors.redAccent),
                            SummaryCard(
                                width: 70,
                                icon: Icons.calculate,
                                label: 'Tax Calculated',
                                value: 'RM ${totalTax.toStringAsFixed(2)}',
                                color: Colors.green),
                            SummaryCard(
                                width: 70,
                                icon: Icons.attach_money,
                                label: 'Tax Due',
                                value: 'RM ${taxDue.toStringAsFixed(2)}',
                                color: Colors.orange),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      SectionContainer(title: 'Quick Actions', child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          QuickActionButton(
                            icon: Icons.camera_alt,
                            label: 'Scan Receipt',
                            onPressed: () {
                              // TODO: Add scan logic
                            },
                          ),
                          QuickActionButton(
                            icon: Icons.receipt,
                            label: 'View Receipts',
                            onPressed: () {
                              // TODO: Navigate to receipts list
                            },
                          ),
                          QuickActionButton(
                            icon: Icons.calculate,
                            label: 'Generate Report',
                            onPressed: () {
                              Navigator.pushNamed(context, '/generate-report');
                            },
                          ),
                        ],
                      ),),

                      const SizedBox(height: 20),

                      GamifiedProgress(
                        label: 'Makan',
                        budget: 500.0,
                        spent: totalMakanExpenses,
                      ),

                      const SizedBox(height: 20),

                      // Recent Receipts List Section
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: RecentReceiptsList(receipts: recentReceipts,),
                      ),
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
}
