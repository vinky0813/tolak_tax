import 'package:flutter/material.dart';
import 'package:tolak_tax/widgets/quick_actionbutton.dart';
import 'package:tolak_tax/widgets/summary_card.dart';

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

    final recentReceipts = [
      {'title': 'Starbucks Coffee', 'date': '2025-05-25', 'amount': 12.50},
      {'title': 'Office Supplies', 'date': '2025-05-23', 'amount': 98.75},
      {'title': 'Electricity Bill', 'date': '2025-05-20', 'amount': 150.00},
    ];

    final List<double> last7DaysExpenses = [50, 75, 30, 80, 65, 40, 90];
    final userName = 'John';

    // Simple bar chart widget
    Widget buildBar(double amount, double maxAmount) {
      final barHeight = (amount / maxAmount) * 80;
      return Container(
        width: 20,
        height: 80,
        alignment: Alignment.bottomCenter,
        child: Container(
          height: barHeight,
          decoration: BoxDecoration(
            color: colorScheme.secondary,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      );
    }

    final maxExpense = last7DaysExpenses.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 260,
              backgroundColor: colorScheme.primary,
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
                              backgroundColor: colorScheme.primary.withOpacity(0.3),
                              child: Icon(Icons.person, size: 32, color: colorScheme.onPrimary),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome!',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: colorScheme.onPrimary.withOpacity(0.9),
                                  ),
                                ),
                                Text(
                                  userName,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expenses last 7 days',
                              style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              child: Center(
                                child: Text("GRAPH HERE!!!"),
                              ),
                            )
                          ],
                        ),

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
                  color: colorScheme.surface,
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
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SummaryCard(
                                icon: Icons.receipt_long,
                                label: 'Receipts',
                                value: totalReceipts.toString(),
                                color: colorScheme.primary),
                            SummaryCard(
                                icon: Icons.money_off,
                                label: 'Expenses',
                                value: 'RM ${totalExpenses.toStringAsFixed(2)}',
                                color: Colors.redAccent),
                            SummaryCard(
                                icon: Icons.calculate,
                                label: 'Tax Calculated',
                                value: 'RM ${totalTax.toStringAsFixed(2)}',
                                color: Colors.green),
                            SummaryCard(
                                icon: Icons.attach_money,
                                label: 'Tax Due',
                                value: 'RM ${taxDue.toStringAsFixed(2)}',
                                color: Colors.orange),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Actions',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
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
                                  label: 'Calculate Tax',
                                  onPressed: () {
                                    // TODO: Navigate to tax calculation screen
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Recent Receipts List Section
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Receipts',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...recentReceipts.map(
                                  (receipt) => ListTile(
                                leading: const Icon(Icons.receipt),
                                title: Text("${receipt['title']!}"),
                                subtitle: Text("${receipt['date']!}"),
                                trailing: Text('RM ${receipt['amount']!.toString()}'),
                              ),
                            ),
                          ],
                        ),
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
