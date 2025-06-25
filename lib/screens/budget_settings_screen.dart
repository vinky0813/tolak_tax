import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tolak_tax/services/budget_service.dart';
import 'package:tolak_tax/utils/category_helper.dart';

class BudgetSettingsScreen extends StatefulWidget {

  const BudgetSettingsScreen({super.key});

  @override
  State<BudgetSettingsScreen> createState() => _BudgetSettingsScreenState();
}

class _BudgetSettingsScreenState extends State<BudgetSettingsScreen> {
  late String? _focusedCategoryKey;
  late List<String> _categoryKeys;
  final Map<String, TextEditingController> _budgetControllers = {};

  @override
  void initState() {
    super.initState();
    _focusedCategoryKey = null;

    final budgetService = Provider.of<BudgetService?>(context, listen: false);
    final budgets = budgetService!.budgets;
    _categoryKeys = budgets.keys.toList();

    for (var category in _categoryKeys) {
      final budget = budgets[category]?['budget'] ?? 0.0;
      _budgetControllers[category] =
          TextEditingController(text: budget.toStringAsFixed(2));
    }
  }

  double getOverallBudget() {
    double total = 0.0;
    for (var controller in _budgetControllers.values) {
      final parsed = double.tryParse(controller.text) ?? 0.0;
      total += parsed;
    }
    return total;
  }

  Future<void> saveBudgetSettings() async {
    try {
      final budgetService = Provider.of<BudgetService?>(context, listen: false);

      final updatedBudgets = <String, Map<String, double>>{};

      if (budgetService == null) {
        print('BudgetService not available');
        return;
      }

      for (var key in _categoryKeys) {
        final parsedBudget = double.tryParse(_budgetControllers[key]?.text ?? '0') ?? 0.0;
        final spent = budgetService.budgets[key]?['spentAmount'] ?? 0.0;

        updatedBudgets[key] = {
          'budget': parsedBudget,
          'spentAmount': spent,
        };
      }
      print(updatedBudgets);

      await budgetService.saveBudgets(updatedBudgets);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Budgets saved successfully!')),
      );
    } catch (e) {
      print('Error saving budgets: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save budgets.')),
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _budgetControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final budgetService = Provider.of<BudgetService?>(context);

    final budgets = budgetService?.budgets ?? {};

    double totalSpent = budgets.values.fold(
      0.0,
          (sum, data) => sum + (data['spentAmount'] ?? 0.0),
    );

    final overallBudget = getOverallBudget();
    final isOverBudgetOverall = (overallBudget - totalSpent) < 0;
    final totalProgress =
        overallBudget > 0 ? (totalSpent / overallBudget).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 120,
              backgroundColor: colorScheme.primary,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Budget Settings',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
                titlePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              foregroundColor: colorScheme.onPrimary,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final save = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm Save'),
                        content: Text('Are you sure you want to save your budget settings?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Save'),
                          ),
                        ],
                      ),
                    );

                    if (save == true) {
                      await saveBudgetSettings();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Save',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              color: Colors.white,
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Overall Budget',
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        color: colorScheme.onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'RM ${overallBudget.toStringAsFixed(2)}',
                                      style: theme.textTheme.headlineLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isOverBudgetOverall
                                            ? Colors.red.shade700
                                            : Colors.green.shade800,
                                      ),
                                    ),
                                    Text(
                                      isOverBudgetOverall
                                          ? 'Over Budget'
                                          : 'Remaining',
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        color: colorScheme.onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: totalProgress,
                                        backgroundColor: colorScheme.primary
                                            .withOpacity(0.2),
                                        valueColor: AlwaysStoppedAnimation(
                                            colorScheme.primary),
                                        minHeight: 10,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Spent: RM ${totalSpent.toStringAsFixed(2)}',
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                        Text(
                                          'Budget: RM ${overallBudget.toStringAsFixed(2)}',
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ExpansionPanelList(
                              dividerColor: Colors.grey.withOpacity(0.4),
                              animationDuration:
                                  const Duration(milliseconds: 500),
                              elevation: 0,
                              expansionCallback: (index, isExpanded) {
                                setState(() {
                                  final tappedKey = _categoryKeys[index];
                                  _focusedCategoryKey =
                                      (_focusedCategoryKey == tappedKey)
                                          ? ''
                                          : tappedKey;
                                });
                              },
                              children: _categoryKeys.map((categoryKey) {
                                final controller =
                                    _budgetControllers[categoryKey]!;
                                final spentAmount = budgets[categoryKey]
                                        ?['spentAmount'] ??
                                    0.0;
                                final currentBudget =
                                    double.tryParse(controller.text) ?? 0.0;
                                final color = CategoryHelper.getCategoryColor(
                                    categoryKey);
                                final icon =
                                    CategoryHelper.getIcon(categoryKey);
                                final categoryName =
                                    CategoryHelper.getDisplayName(categoryKey);
                                final progress = currentBudget > 0
                                    ? (spentAmount / currentBudget)
                                        .clamp(0.0, 1.0)
                                    : 0.0;

                                return ExpansionPanel(
                                  isExpanded:
                                      _focusedCategoryKey == categoryKey,
                                  canTapOnHeader: true,
                                  backgroundColor: colorScheme.onPrimary,
                                  headerBuilder: (context, _) {
                                    return ListTile(
                                      leading: Icon(icon, color: color),
                                      title: Text(categoryName,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          )),
                                      subtitle: Text(
                                        'Budget: RM ${currentBudget.toStringAsFixed(2)}',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    );
                                  },
                                  body: Padding(
                                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            backgroundColor:
                                                color.withOpacity(0.2),
                                            valueColor:
                                                AlwaysStoppedAnimation(color),
                                            minHeight: 10,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Adjust Budget (RM)',
                                          style: theme.textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Slider(
                                                value: currentBudget.clamp(0, 1000000),
                                                min: 0,
                                                max: currentBudget > 10000 ? currentBudget : 10000,
                                                divisions: 100,
                                                label: currentBudget
                                                    .toStringAsFixed(2),
                                                activeColor: color,
                                                onChanged: (value) {
                                                  setState(() {
                                                    controller.text = value
                                                        .toStringAsFixed(2);
                                                  });
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            SizedBox(
                                              width: 80,
                                              child: TextField(
                                                controller: controller,
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (value) {
                                                  final parsed = int.tryParse(value) ?? 0;

                                                  if (parsed > 10000) {
                                                    controller.text = '10000';
                                                    controller.selection = TextSelection.fromPosition(
                                                      TextPosition(offset: controller.text.length),
                                                    );
                                                  }

                                                  setState(() {});
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  isDense: true,
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
