import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tolak_tax/models/achievement_model.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/services/achievement_service.dart';
import 'package:tolak_tax/services/budget_service.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/page_status_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/reciept_image_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/merchant_info_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/transaction_details_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/financial_details_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/line_items_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/discounts_card.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/additional_info_card.dart';
import 'package:tolak_tax/services/api_service.dart';
import 'package:tolak_tax/services/receipt_service.dart';

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

  late List<LineItem> _lineItems;
  late List<OverallDiscount> _discounts;

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
  late List<TextEditingController> discountDescriptionControllers;
  late List<TextEditingController> discountAmountControllers;

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

    _lineItems = List.from(widget.receiptData?.lineItems ?? []);
    _discounts = List.from(widget.receiptData?.overallDiscounts ?? []);


    lineItemDescriptionControllers = _lineItems
        .map((item) => TextEditingController(text: item.description))
        .toList();
    lineItemQuantityControllers = _lineItems
        .map((item) => TextEditingController(text: item.quantity.toString()))
        .toList();
    lineItemPriceControllers = _lineItems
        .map((item) =>
        TextEditingController(text: item.originalUnitPrice.toStringAsFixed(2)))
        .toList();

    discountDescriptionControllers = _discounts
        .map((discount) => TextEditingController(text: discount.description))
        .toList();
    discountAmountControllers = _discounts
        .map((discount) => TextEditingController(text: discount.amount.toString()))
        .toList();
    _recalculateTotals();
  }

  void _recalculateTotals() {
    double calculatedSubtotal = 0.0;

    for (int i = 0; i < lineItemDescriptionControllers.length; i++) {
      final quantity = double.tryParse(lineItemQuantityControllers[i].text) ?? 0.0;
      final price = double.tryParse(lineItemPriceControllers[i].text) ?? 0.0;
      calculatedSubtotal += (quantity * price);
    }

    subtotalController.text = calculatedSubtotal.toStringAsFixed(2);

    final tax = double.tryParse(taxAmountController.text) ?? 0.0;
    double finalTotal = calculatedSubtotal + tax;

    for (int i = 0; i < discountAmountControllers.length; i++) {
      final discount = double.tryParse(discountAmountControllers[i].text) ?? 0.0;
      finalTotal -= discount;
    }

    if (finalTotal < 0) {
      finalTotal = 0;
    }
    totalAmountController.text = finalTotal.toStringAsFixed(2);
  }

  void _addLineItem() {
    setState(() {
      final newItem = LineItem(description: '', quantity: 1, originalUnitPrice: 0, totalPrice: 0);
      _lineItems.add(newItem);
      lineItemDescriptionControllers.add(TextEditingController());
      lineItemQuantityControllers.add(TextEditingController(text: '1'));
      lineItemPriceControllers.add(TextEditingController(text: '0.00'));
    });
  }

  void _removeLineItem(int index) {
    setState(() {
      lineItemDescriptionControllers[index].dispose();
      lineItemQuantityControllers[index].dispose();
      lineItemPriceControllers[index].dispose();

      _lineItems.removeAt(index);
      lineItemDescriptionControllers.removeAt(index);
      lineItemQuantityControllers.removeAt(index);
      lineItemPriceControllers.removeAt(index);
    });
  }

  void _addDiscount() {
    setState(() {
      final newDiscount = OverallDiscount(description: '', amount: 0);
      _discounts.add(newDiscount);
      discountDescriptionControllers.add(TextEditingController());
      discountAmountControllers.add(TextEditingController(text: '0.00'));
    });
  }

  void _removeDiscount(int index) {
    setState(() {
      discountDescriptionControllers[index].dispose();
      discountAmountControllers[index].dispose();

      _discounts.removeAt(index);
      discountDescriptionControllers.removeAt(index);
      discountAmountControllers.removeAt(index);
    });
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
    for (var controller in discountDescriptionControllers) {
      controller.dispose();
    }
    for (var controller in discountAmountControllers) {
      controller.dispose();
    }
    discountDescriptionControllers.clear();
    discountAmountControllers.clear();
    lineItemDescriptionControllers.clear();
    lineItemQuantityControllers.clear();
    lineItemPriceControllers.clear();

    taxAmountController.removeListener(_recalculateTotals);

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
                    onPressed: isEditing
                        ? null
                        : () async {
                      final achievementService =
                          context.read<AchievementService?>();
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      try {
                        await achievementService?.updateProgress(
                          type: AchievementType.scanCount,
                          incrementBy: 1,
                        );
                        await achievementService?.processDailyScan();

                        _saveReceipt();
                      } catch (e) {
                        print("An error occurred during save: $e");
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
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

                    if (isEditing) {
                      _recalculateTotals();
                    }

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
                    if (widget.receiptData?.lineItems.isNotEmpty == true)
                      LineItemsCard(
                        isEditing: isEditing,
                        descriptionControllers: lineItemDescriptionControllers,
                        quantityControllers: lineItemQuantityControllers,
                        priceControllers: lineItemPriceControllers,
                        onAddItem: _addLineItem,
                        onRemoveItem: _removeLineItem,
                      ),
                    const SizedBox(height: 16),

                    FinancialDetailsCard(
                      subtotalController: subtotalController,
                      taxAmountController: taxAmountController,
                      totalAmountController: totalAmountController,
                      isEditing: isEditing,
                    ),

                    // Discounts Card (if available)
                    if (isEditing || _discounts.isNotEmpty)
                      DiscountsCard(
                        isEditing: isEditing,
                        descriptionControllers: discountDescriptionControllers,
                        amountControllers: discountAmountControllers,
                        onAddDiscount: _addDiscount,
                        onRemoveDiscount: _removeDiscount,
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
        originalUnitPrice: price,
        totalPrice: quantity * price,
      ));
    }

    final List<OverallDiscount> updatedDiscounts = [];
    for (int i = 0; i < discountDescriptionControllers.length; i++) {
      final description = discountDescriptionControllers[i].text.trim();
      final amount = double.tryParse(discountAmountControllers[i].text) ?? 0.0;

      if (description.isNotEmpty && amount > 0) {
        updatedDiscounts.add(OverallDiscount(
          description: description,
          amount: amount,
        ));
      }
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
      expenseCategory: expenseCategoryController.text.trim(),
      lineItems: updatedLineItems,
      overallDiscounts: updatedDiscounts,
      imageUrl: '',
    );

    final apiService = Provider.of<ApiService>(context, listen: false);
    final receiptService = Provider.of<ReceiptService>(context, listen: false);
    final budgetService = Provider.of<BudgetService?>(context, listen: false);

    addReceipt(context, apiService, widget.receiptImagePath, receiptData)
        .then((success) async {
      if (success == true) {
        print('totalAmount: $totalAmount');
        print('expenseCategory: ${expenseCategoryController.text.trim()}');
        if (totalAmount != null &&
            totalAmount > 0 &&
            expenseCategoryController.text.trim().isNotEmpty) {
          await budgetService!.recordReceipt(
            category: expenseCategoryController.text.trim(),
            amountSpent: totalAmount,
          );
        }
        _showSuccessSnackBar('Receipt saved successfully!');
        receiptService.refreshReceipts(apiService);
        Navigator.of(context).pop();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      } else {
        _showErrorSnackBar('Failed to save receipt. Please try again.');
      }
    }).catchError((error) {
      _showErrorSnackBar('An error occurred while saving the receipt: $error');
    });
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
