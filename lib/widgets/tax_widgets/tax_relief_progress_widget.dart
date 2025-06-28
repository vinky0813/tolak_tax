import 'package:flutter/material.dart';

class TaxReliefProgressWidget extends StatelessWidget {
  final String taxClass;
  final String description;
  final double spentAmount;
  final double reliefLimit;
  final Color color;
  final VoidCallback? onTap;

  const TaxReliefProgressWidget({
    super.key,
    required this.taxClass,
    required this.description,
    required this.spentAmount,
    required this.reliefLimit,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculate progress values
    final progress =
        reliefLimit > 0 ? (spentAmount / reliefLimit).clamp(0.0, 1.0) : 0.0;
    final remaining = (reliefLimit - spentAmount).clamp(0, reliefLimit);
    final isOverLimit = spentAmount > reliefLimit;

    // Select appropriate icon for tax class
    IconData getIconForTaxClass(String taxClass) {
      switch (taxClass.toUpperCase()) {
        case 'B':
          return Icons.library_books; // Books/Education
        case 'C':
          return Icons.computer; // Computer/Technology
        case 'D':
          return Icons.medical_services; // Medical
        case 'E':
          return Icons.fitness_center; // Lifestyle/Sports
        case 'F':
          return Icons.safety_check; // Safety/Equipment
        case 'G':
          return Icons.home; // Home/Property
        case 'H':
          return Icons.elderly; // Parents/Family
        case 'I':
          return Icons.school; // Education/Children
        case 'J':
          return Icons.savings; // Savings/Investment
        case 'K':
          return Icons.health_and_safety; // Insurance/Health
        default:
          return Icons.receipt; // Default
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap ??
            () {
              // Show details dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('$taxClass - Tax Relief Details'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Spent:', style: theme.textTheme.bodyMedium),
                          Text('RM ${spentAmount.toStringAsFixed(2)}',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Limit:', style: theme.textTheme.bodyMedium),
                          Text('RM ${reliefLimit.toStringAsFixed(2)}',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(isOverLimit ? 'Over limit:' : 'Remaining:',
                              style: theme.textTheme.bodyMedium),
                          Text(
                              'RM ${(isOverLimit ? spentAmount - reliefLimit : remaining).toStringAsFixed(2)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    isOverLimit ? Colors.orange : Colors.green,
                              )),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Progress:', style: theme.textTheme.bodyMedium),
                          Text('${(progress * 100).toStringAsFixed(1)}%',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with tax class and amounts
            Row(
              children: [
                // Tax class badge
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        getIconForTaxClass(taxClass),
                        color: color,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        taxClass,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Description
                Expanded(
                  child: Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Amount info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'RM ${spentAmount.toStringAsFixed(2)}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isOverLimit ? Colors.orange.shade700 : color,
                      ),
                    ),
                    Text(
                      'of RM ${reliefLimit.toStringAsFixed(0)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOverLimit
                          ? Colors.orange.shade600
                          : progress >= 0.8
                              ? Colors.green.shade600
                              : color,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(progress * 100).toStringAsFixed(1)}% utilized',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isOverLimit ? Colors.orange.shade700 : color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (reliefLimit > spentAmount)
                      Text(
                        'RM ${(reliefLimit - spentAmount).toStringAsFixed(2)} remaining',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    else if (isOverLimit)
                      Text(
                        'RM ${(spentAmount - reliefLimit).toStringAsFixed(2)} over limit',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
