import 'dart:io';
import 'package:flutter/material.dart';

class ReceiptConfirmScreen extends StatefulWidget {
  final Map<String, dynamic> receiptData;
  final String receiptImagePath;

  const ReceiptConfirmScreen(
      {Key? key, required this.receiptData, required this.receiptImagePath})
      : super(key: key);

  @override
  State<ReceiptConfirmScreen> createState() => _ReceiptConfirmScreenState();
}

class _ReceiptConfirmScreenState extends State<ReceiptConfirmScreen> {
  late TextEditingController storeNameController;
  late TextEditingController dateController;
  late TextEditingController totalAmountController;
  late TextEditingController taxAmountController;

  @override
  void initState() {
    super.initState();
    storeNameController =
        TextEditingController(text: widget.receiptData?['storeName'] ?? '');
    dateController =
        TextEditingController(text: widget.receiptData?['date'] ?? '');
    totalAmountController = TextEditingController(
        text: widget.receiptData?['totalAmount']?.toString() ?? '');
    taxAmountController = TextEditingController(
        text: widget.receiptData?['taxAmount']?.toString() ?? '');
  }

  @override
  void dispose() {
    storeNameController.dispose();
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
            const SizedBox(height: 20),

            // Store Name Field
            TextFormField(
              controller: storeNameController,
              decoration: const InputDecoration(
                labelText: 'Store Name',
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
    if (storeNameController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter store name');
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
    }

    // Create receipt data
    final receiptData = {
      'storeName': storeNameController.text.trim(),
      'date': dateController.text.trim(),
      'totalAmount': totalAmount,
      'taxAmount': taxAmount,
      'imagePath': widget.receiptImagePath,
      'createdAt': DateTime.now().toIso8601String(),
    };

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
