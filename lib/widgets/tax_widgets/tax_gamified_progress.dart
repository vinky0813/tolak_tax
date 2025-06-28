import 'package:flutter/material.dart';

class TaxGamifiedProgress extends StatefulWidget {
  final String label;
  final IconData icon;
  final double budget;
  final double spent;
  final Color color;
  final VoidCallback onTap;
  final String description;

  const TaxGamifiedProgress({
    super.key,
    required this.label,
    required this.icon,
    required this.budget,
    required this.spent,
    required this.color,
    required this.onTap,
    required this.description,
  });

  @override
  State<TaxGamifiedProgress> createState() => _TaxGamifiedProgressState();
}

class _TaxGamifiedProgressState extends State<TaxGamifiedProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

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
  void didUpdateWidget(covariant TaxGamifiedProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    final targetProgress = (widget.spent / widget.budget).clamp(0.0, 1.0);

    _progressAnimation = Tween<double>(
      begin: _progressAnimation.value,
      end: targetProgress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward(from: 0);
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
    final isOverLimit = widget.spent > widget.budget;
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.label,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      widget.icon,
                      color: textColor,
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: faintTextColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                if (isOverLimit) ...[
                  Text(
                    'RM${(widget.spent - widget.budget).toStringAsFixed(2)} over limit',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You\'ve exceeded the relief limit for this class',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: faintTextColor),
                  ),
                ] else ...[
                  Text(
                    'RM${remaining.toStringAsFixed(2)} remaining',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Out of RM${widget.budget.toStringAsFixed(0)} annual limit',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: faintTextColor),
                  ),
                ],
                const SizedBox(height: 10),
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    final indicatorColor = progressValue > 1.0
                        ? Colors.orange.shade300
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
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RM${widget.spent.toStringAsFixed(2)} spent',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: faintTextColor,
                      ),
                    ),
                    Text(
                      '${(progressValue * 100).toStringAsFixed(1)}% utilized',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: faintTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
