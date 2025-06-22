import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';

final DateTime now = DateTime.now();

final List<Receipt> dummyReceiptsData = [
  Receipt(
    merchantName: "Fresh Mart",
    merchantAddress: "123 Green Aisle, Food City, FC 12345",
    transactionDatetime:
        now.subtract(Duration(days: 1, hours: 2)).toIso8601String(),
    lineItems: [
      LineItem(
          description: "Organic Milk",
          quantity: 1,
          originalUnitPrice: 3.50,
          totalPrice: 3.50),
      LineItem(
          description: "Whole Wheat Bread",
          quantity: 1,
          originalUnitPrice: 2.75,
          totalPrice: 2.75),
      LineItem(
          description: "Free-Range Eggs (Dozen)",
          quantity: 1,
          originalUnitPrice: 4.20,
          totalPrice: 4.20),
      LineItem(
          description: "Apples (Granny Smith)",
          quantity: 0.5,
          originalUnitPrice: 3.00,
          totalPrice: 1.50), // 0.5 kg @ $3/kg
    ],
    subtotal: 3.50 + 2.75 + 4.20 + 1.50,
    taxAmount: 0.85, // Example tax
    totalAmount: (3.50 + 2.75 + 4.20 + 1.50) + 0.85,
    currencyCode: "USD",
    paymentMethod: "Credit Card (Visa ****4567)",
    expenseCategory: "Groceries",
    imageUrl: "https://example.com/receipts/grocery_mart_01.png",
  ),

  // Receipt 2: Cafe Receipt with Line Item Discount
  Receipt(
    merchantName: "The Daily Grind Cafe",
    transactionDatetime:
        now.subtract(Duration(days: 2, hours: 5)).toIso8601String(),
    lineItems: [
      LineItem(
          description: "Large Cappuccino",
          quantity: 1,
          originalUnitPrice: 4.50,
          totalPrice: 4.50),
      LineItem(
        description: "Almond Croissant",
        quantity: 1,
        originalUnitPrice: 3.00,
        lineItemDiscountAmount: 0.50,
        lineItemDiscountDescription: "Morning Special",
        totalPrice: 2.50, // 3.00 - 0.50
      ),
      LineItem(
          description: "Blueberry Muffin",
          quantity: 2,
          originalUnitPrice: 2.25,
          totalPrice: 4.50), // 2 * 2.25
    ],
    subtotal: 4.50 + 2.50 + 4.50,
    taxAmount: 0.90, // Example tax
    totalAmount: (4.50 + 2.50 + 4.50) + 0.90,
    currencyCode: "EUR",
    paymentMethod: "Contactless (Apple Pay)",
    expenseCategory: "Food & Drink",
    imageUrl: "https://example.com/receipts/cafe_grind_02.jpg",
  ),

  // Receipt 3: Electronics Store with Overall Discount and Tax
  Receipt(
    merchantName: "Tech World",
    merchantAddress: "789 Circuit Board Rd, Silicon Valley, CA 94000",
    transactionDatetime:
        now.subtract(Duration(days: 7, hours: 10)).toIso8601String(),
    lineItems: [
      LineItem(
          description: "Wireless Noise-Cancelling Headphones",
          quantity: 1,
          originalUnitPrice: 199.99,
          totalPrice: 199.99),
      LineItem(
          description: "Ergonomic Mouse",
          quantity: 1,
          originalUnitPrice: 49.50,
          totalPrice: 49.50),
    ],
    subtotal: 199.99 + 49.50,
    overallDiscounts: [
      OverallDiscount(description: "Loyalty Member Discount", amount: 25.00),
    ],
    taxAmount:
        ((199.99 + 49.50) - 25.00) * 0.08, // 8% tax on discounted subtotal
    totalAmount: ((199.99 + 49.50) - 25.00) * 1.08,
    currencyCode: "USD",
    paymentMethod: "Amex ****1001",
    expenseCategory: "Electronics",
    imageUrl: "https://example.com/receipts/tech_world_03.png",
  ),

  // Receipt 4: Minimal Receipt (e.g., Parking)
  Receipt(
    merchantName: "City Parking Lot B",
    transactionDatetime: now.subtract(Duration(hours: 3)).toIso8601String(),
    lineItems: [
      LineItem(
          description: "Parking Fee (2 hours)",
          quantity: 1,
          originalUnitPrice: 8.00,
          totalPrice: 8.00),
    ],
    subtotal: 8.00,
    totalAmount: 8.00,
    paymentMethod: "Cash",
    expenseCategory: "Transportation",
    imageUrl: "https://example.com/receipts/parking_04.pdf",
  ),

  // Receipt 5: Restaurant Bill with Multiple Items, Some Discounts, Overall Discount, and Tax
  Receipt(
    merchantName: "Luigi's Italian Place",
    merchantAddress: "123 Pasta Lane, Foodville, FV 67890",
    transactionDatetime:
        now.subtract(Duration(days: 3, hours: 19)).toIso8601String(),
    lineItems: [
      LineItem(
          description: "Spaghetti Carbonara",
          quantity: 2,
          originalUnitPrice: 18.00,
          totalPrice: 36.00), // 2 * 18.00
      LineItem(
        description: "Garlic Bread Supreme",
        quantity: 1,
        originalUnitPrice: 7.50,
        lineItemDiscountAmount: 1.50,
        lineItemDiscountDescription: "Happy Hour Appetizer",
        totalPrice: 6.00, // 7.50 - 1.50
      ),
      LineItem(
          description: "Bottle of Chianti",
          quantity: 1,
          originalUnitPrice: 25.00,
          totalPrice: 25.00),
      LineItem(
          description: "Tiramisu",
          quantity: 2,
          originalUnitPrice: 8.00,
          totalPrice: 16.00), // 2 * 8.00
    ],
    subtotal: 36.00 + 6.00 + 25.00 + 16.00,
    overallDiscounts: [
      OverallDiscount(description: "Weekend Special Coupon", amount: 10.00),
    ],
    // Tax on (subtotal - overall_discount)
    taxAmount: ((36.00 + 6.00 + 25.00 + 16.00) - 10.00) * 0.07, // 7% tax
    totalAmount: ((36.00 + 6.00 + 25.00 + 16.00) - 10.00) * 1.07,
    currencyCode: "USD",
    paymentMethod: "Mastercard ****3456",
    expenseCategory: "Dining",
    imageUrl: "https://example.com/receipts/luigis_italian_05.jpeg",
  ),

  // Receipt 6: Online Subscription
  Receipt(
    merchantName: "CloudServices Pro",
    transactionDatetime: now
        .subtract(Duration(days: 15))
        .toIso8601String(), // Typically a recurring date
    lineItems: [
      LineItem(
          description: "Monthly Subscription - Pro Plan",
          quantity: 1,
          originalUnitPrice: 19.99,
          totalPrice: 19.99),
    ],
    subtotal: 19.99,
    // No tax or tax included depending on region, keeping it simple here
    totalAmount: 19.99,
    currencyCode: "USD",
    paymentMethod: "PayPal (user@example.com)",
    expenseCategory: "Software & Subscriptions",
    imageUrl:
        "https://example.com/receipts/cloud_pro_06.png", // Often no physical image, but a link to an invoice pdf
  ),

  // Receipt 7: Simple receipt with no line items (total amount directly given)
  Receipt(
    merchantName: "Corner Store Quick Buy",
    transactionDatetime: now.subtract(Duration(minutes: 30)).toIso8601String(),
    lineItems: [], // No individual line items parsed
    // Subtotal might be unknown if line items are missing
    totalAmount: 5.75,
    currencyCode: "CAD",
    paymentMethod: "Debit",
    expenseCategory: "Snacks",
    imageUrl: "https://example.com/receipts/corner_store_07.jpg",
  ),
];
