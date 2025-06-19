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
  String description;
  double quantity;
  double original_unit_price;
  double? line_item_discount_amount;
  String? line_item_discount_description;
  double total_price;

  LineItem({
    required this.description,
    this.quantity = 1.0,
    required this.original_unit_price,
    this.line_item_discount_amount,
    this.line_item_discount_description,
    required this.total_price,
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
}

class Receipt {
  String merchant_name;
  String? merchant_address;
  String transaction_datetime;
  List<LineItem> line_items;

  double? subtotal;
  List<OverallDiscount>? overall_discounts;
  double? tax_amount;
  double total_amount;

  String? currency_code;
  String? payment_method;
  String? expense_category;

  Receipt({
    required this.merchant_name,
    this.merchant_address,
    required this.transaction_datetime,
    List<LineItem>? line_items,
    this.subtotal,
    List<OverallDiscount>? overall_discounts,
    this.tax_amount,
    required this.total_amount,
    this.currency_code,
    this.payment_method,
    this.expense_category,
  })  : this.line_items = line_items ?? [],
        this.overall_discounts = overall_discounts ?? [];

  // Backward compatibility getters
  String get title => merchant_name;
  DateTime get date =>
      DateTime.tryParse(transaction_datetime) ?? DateTime.now();
  double get amount => total_amount;
  String get category => expense_category ?? 'uncategorized';
  String? get imageUrl =>
      null; // Add imageUrl getter for backward compatibility

  /// Factory to create a Receipt from a Map (e.g., from JSON or raw list)
  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
      merchant_name: map['merchant_name'] ?? map['title'] ?? '',
      merchant_address: map['merchant_address'],
      transaction_datetime: map['transaction_datetime'] ??
          map['date'] ??
          DateTime.now().toIso8601String(),
      line_items: (map['line_items'] as List<dynamic>?)
          ?.map((item) => LineItem(
                description: item['description'] ?? '',
                quantity: (item['quantity'] as num?)?.toDouble() ?? 1.0,
                original_unit_price:
                    (item['original_unit_price'] as num?)?.toDouble() ?? 0.0,
                line_item_discount_amount:
                    (item['line_item_discount_amount'] as num?)?.toDouble(),
                line_item_discount_description:
                    item['line_item_discount_description'],
                total_price: (item['total_price'] as num?)?.toDouble() ?? 0.0,
              ))
          .toList(),
      subtotal: (map['subtotal'] as num?)?.toDouble(),
      overall_discounts: (map['overall_discounts'] as List<dynamic>?)
          ?.map((discount) => OverallDiscount(
                description: discount['description'] ?? '',
                amount: (discount['amount'] as num?)?.toDouble() ?? 0.0,
              ))
          .toList(),
      tax_amount: (map['tax_amount'] as num?)?.toDouble(),
      total_amount:
          (map['total_amount'] ?? map['amount'] as num?)?.toDouble() ?? 0.0,
      currency_code: map['currency_code'],
      payment_method: map['payment_method'],
      expense_category: map['expense_category'] ?? map['category'],
    );
  }

  /// Convert a Receipt instance to a Map (e.g., for saving or API use)
  Map<String, dynamic> toMap() {
    return {
      'merchant_name': merchant_name,
      'merchant_address': merchant_address,
      'transaction_datetime': transaction_datetime,
      'line_items': line_items
          .map((item) => {
                'description': item.description,
                'quantity': item.quantity,
                'original_unit_price': item.original_unit_price,
                'line_item_discount_amount': item.line_item_discount_amount,
                'line_item_discount_description':
                    item.line_item_discount_description,
                'total_price': item.total_price,
              })
          .toList(),
      'subtotal': subtotal,
      'overall_discounts': overall_discounts
          ?.map((discount) => {
                'description': discount.description,
                'amount': discount.amount,
              })
          .toList(),
      'tax_amount': tax_amount,
      'total_amount': total_amount,
      'currency_code': currency_code,
      'payment_method': payment_method,
      'expense_category': expense_category,
    };
  }
}
