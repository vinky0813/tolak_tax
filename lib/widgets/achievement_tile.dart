import 'package:flutter/material.dart';

class AchievementTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final double width;

  const AchievementTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: width,
      child: Column(
        children: [
          Icon(icon, size: 32, color: colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
