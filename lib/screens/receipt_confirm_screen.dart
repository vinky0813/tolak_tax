import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/page_status_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/reciept_image_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/merchant_info_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/transaction_details_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/line_items_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/discounts_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/additional_info_card.dart';

class ReceiptConfirmScreen extends StatefulWidget {
  final Receipt? receiptData;
  final String receiptImagePath;

  const ReceiptConfirmScreen(
      {Key? key, required this.receiptData, required this.receiptImagePath})
      : super(key: key);

  @override
  State<ReceiptConfirmScreen> createState() => ReceiptConfirmScreenState();
}

class ReceiptConfirmScreenState extends State<ReceiptConfirmScreen> {
  bool isEditing = false;
  late TextEditingController merchantNameController;
  late TextEditingController merchantAddressController;
  late TextEditingController dateController;
  late TextEditingController totalAmountController;
  late TextEditingController taxAmountController;
  late TextEditingController subtotalController;
  late TextEditingController currencyController;
  late TextEditingController paymentMethodController;
  late TextEditingController expenseCategoryController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    merchantNameController =
        TextEditingController(text: widget.receiptData?.merchantName ?? '');
    merchantAddressController =
        TextEditingController(text: widget.receiptData?.merchantAddress ?? '');

    // Handle date formatting - convert from ISO 8601 to display format if needed
    String dateText = '';
    if (widget.receiptData?.transactionDatetime != null) {
      try {
        final DateTime parsedDate =
            DateTime.parse(widget.receiptData!.transactionDatetime);
        dateText = parsedDate.toString().split(' ')[0]; // YYYY-MM-DD format
      } catch (e) {
        dateText = widget.receiptData!.transactionDatetime;
      }
    }
    dateController = TextEditingController(text: dateText);

    totalAmountController = TextEditingController(
        text: widget.receiptData?.totalAmount.toString() ?? '');
    taxAmountController = TextEditingController(
        text: widget.receiptData?.taxAmount?.toString() ?? '');
    subtotalController = TextEditingController(
        text: widget.receiptData?.subtotal?.toString() ?? '');
    currencyController =
        TextEditingController(text: widget.receiptData?.currencyCode ?? 'USD');
    paymentMethodController =
        TextEditingController(text: widget.receiptData?.paymentMethod ?? '');
    expenseCategoryController =
        TextEditingController(text: widget.receiptData?.expenseCategory ?? '');
  }

  @override
  void dispose() {
    merchantNameController.dispose();
    merchantAddressController.dispose();
    dateController.dispose();
    totalAmountController.dispose();
    taxAmountController.dispose();
    subtotalController.dispose();
    currencyController.dispose();
    paymentMethodController.dispose();
    expenseCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print('receiptData: ${widget.receiptData?.toMap()}');

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Receipt Details'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
            icon: Icon(
              isEditing ? Icons.visibility : Icons.edit,
              color: theme.primaryColor,
            ),
            tooltip: isEditing ? 'View Mode' : 'Edit Mode',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Indicator
            PageStatusCard(isEditing),
            const SizedBox(height: 16),

            // Receipt Image Card
            ReceiptImageCard(
              receiptImagePath: widget.receiptImagePath,
            ),

            const SizedBox(height: 16), // Merchant Information Card

            MerchantInfoCard(
              merchantNameController: merchantNameController,
              merchantAddressController: merchantAddressController,
              isEditing: isEditing,
            ),
            const SizedBox(height: 16),

            // Transaction Details Card
            TransactionDetailsCard(
              dateController: dateController,
              paymentMethodController: paymentMethodController,
              currencyController: currencyController,
              isEditing: isEditing,
            ),
            const SizedBox(height: 16),

            // Line Items Card (if available)
            if (widget.receiptData?.lineItems.isNotEmpty == true)
              LineItemsCard(
                lineItems: widget.receiptData!.lineItems,
              ),
            const SizedBox(height: 16),

            // Discounts Card (if available)
            if (widget.receiptData?.overallDiscounts?.isNotEmpty == true)
              DiscountsCard(
                discounts: widget.receiptData!.overallDiscounts!,
              ),
            const SizedBox(height: 16),

            // Additional Information Card
            AdditionalInfoCard(
              expenseCategoryController: expenseCategoryController,
              isEditing: isEditing,
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _saveReceipt,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Receipt'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _saveReceipt() {
    // Validate required fields
    if (merchantNameController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter merchant name');
      return;
    }

    if (dateController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter date');
      return;
    }

    if (totalAmountController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter total amount');
      return;
    }

    // Parse and validate amounts
    double? totalAmount;
    double? taxAmount;
    double? subtotal;

    try {
      totalAmount = double.parse(totalAmountController.text.trim());
    } catch (e) {
      _showErrorSnackBar('Please enter a valid total amount');
      return;
    }

    if (taxAmountController.text.trim().isNotEmpty) {
      try {
        taxAmount = double.parse(taxAmountController.text.trim());
      } catch (e) {
        _showErrorSnackBar('Please enter a valid tax amount');
        return;
      }
    }

    if (subtotalController.text.trim().isNotEmpty) {
      try {
        subtotal = double.parse(subtotalController.text.trim());
      } catch (e) {
        _showErrorSnackBar('Please enter a valid subtotal');
        return;
      }
    }

    // Create receipt data
    // Format date to ISO 8601 string
    String transactionDatetime;
    try {
      final DateTime parsedDate = DateTime.parse(dateController.text.trim());
      transactionDatetime = parsedDate.toIso8601String();
    } catch (e) {
      // If parsing fails, assume it's already in the correct format or use current time
      transactionDatetime = dateController.text.trim().isNotEmpty
          ? dateController.text.trim()
          : DateTime.now().toIso8601String();
    }

    final receiptData = Receipt(
      merchantName: merchantNameController.text.trim(),
      merchantAddress: merchantAddressController.text.trim().isNotEmpty
          ? merchantAddressController.text.trim()
          : null,
      transactionDatetime: transactionDatetime,
      totalAmount: totalAmount,
      taxAmount: taxAmount,
      subtotal: subtotal,
      currencyCode: currencyController.text.trim().isNotEmpty
          ? currencyController.text.trim()
          : null,
      paymentMethod: paymentMethodController.text.trim().isNotEmpty
          ? paymentMethodController.text.trim()
          : null,
      expenseCategory: expenseCategoryController.text.trim().isNotEmpty
          ? expenseCategoryController.text.trim()
          : null,
      lineItems: widget.receiptData?.lineItems ?? [],
      overallDiscounts: widget.receiptData?.overallDiscounts ?? [],
    );

    // TODO: Save to database/storage
    // For now, just show success and navigate back
    _showSuccessSnackBar('Receipt saved successfully!');

    // Navigate back with the receipt data
    Navigator.pop(context, receiptData);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
