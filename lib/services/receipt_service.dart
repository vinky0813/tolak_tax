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
        _authService = authService;

  static List<Receipt> _cachedReceipts = [];
  static bool _isLoading = false;
  static bool _hasInitialized = false;
  static DateTime? _lastFetchTime;

  // Cache duration - 5 minutes
  static const Duration _cacheDuration = Duration(minutes: 5);

  Future<void> fetchReceipts([ApiService? apiService]) async {
    // Prevent multiple simultaneous calls
    if (_isLoading) {
      print('ReceiptService: Already fetching receipts, skipping...');
      return;
    }

    // Check if we have recent cached data
    if (_hasInitialized &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
      print('ReceiptService: Using cached data');
      return;
    }

    _isLoading = true;

    try {
      final String? idToken = await _authService.getIdToken();

      if (idToken == null || idToken.isEmpty) {
        print('Error: Could not retrieve ID token.');
        _cachedReceipts = [];
        _hasInitialized = true;
        notifyListeners();
        return;
      }

      final api = apiService ?? _apiService;
      String receiptsJson = await api.getUserReciepts(idToken);

      // Parse the JSON response
      final Map<String, dynamic> responseData = jsonDecode(receiptsJson);
      final receiptsData = responseData['receipts'] ?? [];

      // Convert to Receipt objects
      List<Receipt> receipts = List<Receipt>.from(
          receiptsData.map((receiptData) => Receipt.fromMap(receiptData)));

      // Cache the receipts
      _cachedReceipts = receipts;
      _hasInitialized = true;
      _lastFetchTime = DateTime.now();

      print('ReceiptService: Fetched ${receipts.length} receipts');
      notifyListeners();
    } catch (e) {
      print('ReceiptService: Error fetching receipts: $e');
    } finally {
      _isLoading = false;
    }
  }

  // Method to force refresh (bypass cache)
  Future<void> refreshReceipts([ApiService? apiService]) async {
    _lastFetchTime = null;
    await fetchReceipts(apiService);
  }

  // Method to initialize receipts (call once on app start)
  Future<void> initialize() async {
    if (!_hasInitialized && !_isLoading) {
      await fetchReceipts();
    }
  }

  // Getters
  bool get isLoading => _isLoading;
  bool get hasInitialized => _hasInitialized;

  int getCachedReceiptsCount() {
    return _cachedReceipts.length;
  }

  List<Receipt> getCachedReceipts() {
    // Fetch receipts if not initialized
    if (!_hasInitialized && !_isLoading) {
      fetchReceipts();
    }
    return _cachedReceipts;
  }

  double getTotalAmountSpent() {
    return _cachedReceipts.fold(0, (sum, receipt) => sum + receipt.totalAmount);
  }

  List<Receipt> getRecentReceipts() {
    if (_cachedReceipts.isEmpty) {
      return <Receipt>[];
    }
    // Sort receipts by date in descending order
    _cachedReceipts
        .sort((a, b) => b.transactionDatetime.compareTo(a.transactionDatetime));
    // Return the most recent 5 receipts
    return _cachedReceipts.take(5).toList();
  }
}
