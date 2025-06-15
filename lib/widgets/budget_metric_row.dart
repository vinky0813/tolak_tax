import 'package:flutter/material.dart';

Widget BudgetMetricRow(BuildContext context, String label, String value, {Color? valueColor}) {
  final theme = Theme.of(context);
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: theme.textTheme.titleMedium,
      ),
      Text(
        value,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: valueColor,
        ),
      ),
    ],
  );
}