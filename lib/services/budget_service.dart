import 'package:flutter/material.dart';
import 'package:tolak_tax/data/category_constants.dart';
import 'package:tolak_tax/services/api_service.dart';
import 'package:tolak_tax/services/auth_service.dart';

class BudgetService with ChangeNotifier {
  final ApiService _apiService;
  final AuthService _authService;

  Map<String, Map<String, double>> _budgets = {};
  bool _isInitialized = false;

  Map<String, Map<String, double>> get budgets => _budgets;

  BudgetService({
    required ApiService apiService,
    required AuthService authService,
  })  : _apiService = apiService,
        _authService = authService {
    initialize();
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    final idToken = await _authService.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      print("BudgetService: ID token is null or empty during initialization.");
      return;
    }

    try {
      final apiData = await _apiService.getBudget(idToken: idToken);

      print('BudgetService apiData: $apiData');
      final budgets = apiData['budgets'] as Map<String, dynamic>;
      _budgets = budgets.map((category, data) {
        return MapEntry(
          category,
          {
            'budget': data['budget'] as double,
            'spentAmount': data['spentAmount'] as double,
          },
        );
      });

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      final message = e.toString();
      if (message.contains('404')) {
        print('BudgetService: No existing budget found. Creating default...');
        final defaultBudget = _generateDefaultBudget();
        await _apiService.saveBudget(idToken: idToken, budgets: defaultBudget);
        _budgets = defaultBudget;
        _isInitialized = true;
        notifyListeners();
      } else {
        print('BudgetService Error: $e');
      }
    }
  }

  Future<void> saveBudgets(Map<String, Map<String, double>> updatedBudgets) async {
    final idToken = await _authService.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      throw Exception('ID token is required to save budgets.');
    }

    await _apiService.saveBudget(idToken: idToken, budgets: updatedBudgets);

    _budgets = updatedBudgets;

    notifyListeners();
  }

  Map<String, Map<String, double>> _generateDefaultBudget() {
    return {
      for (final category in allCategories)
        if (category != 'All')
          category: {
            'budget': 300.0,
            'spentAmount': 0.0,
          }
    };
  }
}
