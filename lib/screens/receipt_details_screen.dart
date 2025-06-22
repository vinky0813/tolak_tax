import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/utils/category_helper.dart';
import 'package:tolak_tax/widgets/cached_network_image.dart';
import 'package:tolak_tax/widgets/receipt_item.dart';
import 'package:tolak_tax/widgets/section_container.dart';

class ReceiptDetailsScreen extends StatelessWidget {
  final Receipt receipt;

  const ReceiptDetailsScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                          value: DateFormat.yMMMd().format(
                              DateTime.parse(receipt.transactionDatetime))),
                      ReceiptItem(
                          icon: Icons.access_time,
                          label: "Time",
                          value: DateFormat.jm().format(
                              DateTime.parse(receipt.transactionDatetime))),
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
                      const SizedBox(
                        height: 12,
                      ),
                      if (receipt.lineItems!.isNotEmpty)
                        SectionContainer(
                          title: 'Items',
                          child: Column(
                            children: receipt.lineItems!.map((item) {
                              final price =
                                  'RM ${item.totalPrice.toStringAsFixed(2)}';
                              return ReceiptItem(
                                icon: Icons.shopping_cart,
                                label: '${item.description} x${item.quantity}',
                                value: price,
                              );
                            }).toList(),
                          ),
                        ),
                      const SizedBox(
                        height: 12,
                      ),
                      SectionContainer(
                        title: 'Summary',
                        child: Column(
                          children: [
                            if (receipt.subtotal != null)
                              ReceiptItem(
                                  icon: Icons.receipt_long,
                                  label: "Subtotal",
                                  value:
                                      'RM ${receipt.subtotal?.toStringAsFixed(2)}'),
                            if (receipt.taxAmount != null)
                              ReceiptItem(
                                  icon: Icons.receipt,
                                  label: "Tax",
                                  value:
                                      'RM ${receipt.taxAmount?.toStringAsFixed(2)}'),
                            if (receipt.overallDiscounts != null &&
                                receipt.overallDiscounts!.isNotEmpty)
                              ...receipt.overallDiscounts!.map((discount) =>
                                  ReceiptItem(
                                      icon: Icons.discount,
                                      label: discount.description,
                                      value:
                                          '-RM ${discount.amount.toStringAsFixed(2)}')),
                            const Divider(height: 24),
                            ReceiptItem(
                                icon: Icons.attach_money,
                                label: "Total",
                                value:
                                    'RM ${receipt.totalAmount.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Divider(color: colorScheme.primary),
                      const SizedBox(height: 8),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.black,
                                insetPadding: EdgeInsets.zero,
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: InteractiveViewer(
                                    child: CachedNetworkImage(
                                      url: receipt.imageUrl!,
                                      fit: BoxFit.contain,
                                      placeholder: Container(
                                        color: Colors.black,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.white),
                                        ),
                                      ),
                                      errorWidget: Container(
                                        color: Colors.black,
                                        child: const Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(Icons.broken_image,
                                                  color: Colors.white,
                                                  size: 48),
                                              SizedBox(height: 8),
                                              Text(
                                                'Image not available',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: receipt.imageUrl != ''
                                ? CachedNetworkImage(
                                    url: receipt.imageUrl!,
                                    fit: BoxFit.cover,
                                    placeholder: Container(
                                      height: 180,
                                      width: double.infinity,
                                      color: Colors.grey.shade100,
                                      child: const Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                    errorWidget: Container(
                                      height: 180,
                                      width: double.infinity,
                                      color: Colors.grey.shade200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.broken_image,
                                              size: 48,
                                              color: Colors.grey.shade500),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Image not available',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Colors.grey.shade600,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 180,
                                    width: double.infinity,
                                    color: Colors.grey.shade200,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.broken_image,
                                            size: 48,
                                            color: Colors.grey.shade500),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Image not available',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
