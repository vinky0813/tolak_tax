import 'package:flutter/material.dart';

class Achievement {
  final IconData icon;
  final String title;
  final String subtitle;
  final double currentProgress;
  final double goal;

  Achievement({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.currentProgress,
    required this.goal,
  });

  bool get isCompleted => currentProgress >= goal;

  double get progressPercent => (currentProgress / goal).clamp(0.0, 1.0);
}