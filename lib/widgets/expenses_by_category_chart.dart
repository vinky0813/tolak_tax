import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/utils/category_helper.dart';

class ExpensesByCategoryChart extends StatelessWidget {
  final List<Receipt> receipts;

  const ExpensesByCategoryChart({super.key, required this.receipts});

  Map<String, double> getGroupedData() {
    final Map<String, double> groupedData = {};
    for (var receipt in receipts) {
      groupedData.update(receipt.expenseCategory, (value) => value + receipt.totalAmount,
          ifAbsent: () => receipt.totalAmount);
    }
    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = getGroupedData();

    if (groupedData.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    final total = groupedData.values.fold(0.0, (a, b) => a + b);

    return PieChart(
      PieChartData(
        sections: groupedData.entries.map((entry) {
          final color = CategoryHelper.getCategoryColor(entry.key);
          final percent = (entry.value / total) * 100;
          return PieChartSectionData(
            color: color,
            value: entry.value,
            title: '${percent.toStringAsFixed(1)}%',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }
}
