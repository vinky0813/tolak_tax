import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/utils/category_colour.dart';

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

    final recentThree = widget.receipts.length > 3
        ? widget.receipts.sublist(widget.receipts.length - 3)
        : widget.receipts;

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
              final categoryColor = getCategoryColor(receipt.category);
              final formattedDate = receipt.date != null
                  ? DateFormat.yMMMd().format(receipt.date)
                  : '';
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 9),
                leading: Icon(
                  Icons.receipt,
                  color: categoryColor,
                ),
                title: Text(
                  receipt.title ?? '',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                  subtitle: Text(
                  formattedDate.toString(),
                  style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  )),
                trailing: Text(
                  'RM ${receipt.amount.toString()}',
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
                  );}
              );
            },
          ),
        ],
      ),
    );
  }
}
