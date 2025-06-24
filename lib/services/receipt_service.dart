import 'package:flutter/material.dart';
import 'dart:convert';
import 'api_service.dart';
import '../models/receipt_model.dart';
import 'package:provider/provider.dart';

class ReceiptService {
  static List<Receipt> _cachedReceipts = [];

  Future<List<Receipt>> fetchReceipts(
      BuildContext context, ApiService apiService) async {
    final String? idToken = await apiService.getIdToken(context);

    if (idToken == null || idToken.isEmpty) {
      print('Error: Could not retrieve ID token.');
      return <Receipt>[];
    }

    String receiptsJson = await apiService.getUserReciepts(idToken);

    // Parse the JSON response
    final Map<String, dynamic> responseData = jsonDecode(receiptsJson);
    final receiptsData = responseData['receipts'] ?? [];

    // Convert to Receipt objects
    List<Receipt> receipts = List<Receipt>.from(
        receiptsData.map((receiptData) => Receipt.fromMap(receiptData)));

    // Cache the receipts
    _cachedReceipts = receipts;

    print('Successfully fetched ${receipts.length} receipts');
    return receipts;
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
