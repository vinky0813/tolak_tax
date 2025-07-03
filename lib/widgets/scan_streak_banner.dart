import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

enum ScanStreakStatus {
  continued,
  reset,
}

class ScanStreakBanner {
  static void show(
      BuildContext context,
      int streakCount, {
        required ScanStreakStatus status,
      }) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    late final Color bannerBackgroundColorStart;
    late final Color bannerBackgroundColorEnd;
    late final Color bannerTextColor;
    late final String title;
    late final String message;
    late final Icon icon;

    if (status == ScanStreakStatus.continued) {
      bannerBackgroundColorStart = Colors.green.shade700;
      bannerBackgroundColorEnd = Colors.lightGreen.shade600;
      bannerTextColor = colorScheme.onPrimary;
      title = "Daily Scan Streak";
      message =
      "You're on a $streakCount-day scanning streak! 🔥\nYou've earned 40 points for staying consistent!";
      icon = Icon(
        Icons.local_fire_department,
        size: 32.0,
        color: bannerTextColor,
      );
    } else {
      bannerBackgroundColorStart = Colors.red.shade700;
      bannerBackgroundColorEnd = Colors.deepOrange.shade600;
      bannerTextColor = colorScheme.onError;
      title = "Streak Reset";
      message =
      "You missed a day! Your scan streak has been reset to 1. 😢";
      icon = Icon(
        Icons.warning_amber_rounded,
        size: 32.0,
        color: bannerTextColor,
      );
    }

    Flushbar(
      titleText: Text(
        title,
        style: textTheme.titleLarge?.copyWith(
          color: bannerTextColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      messageText: Text(
        message,
        style: textTheme.bodyMedium?.copyWith(
          color: bannerTextColor.withOpacity(0.95),
        ),
      ),
      icon: icon,
      duration: const Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.TOP,
      animationDuration: const Duration(milliseconds: 600),
      isDismissible: true,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(12.0),
      backgroundGradient: LinearGradient(
        colors: [bannerBackgroundColorStart, bannerBackgroundColorEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadows: [
        BoxShadow(
          color: theme.shadowColor.withOpacity(0.3),
          offset: const Offset(0, 5),
          blurRadius: 8,
        ),
      ],
    ).show(context);
  }
}
