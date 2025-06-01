import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'dart:math';

class MonthlyExpenseTrendChart extends StatelessWidget {
  final List<Receipt> receipts;

  const MonthlyExpenseTrendChart({super.key, required this.receipts});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Map<int, double> monthlyTotals = {};

    for (var receipt in receipts) {
      final month = receipt.date.month;
      monthlyTotals.update(month, (value) => value + receipt.amount,
          ifAbsent: () => receipt.amount);
    }

    final spots = monthlyTotals.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    final maxY = (spots.map((e) => e.y).fold(0.0, max) * 1.2).ceilToDouble();

    if (receipts.isEmpty) {
      return const Center(child: Text("No data available"));
    }
    return LineChart(
      LineChartData(
        minX: 1,
        maxX: 12,
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
          ),
          drawVerticalLine: false,
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxY / 5,
              getTitlesWidget: (value, meta) => Text(
                'RM${value.toInt()}',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
              reservedSize: 42,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const monthNames = [
                  '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                ];
                if (value >= 1 && value <= 12) {
                  return Text(monthNames[value.toInt()],
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: Colors.black12),
            bottom: BorderSide(color: Colors.black12),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: theme.primaryColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                radius: 3,
                color: Colors.white,
                strokeColor: theme.primaryColor,
                strokeWidth: 2,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: theme.primaryColor.withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }
}
