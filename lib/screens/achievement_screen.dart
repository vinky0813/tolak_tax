import 'package:flutter/material.dart';
import 'package:tolak_tax/models/achievement_model.dart';
import 'package:tolak_tax/widgets/achievement_progress_bar.dart';
import 'package:tolak_tax/widgets/achievement_progress_tile.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    List<Achievement> achievements = [
      Achievement(
        icon: Icons.savings_outlined,
        title: 'Savvy Saver',
        subtitle: 'Reach RM 1,000 in total savings',
        currentProgress: 855,
        goal: 1000,
        pointsReward: 50,
      ),
      Achievement(
        icon: Icons.local_fire_department,
        title: 'On a Roll!',
        subtitle: 'Maintain a 10-day scanning streak',
        currentProgress: 12,
        goal: 10,
        pointsReward: 100,
      ),
      Achievement(
        icon: Icons.emoji_events_outlined,
        title: 'Golden Achiever',
        subtitle: 'Reach the Gold rank with 1,500 points',
        currentProgress: 1250,
        goal: 1500,
        pointsReward: 250,
      ),
      Achievement(
        icon: Icons.checklist_rtl_outlined,
        title: 'Task Master',
        subtitle: 'Complete 50 daily tasks',
        currentProgress: 23,
        goal: 50,
        pointsReward: 75,
      ),
    ];

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 250,
              backgroundColor: colorScheme.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  alignment: Alignment.center,

                  child: const AchievementProgressBar(totalPoints: 1250),
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      decoration: BoxDecoration(
                        color: colorScheme.background,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Text(
                        'Your Achievements',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground,
                        ),
                      ),
                    );
                  }
                  final achievement = achievements[index - 1];
                  return Container(
                    color: colorScheme.background,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AchievementProgressTile(achievement: achievement),
                  );
                },
                childCount: achievements.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
