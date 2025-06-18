import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';

class ReceiptConfirmScreen extends StatefulWidget {
  final Receipt? receiptData;
  final String receiptImagePath;

  const ReceiptConfirmScreen(
      {Key? key, required this.receiptData, required this.receiptImagePath})
      : super(key: key);

  @override
  State<ReceiptConfirmScreen> createState() => _ReceiptConfirmScreenState();
}

class _ReceiptConfirmScreenState extends State<ReceiptConfirmScreen> {
  late TextEditingController merchantNameController;
  late TextEditingController dateController;
  late TextEditingController totalAmountController;
  late TextEditingController taxAmountController;
  @override
  void initState() {
    super.initState();
    merchantNameController =
        TextEditingController(text: widget.receiptData?.merchantName ?? '');

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
  }

  @override
  void dispose() {
    merchantNameController.dispose();
    dateController.dispose();
    totalAmountController.dispose();
    taxAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("imagePath: ${widget.receiptImagePath}");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Receipt Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.file(
                File(widget.receiptImagePath),
                fit: BoxFit.contain,
              ),
            ),
            const Text(
              'Please verify the receipt details below:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20), // Store Name Field
            TextFormField(
              controller: merchantNameController,
              decoration: const InputDecoration(
                labelText: 'Merchant Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.store),
              ),
            ),
            const SizedBox(height: 16),

            // Date Field
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
                hintText: 'YYYY-MM-DD',
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  dateController.text = picked.toString().split(' ')[0];
                }
              },
            ),
            const SizedBox(height: 16),

            // Total Amount Field
            TextFormField(
              controller: totalAmountController,
              decoration: const InputDecoration(
                labelText: 'Total Amount',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                prefixText: '\$ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),

            // Tax Amount Field
            TextFormField(
              controller: taxAmountController,
              decoration: const InputDecoration(
                labelText: 'Tax Amount',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.receipt),
                prefixText: '\$ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveReceipt,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save Receipt'),
                  ),
                ),
              ],
            ),
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
    } // Create receipt data
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
      transactionDatetime: transactionDatetime,
      totalAmount: totalAmount,
      taxAmount: taxAmount,
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
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
