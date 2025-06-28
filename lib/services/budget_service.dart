import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tolak_tax/data/category_constants.dart';
import 'package:tolak_tax/services/api_service.dart';
import 'package:tolak_tax/services/auth_service.dart';

class BudgetService with ChangeNotifier {
  final ApiService _apiService;
  final AuthService _authService;

  Map<String, Map<String, double>> _budgets = {};
  bool _isInitialized = false;
  String? _currentBudgetPeriod;
  bool _isLoading = false;

  Map<String, Map<String, double>> get budgets => _budgets;
  String? get currentBudgetPeriod => _currentBudgetPeriod;
  bool get isLoading => _isLoading;

  final List<String> _newlyOverBudgetCategories = [];
  List<String> get newlyOverBudgetCategories => _newlyOverBudgetCategories;

  BudgetService({
    required ApiService apiService,
    required AuthService authService,
  })  : _apiService = apiService,
        _authService = authService {
    initialize();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearNewlyOverBudgetCategories() {
    _newlyOverBudgetCategories.clear();
  }

  Future<void> _performMonthlyReset(
      String idToken,
      String newPeriod,
      Map<String, Map<String, double>> currentBudgetsBeforeReset,
      ) async {
    print("BudgetService: Performing monthly reset for period $newPeriod.");

    final Map<String, Map<String, double>> resetBudgets =
    currentBudgetsBeforeReset.map((category, data) {
      return MapEntry(category, {
        'budget': data['budget'] ?? 0.0,
        'spentAmount': 0.0,
      });
    });

    _budgets = resetBudgets;
    _currentBudgetPeriod = newPeriod;
    notifyListeners();

    await _apiService.saveBudget(
      idToken: idToken,
      budgets: _budgets,
      budgetPeriod: _currentBudgetPeriod,
    );
    print("BudgetService: Monthly budget reset and saved for period $_currentBudgetPeriod.");
  }

  Future<void> initialize() async {
    if (_isInitialized && !_isLoading) return;
    if (_isLoading) return;

    _setLoading(true);

    final idToken = await _authService.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      print("BudgetService: ID token is null or empty during initialization.");
      _setLoading(false);
      return;
    }

    try {
      final apiData = await _apiService.getBudget(idToken: idToken);

      final now = DateTime.now();
      final String currentActualMonthYear = DateFormat('yyyy-MM').format(now);

      print('BudgetService apiData: $apiData');
      final budgets = apiData['budgets'] as Map<String, dynamic>;
      _currentBudgetPeriod = currentActualMonthYear;
      _budgets = budgets.map((category, data) {
        return MapEntry(
          category,
          {
            'budget': data['budget'] as double,
            'spentAmount': data['spentAmount'] as double,
          },
        );
      });

      final String? backendBudgetPeriod = apiData['budgetPeriod'] as String?;

      if (backendBudgetPeriod == null || backendBudgetPeriod != currentActualMonthYear) {
        await _performMonthlyReset(idToken, currentActualMonthYear, _budgets);
      }

      _isInitialized = true;
      _setLoading(false);
    } catch (e) {
      final message = e.toString();
      print("message $message");
      if (message.contains('404')) {
        print('BudgetService: No existing budget found. Creating default...');
        final defaultBudget = _generateDefaultBudget();
        final now = DateTime.now();
        final String currentActualMonthYear = DateFormat('yyyy-MM').format(now);
        _currentBudgetPeriod = currentActualMonthYear;
        await _apiService.saveBudget(idToken: idToken, budgets: defaultBudget, budgetPeriod: _currentBudgetPeriod);
        _budgets = defaultBudget;
        _isInitialized = true;
        _setLoading(false);
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

    await _apiService.saveBudget(idToken: idToken, budgets: updatedBudgets, budgetPeriod: _currentBudgetPeriod, );

    _budgets = updatedBudgets;

    print('updatedBudgets: $updatedBudgets');

    notifyListeners();
  }

  Future<void> recordReceipt({
    required String category,
    required double amountSpent,
  }) async {
    final idToken = await _authService.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      return;
    }
    Map<String, Map<String, double>> currentServerBudgets;
    try {
      final apiData = await _apiService.getBudget(idToken: idToken);

      if (apiData == null || apiData['budgets'] == null) {
        return;
      }

      final budgetForCategory = _budgets[category]!['budget'] ?? 0.0;
      final spentAmountBefore = _budgets[category]!['spentAmount'] ?? 0.0;
      final spentAmountAfter = spentAmountBefore + amountSpent;

      if (spentAmountBefore <= budgetForCategory && spentAmountAfter > budgetForCategory) {
        _newlyOverBudgetCategories.add(category);
        print("BudgetService: User has gone over budget for category '$category'. Added to list.");
      }

      final budgetsFromApi = apiData['budgets'] as Map<String, dynamic>;
      currentServerBudgets = budgetsFromApi.map((cat, data) {
        return MapEntry(
          cat,
          {
            'budget': (data['budget'] as num?)?.toDouble() ?? 0.0,
            'spentAmount': (data['spentAmount'] as num?)?.toDouble() ?? 0.0,
          },
        );
      });

    } catch (e) {
      print("BudgetService: Error fetching latest budget data: $e");
      return;
    }

    if (!currentServerBudgets.containsKey(category)) {
      print("BudgetService: Category '$category' not found in current budget data.");
      return;
    }

    Map<String, Map<String, double>> updatedBudgets = Map.from(currentServerBudgets.map(
          (key, value) => MapEntry(key, Map<String, double>.from(value)),
    ));

    final currentSpentOnServer = updatedBudgets[category]!['spentAmount'] ?? 0.0;
    updatedBudgets[category]!['spentAmount'] = currentSpentOnServer + amountSpent;
    try {


      await _apiService.saveBudget(idToken: idToken, budgets: updatedBudgets, budgetPeriod: _currentBudgetPeriod);
      _budgets = updatedBudgets;
      notifyListeners();

    } catch (e) {
      print("BudgetService: Error saving updated budget data: $e");
      throw e;
    }
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
