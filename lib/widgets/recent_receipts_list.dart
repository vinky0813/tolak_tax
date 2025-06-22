import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/utils/category_helper.dart';

class RecentReceiptsList extends StatefulWidget {
  final List<Receipt> receipts;

  const RecentReceiptsList({super.key, required this.receipts});

  @override
  State<RecentReceiptsList> createState() => _RecentReceiptsListState();
}

class _RecentReceiptsListState extends State<RecentReceiptsList> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final sortableReceipts = List<Receipt>.from(widget.receipts);

    sortableReceipts.sort((a, b) {
      return DateTime.parse(b.transactionDatetime)
          .compareTo(DateTime.parse(a.transactionDatetime));
    });

    final recentThree = sortableReceipts.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Receipts',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...recentThree.map(
            (receipt) {
              final categoryColor =
                  CategoryHelper.getCategoryColor(receipt.expenseCategory);
              final categoryIcon =
                  CategoryHelper.getIcon(receipt.expenseCategory);
              final formattedDate =
                  DateTime.parse(receipt.transactionDatetime) != null
                      ? DateFormat.yMMMd()
                          .format(DateTime.parse(receipt.transactionDatetime))
                      : '';
              return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 9),
                  leading: Icon(
                    categoryIcon,
                    color: categoryColor,
                  ),
                  title: Text(
                    receipt.merchantName ?? '',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(formattedDate.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      )),
                  trailing: Text(
                    'RM ${receipt.totalAmount.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/receipt-details',
                      arguments: receipt,
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
