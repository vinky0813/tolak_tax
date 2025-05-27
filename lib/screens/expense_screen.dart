import 'package:flutter/material.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final expenses = [
      {'title': 'Lunch', 'amount': 12.50, 'date': '2025-05-25'},
      {'title': 'Groceries', 'amount': 45.00, 'date': '2025-05-24'},
      {'title': 'Transport', 'amount': 8.75, 'date': '2025-05-23'},
    ];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Expenses'),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final expense = expenses[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.primaryColor.withOpacity(0.1),
                child: Icon(Icons.money, color: theme.primaryColor),
              ),
              title: Text(expense['title'] as String),
              subtitle: Text('Date: ${expense['date']}'),
              trailing: Text(
                'RM ${expense['amount']?.toString()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new expense logic here
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
