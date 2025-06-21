import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:tolak_tax/models/achievement_model.dart';

class AchievementBanner {
  static void show(BuildContext context, AchievementDefinition achievement) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final Color bannerBackgroundColorStart = colorScheme.secondary; // Asparagus
    final Color bannerBackgroundColorEnd = colorScheme.tertiary;     // Yellow Green
    final Color bannerTextColor = colorScheme.onSecondary;           // White
    final Color bannerIconColor = Colors.white; // A bright white icon stands out best

    Flushbar(
      titleText: Text(
        achievement.title,
        style: textTheme.titleLarge?.copyWith(
          color: bannerTextColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      messageText: Text(
        achievement.subtitle,
        style: textTheme.bodyMedium?.copyWith(
          color: bannerTextColor.withOpacity(0.9),
        ),
      ),

      icon: Icon(
        achievement.icon,
        size: 32.0,
        color: bannerIconColor,
      ),

      mainButton: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "+${achievement.pointsReward}",
              style: textTheme.headlineSmall?.copyWith(
                color: bannerTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Points",
              style: textTheme.labelSmall?.copyWith(
                color: bannerTextColor.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),

      duration: const Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.TOP,
      animationDuration: const Duration(milliseconds: 600),
      isDismissible: true,

      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(12.0),
      backgroundGradient: LinearGradient(
        colors: [
          bannerBackgroundColorStart,
          bannerBackgroundColorEnd,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadows: [
        BoxShadow(
          color: theme.shadowColor.withOpacity(0.4),
          offset: const Offset(0, 5),
          blurRadius: 10,
        ),
      ],
    ).show(context);
  }
}