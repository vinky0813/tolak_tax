class LineItem {
  String description;
  double quantity;
  double originalUnitPrice;
  double? lineItemDiscountAmount;
  String? lineItemDiscountDescription;
  double totalPrice;
  TaxLine? taxLine;

  LineItem({
    required this.description,
    this.quantity = 1.0,
    required this.originalUnitPrice,
    this.lineItemDiscountAmount,
    this.lineItemDiscountDescription,
    required this.totalPrice,
    this.taxLine,
  });
}

class TaxLine {
  bool taxEligible;
  String taxClass;
  String taxClassDescription;
  double taxAmount;

  TaxLine({
    required this.taxEligible,
    required this.taxClass,
    required this.taxClassDescription,
    required this.taxAmount,
  });
}

class TaxSummary {
  double totalTaxSaved;
  int exemptItemsCount;
  int taxableItemsCount;
  List<TaxLine> taxableItems;

  TaxSummary({
    required this.totalTaxSaved,
    required this.exemptItemsCount,
    required this.taxableItemsCount,
    List<TaxLine>? taxableItems,
  }) : this.taxableItems = taxableItems ?? [];
}

class OverallDiscount {
  String description;
  double amount;

  OverallDiscount({
    required this.description,
    required this.amount,
  });
}

class Receipt {
  String merchantName;
  String? merchantAddress;
  String transactionDatetime;
  List<LineItem> lineItems;

  double? subtotal;
  List<OverallDiscount>? overallDiscounts;
  double? taxAmount;
  double totalAmount;

  String? currencyCode;
  String? paymentMethod;
  String expenseCategory;

  String imageUrl = '';
  TaxSummary? taxSummary;

  Receipt({
    required this.merchantName,
    this.merchantAddress,
    required this.transactionDatetime,
    List<LineItem>? lineItems,
    this.subtotal,
    List<OverallDiscount>? overallDiscounts,
    this.taxAmount,
    required this.totalAmount,
    this.currencyCode,
    this.paymentMethod,
    required this.expenseCategory,
    required this.imageUrl,
    this.taxSummary,
  })  : this.lineItems = lineItems ?? [],
        this.overallDiscounts = overallDiscounts ?? [];

  /// Factory to create a Receipt from a Map (e.g., from JSON or raw list)
  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
        merchantName: map['merchant_name'] ?? map['title'] ?? '',
        merchantAddress: map['merchant_address'],
        transactionDatetime: map['transaction_datetime'] ??
            map['date'] ??
            DateTime.now().toIso8601String(),
        lineItems: (map['line_items'] as List<dynamic>?)
            ?.map((item) => LineItem(
                description: item['description'] ?? '',
                quantity: (item['quantity'] as num?)?.toDouble() ?? 1.0,
                originalUnitPrice:
                    (item['original_unit_price'] as num?)?.toDouble() ?? 0.0,
                lineItemDiscountAmount:
                    (item['line_item_discount_amount'] as num?)?.toDouble(),
                lineItemDiscountDescription:
                    item['line_item_discount_description'],
                totalPrice: (item['total_price'] as num?)?.toDouble() ?? 0.0,
                taxLine: item['tax_line'] != null
                    ? TaxLine(
                        taxEligible: item['tax_line']['tax_eligible'] ?? false,
                        taxClass: item['tax_line']['tax_class'] ?? '',
                        taxClassDescription:
                            item['tax_line']['tax_class_description'] ?? '',
                        taxAmount: (item['tax_line']['tax_amount'] as num?)
                                ?.toDouble() ??
                            0.0,
                      )
                    : null))
            .toList(),
        subtotal: (map['subtotal'] as num?)?.toDouble(),
        overallDiscounts: (map['overall_discounts'] as List<dynamic>?)
            ?.map((discount) => OverallDiscount(
                  description: discount['description'] ?? '',
                  amount: (discount['amount'] as num?)?.toDouble() ?? 0.0,
                ))
            .toList(),
        taxAmount: (map['tax_amount'] as num?)?.toDouble(),
        totalAmount:
            (map['total_amount'] ?? map['amount'] as num?)?.toDouble() ?? 0.0,
        currencyCode: map['currency_code'],
        paymentMethod: map['payment_method'],
        expenseCategory: map['expense_category'] ?? map['category'],
        imageUrl: map['image_url']['image_url'] as String? ?? '',
        taxSummary: map['tax_summary'] != null
            ? TaxSummary(
                totalTaxSaved: (map['tax_summary']['total_tax_saved'] as num?)
                        ?.toDouble() ??
                    0.0,
                exemptItemsCount: map['tax_summary']['exempt_items_count'] ?? 0,
                taxableItemsCount:
                    map['tax_summary']['taxable_items_count'] ?? 0,
                taxableItems: map['tax_summary']['taxable_items'] != null
                    ? (map['tax_summary']['taxable_items'] as List<dynamic>)
                        .map((item) => TaxLine(
                              taxEligible: item['tax_eligible'] ?? false,
                              taxClass: item['tax_class'] ?? '',
                              taxClassDescription:
                                  item['tax_class_description'] ?? '',
                              taxAmount:
                                  (item['tax_amount'] as num?)?.toDouble() ??
                                      0.0,
                            ))
                        .toList()
                    : null)
            : null);
  }

  /// Convert a Receipt instance to a Map (e.g., for saving or API use)
  Map<String, dynamic> toMap() {
    return {
      'merchant_name': merchantName,
      'merchant_address': merchantAddress,
      'transaction_datetime': transactionDatetime,
      'line_items': lineItems
          .map((item) => {
                'description': item.description,
                'quantity': item.quantity,
                'original_unit_price': item.originalUnitPrice,
                'line_item_discount_amount': item.lineItemDiscountAmount,
                'line_item_discount_description':
                    item.lineItemDiscountDescription,
                'total_price': item.totalPrice,
              })
          .toList(),
      'subtotal': subtotal,
      'overall_discounts': overallDiscounts
          ?.map((discount) => {
                'description': discount.description,
                'amount': discount.amount,
              })
          .toList(),
      'tax_amount': taxAmount,
      'total_amount': totalAmount,
      'currency_code': currencyCode,
      'payment_method': paymentMethod,
      'expense_category': expenseCategory,
    };
  }
}
