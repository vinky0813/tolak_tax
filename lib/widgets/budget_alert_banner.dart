import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class BudgetAlertBanner {
  static void show(BuildContext context, String categoryName) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final Color bannerBackgroundColorStart = colorScheme.error;
    final Color bannerBackgroundColorEnd = Colors.deepOrange.shade600;
    final Color bannerTextColor = colorScheme.onError;

    Flushbar(
      titleText: Text(
        "Budget Alert",
        style: textTheme.titleLarge?.copyWith(
          color: bannerTextColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      messageText: Text(
        "You've gone over your budget for the '$categoryName' category.",
        style: textTheme.bodyMedium?.copyWith(
          color: bannerTextColor.withOpacity(0.9),
        ),
      ),

      icon: Icon(
        Icons.outbond_outlined,
        size: 32.0,
        color: bannerTextColor,
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