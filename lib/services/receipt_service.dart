import 'package:flutter/material.dart';
import 'dart:convert';
import 'api_service.dart';
import '../models/receipt_model.dart';
import '../models/tax_classification_model.dart';
import '../services/auth_service.dart';

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

  List<Receipt> getReceiptsByYear(int year) {
    return _cachedReceipts.where((receipt) {
      final date = DateTime.parse(receipt.transactionDatetime);
      return date.year == year;
    }).toList();
  }

  Map<String, dynamic> getYearlyTaxData(int year) {
    List<Receipt> receipts = getReceiptsByYear(year);
    double totalTaxSaved = 0.0;
    double totalSpent = 0.0;
    int totalClaimableItems = 0;
    int totalNonClaimableItems = 0;

    totalTaxSaved = calculateTaxSavedWithReliefLimits(receipts);

    for (var receipt in receipts) {
      totalSpent += receipt.totalAmount;
      totalClaimableItems += receipt.taxSummary?.taxableItemsCount ?? 0;
      totalNonClaimableItems += receipt.taxSummary?.exemptItemsCount ?? 0;
    }

    final taxEfficiencyRate =
        totalSpent > 0 ? (totalTaxSaved / totalSpent * 100) : 0.0;

    return {
      'totalReceipts': receipts.length,
      'totalTaxSaved': totalTaxSaved,
      'totalSpent': totalSpent,
      'totalClaimableItems': totalClaimableItems,
      'totalNonClaimableItems': totalNonClaimableItems,
      'taxEfficiencyRate': taxEfficiencyRate,
    };
  }

  /// Calculates the total tax saved with relief limits applied per tax class
  double calculateTaxSavedWithReliefLimits(List<Receipt> receipts) {
    final taxClassification = TaxClassifcation();
    final Map<String, double> taxClassSpending = {};
    final Map<String, double> taxClassSavings = {};

    // First, calculate total spending and savings per tax class
    for (var receipt in receipts) {
      for (var item in receipt.lineItems) {
        if (item.taxLine != null &&
            item.taxLine!.taxEligible &&
            item.taxLine!.taxClass.isNotEmpty &&
            item.taxLine!.taxClass != 'NA') {
          final taxClass = item.taxLine!.taxClass;
          final mainCategory = taxClassification.getMainCategory(taxClass);

          // Accumulate spending by main category (to handle grouped limits)
          taxClassSpending[mainCategory] =
              (taxClassSpending[mainCategory] ?? 0.0) + item.totalPrice;

          // Accumulate raw tax savings by main category
          taxClassSavings[mainCategory] =
              (taxClassSavings[mainCategory] ?? 0.0) + item.taxLine!.taxAmount;
        }
      }
    }

    // Apply relief limits to calculate actual claimable tax savings
    double totalClaimableTaxSaved = 0.0;

    for (var entry in taxClassSpending.entries) {
      final taxClass = entry.key;
      final spentAmount = entry.value;
      final rawTaxSavings = taxClassSavings[taxClass] ?? 0.0;
      final reliefLimit = taxClassification.getEffectiveReliefLimit(taxClass);

      if (reliefLimit > 0) {
        // Calculate tax rate for this category
        final taxRate = spentAmount > 0 ? (rawTaxSavings / spentAmount) : 0.0;

        // Apply relief limit - only spending up to the limit can generate tax savings
        final claimableSpending =
            spentAmount > reliefLimit ? reliefLimit.toDouble() : spentAmount;
        final claimableTaxSavings = claimableSpending * taxRate;

        totalClaimableTaxSaved += claimableTaxSavings;
      } else {
        // If no relief limit is set, use the full amount (this shouldn't happen normally)
        totalClaimableTaxSaved += rawTaxSavings;
      }
    }

    return totalClaimableTaxSaved;
  }
}
