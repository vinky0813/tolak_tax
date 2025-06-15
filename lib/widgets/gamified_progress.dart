import 'package:flutter/material.dart';

class GamifiedProgress extends StatefulWidget {
  final String label;
  final double budget;
  final double spent;

  const GamifiedProgress({
    super.key,
    required this.label,
    required this.budget,
    required this.spent,
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

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
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
          Text(
            'RM${remaining.toStringAsFixed(2)} away from your "${widget.label}" budget goal!',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$_daysLeft days left until reset',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: colorScheme.primary.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
