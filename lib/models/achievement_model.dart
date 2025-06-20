import 'package:flutter/material.dart';

enum AchievementType {
  totalSavings,
  scanStreak,
  totalPoints,
  scanCount,
}

class AchievementDefinition {
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final double goal;
  final int pointsReward;
  final AchievementType type;

  AchievementDefinition({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.goal,
    required this.pointsReward,
    required this.type,
  });
}

class AchievementProgress {
  final String achievementId;
  double progress;
  bool isCompleted;

  AchievementProgress({
    required this.achievementId,
    this.progress = 0,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': achievementId,
    'progress': progress,
    'isCompleted': isCompleted,
  };

  factory AchievementProgress.fromJson(Map<String, dynamic> json) => AchievementProgress(
    achievementId: json['id'],
    progress: (json['progress'] as num).toDouble(),
    isCompleted: json['isCompleted'] as bool,
  );
}

class UiAchievement {
  final IconData icon;
  final String title;
  final String subtitle;
  final double goal;
  final int pointsReward;

  final double currentProgress;
  final bool isCompleted;

  UiAchievement({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.goal,
    required this.pointsReward,
    required this.currentProgress,
    required this.isCompleted,
  });

  double get progressPercent =>
      (goal == 0) ? 1.0 : (currentProgress / goal).clamp(0.0, 1.0);
}