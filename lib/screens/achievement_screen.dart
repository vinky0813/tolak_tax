import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tolak_tax/models/achievement_model.dart';
import 'package:tolak_tax/widgets/achievement_progress_bar.dart';
import 'package:tolak_tax/widgets/achievement_progress_tile.dart';
import '../data/achievement_definitions.dart';
import '../services/achievement_service.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<AchievementService>(
      builder: (context, achievementService, child) {
        if (!achievementService.isInitialized) {
          return Scaffold(
            backgroundColor: colorScheme.primary,
            body: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        final List<UiAchievement> uiAchievements =
            allAchievementDefinitions.map((definition) {
          final progressData =
              achievementService.userAchievements[definition.id]!;

          return UiAchievement(
            icon: definition.icon,
            title: definition.title,
            subtitle: definition.subtitle,
            goal: definition.goal,
            pointsReward: definition.pointsReward,
            currentProgress: progressData.progress,
            isCompleted: progressData.isCompleted,
          );
        }).toList();

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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 40),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          AchievementProgressBar(
                              totalPoints: achievementService.totalPoints),
                        ],
                      ),
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
                      final achievement = uiAchievements[index - 1];
                      return Container(
                        color: colorScheme.background,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child:
                            AchievementProgressTile(achievement: achievement),
                      );
                    },
                    childCount:
                        uiAchievements.length + 1, // including the header
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
