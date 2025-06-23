import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tolak_tax/services/budget_service.dart';
import 'package:tolak_tax/utils/category_helper.dart';
import 'package:tolak_tax/widgets/budget_metric_row.dart';

class BudgetOverviewScreen extends StatefulWidget {
  final String initialFocusedCategoryKey;

  const BudgetOverviewScreen({
    super.key,
    required this.initialFocusedCategoryKey,
  });

  @override
  State<BudgetOverviewScreen> createState() => _BudgetOverviewScreenState();
}

class _BudgetOverviewScreenState extends State<BudgetOverviewScreen> {
  late String _focusedCategoryKey;
  late BudgetService? _budgetService;

  @override
  void initState() {
    super.initState();
    _focusedCategoryKey = widget.initialFocusedCategoryKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _budgetService = Provider.of<BudgetService?>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final budgetService = Provider.of<BudgetService?>(context, listen: false);
    final budgets = budgetService!.budgets;
    final _categoryKeys = budgets.keys.toList();

    final double totalBudget = budgets.values.fold(
      0.0,
          (double previousSum, Map<String, double> categoryBudgetData) {
        return previousSum + (categoryBudgetData['budget'] ?? 0.0);
      },
    );

    final double totalSpent = budgets.values.fold(
      0.0,
          (double previousSum, Map<String, double> categoryBudgetData) {
        return previousSum + (categoryBudgetData['spentAmount'] ?? 0.0);
      },
    );
    final double totalRemaining = totalBudget - totalSpent;
    final double totalProgress =
        (totalBudget > 0) ? totalSpent / totalBudget : 0;
    final bool isOverBudgetOverall = totalRemaining < 0;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 120,
              backgroundColor: theme.primaryColor,
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white,),
                  onPressed: () {
                    Navigator.pushNamed(context, 'budget-settings',
                    arguments: budgets);
                  },
                  tooltip: 'Edit Budgets',
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Budget Overview',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
                titlePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              foregroundColor: colorScheme.onPrimary,
            ),
            SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.background,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Overall Budget',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'RM ${totalRemaining.toStringAsFixed(2)}',
                                  style:
                                      theme.textTheme.headlineLarge?.copyWith(
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
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: totalProgress.clamp(0.0, 1.0),
                                    backgroundColor:
                                        colorScheme.primary.withOpacity(0.2),
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
                                      'Budget: RM ${totalBudget.toStringAsFixed(2)}',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ExpansionPanelList(
                            dividerColor: Colors.grey.withOpacity(0.4),
                            animationDuration:
                                const Duration(milliseconds: 500),
                            elevation: 0,
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                final tappedkey = _categoryKeys![index];
                                if (_focusedCategoryKey == tappedkey) {
                                  _focusedCategoryKey = '';
                                } else {
                                  _focusedCategoryKey = tappedkey;
                                }
                              });
                            },
                            children: _categoryKeys!
                                .map<ExpansionPanel>((categoryKey) {
                              final isFocused =
                                  _focusedCategoryKey == categoryKey;
                              final color =
                                  CategoryHelper.getCategoryColor(categoryKey);
                              final icon = CategoryHelper.getIcon(categoryKey);
                              final categoryName =
                                  CategoryHelper.getDisplayName(categoryKey);

                              final budgetData = budgets[categoryKey];

                              final budget = budgetData!['budget'] ?? 0.0;
                              final spentAmount = budgetData['spentAmount'] ?? 0.0;
                              final remainingBudget = budget - spentAmount;
                              final progressValue = spentAmount / budget;
                              final isOverBudget = progressValue > 1;

                              return ExpansionPanel(
                                isExpanded: isFocused,
                                canTapOnHeader: true,
                                backgroundColor: colorScheme.onPrimary,
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                      leading: Icon(icon, color: color),
                                      title: Text(
                                        categoryName,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: colorScheme.onBackground,
                                        ),
                                      ),
                                      trailing: Text(
                                        'RM ${spentAmount.toStringAsFixed(2)}',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: colorScheme.onBackground,
                                        ),
                                      ));
                                },
                                body: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: LinearProgressIndicator(
                                          value: progressValue.clamp(0.0, 1.0),
                                          backgroundColor:
                                              color.withOpacity(0.2),
                                          valueColor:
                                              AlwaysStoppedAnimation(color),
                                          minHeight: 10,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      BudgetMetricRow(context, 'Budget',
                                          'RM ${budget.toStringAsFixed(2)}'),
                                      const Divider(
                                        height: 16,
                                      ),
                                      BudgetMetricRow(context, 'Spent',
                                          'RM ${spentAmount.toStringAsFixed(2)}'),
                                      const Divider(
                                        height: 16,
                                      ),
                                      BudgetMetricRow(context, 'Remaining',
                                          'RM ${remainingBudget.toStringAsFixed(2)}'),
                                      const SizedBox(height: 16),
                                      if (isOverBudget)
                                        Text(
                                          'You have exceeded your budget for this category by RM${(remainingBudget * -1).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                    ],
                                  ),
                                ),
                              );
                            }).toList()),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
