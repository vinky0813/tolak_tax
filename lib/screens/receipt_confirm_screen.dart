import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/widgets/back_button.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/page_status_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/reciept_image_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/merchant_info_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/transaction_details_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/financial_details_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/line_items_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/discounts_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/additional_info_card.dart';
import 'package:tolak_tax/services/api_service.dart';

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
  late List<TextEditingController> lineItemDescriptionControllers;
  late List<TextEditingController> lineItemQuantityControllers;
  late List<TextEditingController> lineItemPriceControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    merchantNameController =
        TextEditingController(text: widget.receiptData?.merchant_name ?? '');
    merchantAddressController =
        TextEditingController(text: widget.receiptData?.merchant_address ?? '');

    // Handle date formatting - convert from ISO 8601 to display format if needed
    String dateText = '';
    if (widget.receiptData?.transaction_datetime != null) {
      try {
        final DateTime parsedDate =
            DateTime.parse(widget.receiptData!.transaction_datetime);
        dateText = parsedDate.toString().split(' ')[0]; // YYYY-MM-DD format
      } catch (e) {
        dateText = widget.receiptData!.transaction_datetime;
      }
    }
    dateController = TextEditingController(text: dateText);

    totalAmountController = TextEditingController(
        text: widget.receiptData?.total_amount.toString() ?? '');
    taxAmountController = TextEditingController(
        text: widget.receiptData?.tax_amount?.toString() ?? '');
    subtotalController = TextEditingController(
        text: widget.receiptData?.subtotal?.toString() ?? '');
    currencyController =
        TextEditingController(text: widget.receiptData?.currency_code ?? 'USD');
    paymentMethodController =
        TextEditingController(text: widget.receiptData?.payment_method ?? '');
    expenseCategoryController =
        TextEditingController(text: widget.receiptData?.expense_category ?? '');

    lineItemDescriptionControllers = [];
    lineItemQuantityControllers = [];
    lineItemPriceControllers = [];

    if (widget.receiptData?.line_items != null) {
      for (var item in widget.receiptData!.line_items) {
        lineItemDescriptionControllers.add(
          TextEditingController(text: item.description),
        );
        lineItemQuantityControllers.add(
          TextEditingController(text: item.quantity.toString()),
        );
        lineItemPriceControllers.add(
          TextEditingController(
              text: item.original_unit_price.toStringAsFixed(2)),
        );
      }
    }
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
    for (var controller in lineItemDescriptionControllers) {
      controller.dispose();
    }
    for (var controller in lineItemQuantityControllers) {
      controller.dispose();
    }
    for (var controller in lineItemPriceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<bool?> addReceipt(BuildContext context, ApiService apiService,
      String imagePath, Receipt receiptData) async {
    try {
      final String? idToken = await apiService.getIdToken(context);

      if (idToken == null || idToken.isEmpty) {
        print('Error: Could not retrieve ID token.');
        return null;
      }

      await apiService.uploadReceipt(idToken, imagePath, receiptData.toMap());
      return true;
    } catch (e) {
      print('An error occurred: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    print('receiptData: ${widget.receiptData?.toMap()}');

    return Scaffold(
        backgroundColor: colorScheme.primary,
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
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
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: true,
              pinned: true,
              expandedHeight: 120,
              backgroundColor: theme.primaryColor,
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  icon: Icon(
                    isEditing ? Icons.visibility : Icons.edit,
                  ),
                  tooltip: isEditing ? 'View Mode' : 'Edit Mode',
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Receipt Details',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
                titlePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              foregroundColor: colorScheme.onPrimary,
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 16), // Transaction Details Card

                    TransactionDetailsCard(
                      dateController: dateController,
                      paymentMethodController: paymentMethodController,
                      currencyController: currencyController,
                      isEditing: isEditing,
                    ),
                    const SizedBox(height: 16),

                    const SizedBox(height: 16),

                    // Line Items Card (if available)
                    if (widget.receiptData?.line_items.isNotEmpty == true)
                      LineItemsCard(
                        lineItems: widget.receiptData!.line_items,
                        isEditing: isEditing,
                        descriptionControllers: lineItemDescriptionControllers,
                        quantityControllers: lineItemQuantityControllers,
                        priceControllers: lineItemPriceControllers,
                      ),
                    const SizedBox(height: 16),

                    FinancialDetailsCard(
                      subtotalController: subtotalController,
                      taxAmountController: taxAmountController,
                      totalAmountController: totalAmountController,
                      isEditing: isEditing,
                    ),

                    // Discounts Card (if available)
                    if (widget.receiptData?.overall_discounts?.isNotEmpty ==
                        true)
                      DiscountsCard(
                        discounts: widget.receiptData!.overall_discounts!,
                      ),
                    const SizedBox(height: 16),

                    // Additional Information Card
                    AdditionalInfoCard(
                      expenseCategoryController: expenseCategoryController,
                      isEditing: isEditing,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            )
          ],
        ));
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

    final List<LineItem> updatedLineItems = [];
    for (int i = 0; i < lineItemDescriptionControllers.length; i++) {
      final description = lineItemDescriptionControllers[i].text;
      final quantity =
          double.tryParse(lineItemQuantityControllers[i].text) ?? 1.0;
      final price = double.tryParse(lineItemPriceControllers[i].text) ?? 0.0;

      updatedLineItems.add(LineItem(
        description: description,
        quantity: quantity,
        original_unit_price: price,
        total_price: quantity * price,
      ));
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
      merchant_name: merchantNameController.text.trim(),
      merchant_address: merchantAddressController.text.trim().isNotEmpty
          ? merchantAddressController.text.trim()
          : null,
      transaction_datetime: transactionDatetime,
      total_amount: totalAmount,
      tax_amount: taxAmount,
      subtotal: subtotal,
      currency_code: currencyController.text.trim().isNotEmpty
          ? currencyController.text.trim()
          : null,
      payment_method: paymentMethodController.text.trim().isNotEmpty
          ? paymentMethodController.text.trim()
          : null,
      expense_category: expenseCategoryController.text.trim().isNotEmpty
          ? expenseCategoryController.text.trim()
          : null,
      line_items: widget.receiptData?.line_items ?? [],
      overall_discounts: widget.receiptData?.overall_discounts ?? [],
    );

    final ApiService apiService = ApiService();
    addReceipt(context, apiService, widget.receiptImagePath, receiptData)
        .then((success) {
      if (success == true) {
        _showSuccessSnackBar('Receipt saved successfully!');
      } else {
        _showErrorSnackBar('Failed to save receipt. Please try again.');
      }
    }).catchError((error) {
      _showErrorSnackBar('An error occurred while saving the receipt: $error');
    });
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
