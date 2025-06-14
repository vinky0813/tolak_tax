import 'package:flutter/material.dart';
import 'package:tolak_tax/widgets/goal_marker.dart';

class AchievementProgressBar extends StatefulWidget {
  final int totalPoints;
  const AchievementProgressBar({super.key, required this.totalPoints});

  @override
  State<AchievementProgressBar> createState() => _AchievementProgressBarState();
}

class _AchievementProgressBarState extends State<AchievementProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  final int goal1 = 700;
  final int goal2 = 1000;
  final int goal3 = 1500;

  @override
  void initState() {
    super.initState();

    double endProgress = (widget.totalPoints / goal3).clamp(0.0, 1.0);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: endProgress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AchievementProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.totalPoints != oldWidget.totalPoints) {
      double endProgress = (widget.totalPoints / goal3).clamp(0.0, 1.0);
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: endProgress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getTrophyColor(double progress) {
    if (progress >= 1.0) return Colors.amber[700]!;
    if (progress >= (goal2 / goal3)) return Colors.grey;
    if (progress >= (goal1 / goal3)) return Colors.brown[300]!;
    return Colors.brown[600]!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          final currentProgress = _progressAnimation.value;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                size: 48,
                color: _getTrophyColor(currentProgress),
              ),
              const SizedBox(height: 8),
              Text(
                'Achievement Points',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.totalPoints}',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            height: 20,
                            width: constraints.maxWidth * currentProgress,
                            decoration: BoxDecoration(
                              color: colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        height: 40,
                        child: Stack(
                          children: [
                            GoalMarker(
                              context: context,
                              label: 'Bronze',
                              currentProgress: currentProgress,
                              goalValue: goal1,
                              totalValue: goal3,
                            ),
                            GoalMarker(
                              context: context,
                              label: 'Silver',
                              currentProgress: currentProgress,
                              goalValue: goal2,
                              totalValue: goal3,
                            ),
                            GoalMarker(
                              context: context,
                              label: 'Gold',
                              currentProgress: currentProgress,
                              goalValue: goal3,
                              totalValue: goal3,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}