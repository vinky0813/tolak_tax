// lib/data/dummy_receipt_data.dart

import 'package:tolak_tax/models/receipt_model.dart';

final List<Receipt> dummyReceipts = [
  // 1. Detailed Tech Store Receipt - January 2025
  Receipt(
    merchantName: "Tech Gadgets Store",
    merchantAddress: "456 Innovation Dr, Silicon City, TX 75001",
    transactionDate: DateTime(2025, 1, 22, 14, 30, 0),
    lineItems: [
      LineItem(
        description: "Wireless Mouse",
        quantity: 1,
        originalUnitPrice: 25.00,
        lineItemDiscountAmount: 5.00,
        lineItemDiscountDescription: "New Year Special",
        totalPrice: 20.00,
      ),
      LineItem(description: "USB-C Cable", quantity: 2, originalUnitPrice: 10.00, totalPrice: 20.00),
      LineItem(description: "Keyboard", quantity: 1, originalUnitPrice: 70.00, totalPrice: 70.00),
    ],
    subtotal: 110.00,
    overallDiscounts: [
      OverallDiscount(description: "Loyalty Member 10% Off", amount: 11.00),
      OverallDiscount(description: "Holiday Coupon", amount: 5.00),
    ],
    taxAmount: 7.52,
    tipAmount: null,
    totalAmount: 91.52,
    currencyCode: "USD",
    paymentMethod: "Visa ****4321",
    expenseCategory: "shopping",
    imageUrl: "https://images.pexels.com/photos/39284/macbook-apple-imac-computer-39284.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
  ),

  // 2. Standard Grocery Receipt - February 2025
  Receipt(
    merchantName: "Green Grocer",
    merchantAddress: "123 Produce Lane, Farmville, CA 90210",
    transactionDate: DateTime(2025, 2, 10, 10, 5, 0),
    lineItems: [
      LineItem(description: "Organic Milk", quantity: 1, totalPrice: 3.50),
      LineItem(description: "Sourdough Bread", quantity: 1, totalPrice: 4.75),
      LineItem(description: "Avocados", quantity: 3, totalPrice: 5.97),
      LineItem(description: "Chicken Breast", quantity: 1, totalPrice: 8.99),
    ],
    subtotal: 23.21,
    taxAmount: 1.86,
    totalAmount: 25.07,
    paymentMethod: "Mastercard ****1122",
    expenseCategory: "food",
    imageUrl: "https://images.pexels.com/photos/3962294/pexels-photo-3962294.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
  ),

  // 3. Cafe Receipt with a Tip - February 2025
  Receipt(
    merchantName: "The Corner Cafe",
    merchantAddress: "789 Coffee Bean Blvd, Metro City, NY 10001",
    transactionDate: DateTime(2025, 2, 28, 8, 45, 10),
    lineItems: [
      LineItem(description: "Large Cappuccino", quantity: 1, totalPrice: 4.50),
      LineItem(description: "Almond Croissant", quantity: 1, totalPrice: 3.25),
    ],
    subtotal: 7.75,
    taxAmount: 0.69,
    tipAmount: 1.55,
    totalAmount: 9.99,
    paymentMethod: "Amex ****9000",
    expenseCategory: "food",
    imageUrl: "https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
  ),

  // 4. Simple Receipt with Minimal Data - April 2025
  Receipt(
    merchantName: "Quick Mart",
    transactionDate: DateTime(2025, 4, 5, 15, 20, 0),
    totalAmount: 2.50,
    expenseCategory: "Snacks",
    // All other fields are null: no address, items, tax, etc.
    // No imageUrl to test the errorBuilder/placeholder.
  ),

  // 5. Digital Service / Subscription - May 2025
  Receipt(
      merchantName: "CloudServices Inc.",
      transactionDate: DateTime(2025, 5, 1, 0, 0, 0),
      lineItems: [
        LineItem(
          description: "Pro Plan Monthly Subscription",
          quantity: 1,
          totalPrice: 15.00,
        ),
      ],
      subtotal: 15.00,
      totalAmount: 15.00, // No tax on this digital service
      paymentMethod: "PayPal",
      expenseCategory: "utilities",
      imageUrl: "https://images.pexels.com/photos/1779487/pexels-photo-1779487.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
  ),
];