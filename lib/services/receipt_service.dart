import 'package:flutter/material.dart';
import 'dart:convert';
import 'api_service.dart';
import '../models/receipt_model.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';

class ReceiptService with ChangeNotifier {
  final ApiService _apiService;
  final AuthService _authService;

  ReceiptService({
    required ApiService apiService,
    required AuthService authService,
  })  : _apiService = apiService,
        _authService = authService {
    initialize();
  }

  void initialize() {
    fetchReceipts(_apiService);
    print('ReceiptService initialized');
  }

  static List<Receipt> _cachedReceipts = [];

  Future<void> fetchReceipts(ApiService apiService) async {
    final String? idToken = await _authService.getIdToken();

    if (idToken == null || idToken.isEmpty) {
      print('Error: Could not retrieve ID token.');
      _cachedReceipts = [];
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
