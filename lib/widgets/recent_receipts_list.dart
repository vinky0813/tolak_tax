import 'package:flutter/material.dart';
import 'package:tolak_tax/utils/category_colour.dart';

class RecentReceiptsList extends StatefulWidget {
  final List<Map<String, dynamic>> receipts;

  const RecentReceiptsList({super.key, required this.receipts});

  @override
  State<RecentReceiptsList> createState() => _RecentReceiptsListState();
}

class _RecentReceiptsListState extends State<RecentReceiptsList> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              final category = receipt['category'] ?? '';
              final categoryColor = getCategoryColor(category);
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 9),
                leading: Icon(
                  Icons.receipt,
                  color: categoryColor,
                ),
                title: Text(
                  "${receipt['title']}",
                  style: TextStyle(color: categoryColor),
                ),
                subtitle: Text("${receipt['date']}"),
                trailing: Text('RM ${receipt['amount'].toString()}'),
              );
            },
          ),
        ],
      ),
    );
  }
}
