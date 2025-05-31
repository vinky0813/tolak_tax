import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<Receipt> receipts;

  const WeeklyBarChart({super.key, required this.receipts});

  List<double> _calculateWeeklyTotals() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final dailyTotals = List<double>.filled(7, 0.0);

    for (var receipt in receipts) {
      final diff = receipt.date.difference(startOfWeek).inDays;
      if (diff >= 0 && diff < 7) {
        dailyTotals[diff] += receipt.amount;
      }
    }

    return dailyTotals;
  }

  @override
  Widget build(BuildContext context) {

    final dailyTotals = _calculateWeeklyTotals();
    final maxY = (dailyTotals.reduce((a, b) => a > b ? a : b) * 1.2).clamp(10.0, double.infinity);

    return SizedBox(
      height: 140,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (maxY / 5).clamp(2.0, double.infinity),
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  );
                },
                reservedSize: 28,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  return Text(
                    labels[value.toInt()],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  );
                },
                interval: 1,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: dailyTotals[i],
                  color: Colors.white,
                  width: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}