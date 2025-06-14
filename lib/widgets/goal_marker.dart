import 'package:flutter/material.dart';

Widget GoalMarker({
  required BuildContext context,
  required String label,
  required double currentProgress,
  required int goalValue,
  required int totalValue,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final double goalProgress = goalValue / totalValue;

  final Color achievedColor;
  switch (label) {
    case 'Bronze':
      achievedColor = Colors.brown[300]!;
      break;
    case 'Silver':
      achievedColor = Colors.grey[400]!;
      break;
    case 'Gold':
    default:
      achievedColor = Colors.amber[700]!;
      break;
  }

  final bool isAchieved = currentProgress >= goalProgress;
  final Color markerColor = isAchieved
      ? achievedColor
      : colorScheme.onPrimary.withOpacity(0.5);

  final double alignmentX = (goalProgress * 2) - 1;

  return Align(
    alignment: Alignment(alignmentX, 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.flag, size: 16, color: markerColor),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: markerColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}