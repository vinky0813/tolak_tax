import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Dummy data for charts & summary
    final totalExpenses = 1234.56;
    final deductibleAmount = 789.10;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.attach_money, color: colorScheme.primary),
                title: const Text('Total Expenses'),
                trailing: Text('RM ${totalExpenses.toStringAsFixed(2)}'),
              ),
            ),
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.check_circle_outline, color: colorScheme.primary),
                title: const Text('Tax Deductible'),
                trailing: Text('RM ${deductibleAmount.toStringAsFixed(2)}'),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Reports & Charts',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: Text(
                  'Charts coming soon 📊',
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
