import 'package:flutter/material.dart';
import 'dart:convert';
import 'api_service.dart';
import '../models/receipt_model.dart';

class ReceiptService {
  static List<Receipt> _cachedReceipts = [];

  Future<List<Receipt>> fetchAndPrintUserReceipts(
      BuildContext context, ApiService apiService) async {
    try {
      final String? idToken = await apiService.getIdToken(context);

      if (idToken == null || idToken.isEmpty) {
        print('Error: Could not retrieve ID token.');
        return <Receipt>[];
      }

      String receiptsJson = await apiService.getUserReciepts(idToken);

      final Map<String, dynamic> jsonResponse = json.decode(receiptsJson);

      final List<dynamic> receiptsData = jsonResponse['receipts'] ?? [];

      // Convert each receipt JSON to Receipt object
      List<Receipt> receipts = receiptsData.map((receiptJson) {
        return Receipt.fromMap(receiptJson as Map<String, dynamic>);
      }).toList();

      print('Successfully fetched ${receipts.length} receipts');

      // Cache the receipts
      _cachedReceipts = receipts;

      return receipts;
    } catch (e) {
      print('An error occurred while fetching receipts: $e');
      return <Receipt>[];
    }
  }

  int getCachedReceiptsCount() {
    return _cachedReceipts.length;
  }

  List<Receipt> getCachedReceipts() {
    return _cachedReceipts;
  }

  double getTotalAmountSpent() {
    return _cachedReceipts.fold(0, (sum, receipt) => sum + receipt.totalAmount);
  }

  /*List<Receipt> getRecentReceipts() {
    if (_cachedReceipts.isEmpty) {
      return <Receipt>[];
    }
    // Sort receipts by date in descending order
    _cachedReceipts.sort((a, b) => b.date.compareTo(a.date));
    // Return the most recent 5 receipts
    return _cachedReceipts.take(5).toList();
  }*/
}
