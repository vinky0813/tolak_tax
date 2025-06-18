class Receipt {
  final String merchantName;
  final double totalAmount;
  final DateTime transactionDate;
  final String expenseCategory;
  // nullable variables
  final String? merchantAddress;
  final List<LineItem>? lineItems;
  final double? subtotal;
  final List<OverallDiscount>? overallDiscounts;
  final double? taxAmount;
  final double? tipAmount;
  final String? currencyCode;
  final String? paymentMethod;
  String? imageUrl;

  Receipt({
    required this.merchantName,
    required this.transactionDate,
    required this.totalAmount,
    required this.expenseCategory,
    this.merchantAddress,
    this.lineItems,
    this.subtotal,
    this.overallDiscounts,
    this.taxAmount,
    this.tipAmount,
    this.currencyCode,
    this.paymentMethod,
    this.imageUrl,
  });

  /// Factory to create a Receipt from a Map (e.g., from JSON)
  factory Receipt.fromMap(Map<String, dynamic> map) {
    final date = map['transaction_date'];
    final time = map['transaction_time'];
    final dateTimeString =
        (date != null && time != null) ? '$date $time' : date;

    return Receipt(
      merchantName: map['merchant_name'] ?? 'Unknown Merchant',
      transactionDate:
          DateTime.tryParse(dateTimeString ?? '') ?? DateTime.now(),
      totalAmount: (map['total_amount'] as num?)?.toDouble() ?? 0.0,
      merchantAddress: map['merchant_address'],
      lineItems: (map['line_items'] as List?)
          ?.map((item) => LineItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      subtotal: (map['subtotal'] as num?)?.toDouble(),
      overallDiscounts: (map['overall_discounts'] as List?)
          ?.map((item) => OverallDiscount.fromMap(item as Map<String, dynamic>))
          .toList(),
      taxAmount: (map['tax_amount'] as num?)?.toDouble(),
      tipAmount: (map['tip_amount'] as num?)?.toDouble(),
      currencyCode: map['currency_code'],
      paymentMethod: map['payment_method'],
      expenseCategory: map['expense_category'],
      imageUrl: map['imageUrl'],
    );
  }

  /// Convert a Receipt instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'merchant_name': merchantName,
      'merchant_address': merchantAddress,
      'transaction_date': transactionDate.toIso8601String().split('T').first,
      'transaction_time':
          transactionDate.toIso8601String().split('T')[1].substring(0, 8),
      'line_items': lineItems?.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'overall_discounts':
          overallDiscounts?.map((item) => item.toMap()).toList(),
      'tax_amount': taxAmount,
      'tip_amount': tipAmount,
      'total_amount': totalAmount,
      'currency_code': currencyCode,
      'payment_method': paymentMethod,
      'expense_category': expenseCategory,
      'imageUrl': imageUrl,
    };
  }
}

class LineItem {
  final String description;
  final int quantity;
  final double? originalUnitPrice;
  final double? lineItemDiscountAmount;
  final String? lineItemDiscountDescription;
  final double totalPrice;

  LineItem({
    required this.description,
    required this.quantity,
    this.originalUnitPrice,
    this.lineItemDiscountAmount,
    this.lineItemDiscountDescription,
    required this.totalPrice,
  });

  /// Factory to create a LineItem from a Map
  factory LineItem.fromMap(Map<String, dynamic> map) {
    return LineItem(
      description: map['description'] ?? 'Unknown Item',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      originalUnitPrice: (map['original_unit_price'] as num?)?.toDouble(),
      lineItemDiscountAmount:
          (map['line_item_discount_amount'] as num?)?.toDouble(),
      lineItemDiscountDescription: map['line_item_discount_description'],
      totalPrice: (map['total_price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert a LineItem instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'quantity': quantity,
      'original_unit_price': originalUnitPrice,
      'line_item_discount_amount': lineItemDiscountAmount,
      'line_item_discount_description': lineItemDiscountDescription,
      'total_price': totalPrice,
    };
  }
}

class OverallDiscount {
  final String description;
  final double amount;

  OverallDiscount({
    required this.description,
    required this.amount,
  });

  /// Factory to create an OverallDiscount from a Map
  factory OverallDiscount.fromMap(Map<String, dynamic> map) {
    return OverallDiscount(
      description: map['description'] ?? 'Unknown Discount',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert an OverallDiscount instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'amount': amount,
    };
  }
}
