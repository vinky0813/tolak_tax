import 'package:flutter/material.dart';

class GamifiedProgress extends StatefulWidget {
  final String label;
  final IconData icon;
  final double budget;
  final double spent;
  final Color color;
  final VoidCallback onTap;

  const GamifiedProgress({
    super.key,
    required this.label,
    required this.icon,
    required this.budget,
    required this.spent,
    required this.color,
    required this.onTap,
  });

  @override
  State<GamifiedProgress> createState() => _GamifiedProgressState();
}

class _GamifiedProgressState extends State<GamifiedProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late int _daysLeft;

  @override
  void initState() {
    super.initState();

    _daysLeft = _calculateDaysLeft();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: (widget.spent / widget.budget).clamp(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant GamifiedProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    final targetProgress = (widget.spent / widget.budget).clamp(0.0, 1.0);
    _daysLeft = _calculateDaysLeft();

    _progressAnimation = Tween<double>(
      begin: _progressAnimation.value,
      end: targetProgress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward(from: 0);
  }

  int _calculateDaysLeft() {
    final today = DateTime.now();
    final nextReset = DateTime(today.year, today.month + 1, 1);
    return nextReset.difference(today).inDays;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final remaining = (widget.budget - widget.spent).clamp(0, widget.budget);
    final progressValue =
        (widget.budget > 0) ? (widget.spent / widget.budget) : 0.0;
    const Color textColor = Colors.white;
    final Color faintTextColor = Colors.white.withOpacity(0.8);

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        child: Stack(children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              widget.icon,
              size: 120,
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.color.withOpacity(0.9),
                  widget.color,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      widget.icon,
                      color: textColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(widget.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        )),
                  ],
                ),
                const Spacer(),
                Text(
                  'RM${remaining.toStringAsFixed(2)} left to spend',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Left to spend $_daysLeft days left until reset',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: faintTextColor),
                ),
                const SizedBox(height: 10),
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    final indicatorColor = progressValue > 1.0
                        ? Colors.red.shade400
                        : Colors.white;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _progressAnimation.value,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation(indicatorColor),
                        minHeight: 8,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
