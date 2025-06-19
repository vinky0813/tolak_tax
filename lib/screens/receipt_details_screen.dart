import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/utils/category_helper.dart';
import 'package:tolak_tax/widgets/receipt_item.dart';
import 'package:tolak_tax/widgets/section_container.dart';

class ReceiptDetailsScreen extends StatelessWidget {
  final Receipt receipt;

  const ReceiptDetailsScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final formattedDate = DateFormat.yMMMd().format(receipt.transactionDate);
    final formattedTime = DateFormat.jm().format(receipt.transactionDate);

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: SectionContainer(
                  title: 'Receipt Details',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (receipt.merchantAddress != null)
                        ReceiptItem(
                            icon: Icons.location_on,
                            label: "Address",
                            value: receipt.merchantAddress!),
                      ReceiptItem(
                          icon: Icons.calendar_today,
                          label: "Date",
                          value: '$formattedDate at $formattedTime'),
                      if (receipt.expenseCategory != null)
                        ReceiptItem(
                            icon: Icons.category,
                            label: "Category",
                            value: CategoryHelper.getDisplayName(
                                receipt.expenseCategory)),
                      if (receipt.paymentMethod != null)
                        ReceiptItem(
                            icon: Icons.payment,
                            label: "Payment",
                            value: receipt.paymentMethod!),

                      const SizedBox(height: 8),
                      Divider(color: colorScheme.primary),
                      const SizedBox(height: 8),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            receipt.imageUrl!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.grey.shade200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.broken_image,
                                      size: 48, color: Colors.grey.shade500),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Image not available',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 180,
                                width: double.infinity,
                                color: Colors.grey.shade100,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
