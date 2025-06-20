import 'package:flutter/material.dart';
import 'package:tolak_tax/models/achievement_model.dart';

class AchievementProgressTile extends StatelessWidget {
  final UiAchievement achievement;

  const AchievementProgressTile({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isCompleted = achievement.isCompleted;

    return Opacity(
      opacity: isCompleted ? 0.65 : 1.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(achievement.icon, color: colorScheme.primary, size: 36),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          achievement.subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Show a checkmark only when completed
                  if (isCompleted)
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 30)
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.emoji_events_outlined,
                            color: Colors.amber[800],
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '+${achievement.pointsReward}',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.amber[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
              const SizedBox(height: 16),
              // The Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: achievement.progressPercent,
                  minHeight: 12,
                  backgroundColor: colorScheme.surfaceVariant,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colorScheme.primary),
                ),
              ),
              const SizedBox(height: 6),
              // Progress Text (e.g., "750 / 1000")
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${achievement.currentProgress.toInt()} / ${achievement.goal.toInt()}',
                  style: theme.textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
