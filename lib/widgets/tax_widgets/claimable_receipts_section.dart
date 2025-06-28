import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/widgets/section_container.dart';

class ClaimableReceiptsSection extends StatelessWidget {
  final List<Receipt> receipts;

  const ClaimableReceiptsSection({
    super.key,
    required this.receipts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final claimableReceipts = receipts
        .where((receipt) =>
            receipt.taxSummary != null && receipt.taxSummary!.totalTaxSaved > 0)
        .toList();

    // Sort by tax saved (highest first)
    claimableReceipts.sort((a, b) =>
        b.taxSummary!.totalTaxSaved.compareTo(a.taxSummary!.totalTaxSaved));

    return SectionContainer(
      title: 'Claimable Receipts (${claimableReceipts.length})',
      child: claimableReceipts.isEmpty
          ? Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'No claimable receipts found',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    'Add receipts with tax-claimable items to see them here',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                ...claimableReceipts.take(10).map((receipt) {
                  final taxSummary = receipt.taxSummary!;
                  final date = DateTime.parse(receipt.transactionDatetime);
                  final formattedDate = DateFormat('MMM dd, yyyy').format(date);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.store,
                            color: Colors.green.shade700,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                receipt.merchantName,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formattedDate,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${taxSummary.taxableItemsCount} claimable items • RM ${receipt.totalAmount.toStringAsFixed(2)} total',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.green.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'RM ${taxSummary.totalTaxSaved.toStringAsFixed(2)}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'tax saved',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.green.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
