import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/utils/category_helper.dart';
import 'package:tolak_tax/data/category_constants.dart';
import 'package:tolak_tax/widgets/month_dropdown.dart';
import 'package:tolak_tax/widgets/summary_card.dart';
import 'package:tolak_tax/widgets/year_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:tolak_tax/services/receipt_service.dart';
import '../data/dummy_receipt_data.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  String searchText = '';
  String selectedCategory = 'All';
  final TextEditingController searchController = TextEditingController();
  int? selectedMonth;
  int? selectedYear = DateTime.now().year;

  List<Receipt> getFilteredReceipts(receipts) {
    return receipts.where((receipt) {
      final title = (receipt.merchantName).toString().toLowerCase();
      final category = (receipt.expenseCategory).toString();
      final matchesSearch =
          searchText.isEmpty || title.contains(searchText.toLowerCase());
      final matchesCategory =
          selectedCategory == 'All' || selectedCategory == category;

      final date = DateTime.parse(receipt.transactionDatetime);

      final matchesYear = selectedYear == null || (date.year == selectedYear);
      final matchesMonth =
          selectedMonth == null || (date.month == selectedMonth);

      return matchesSearch && matchesCategory && matchesYear && matchesMonth;
    }).toList();
  }

  double getTotalAmount(List<Receipt> data) {
    return data.fold(0.0, (sum, item) {
      final amount = double.tryParse(item.totalAmount.toString()) ?? 0.0;
      return sum + amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final receiptService = Provider.of<ReceiptService?>(context, listen: true);

    final receipts = receiptService?.getCachedReceipts() ?? [];
    final filteredReceipts = getFilteredReceipts(receipts);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalAmount = getTotalAmount(filteredReceipts);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 120,
              backgroundColor: theme.primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Receipts',
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
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.50,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 12,
                              children: [
                                SummaryCard(
                                  width: 80,
                                  icon: Icons.receipt_long,
                                  label: 'Total Receipts',
                                  value: filteredReceipts.length.toString(),
                                  color: colorScheme.primary,
                                ),
                                SummaryCard(
                                  width: 80,
                                  icon: Icons.attach_money,
                                  label: 'Total Amount',
                                  value: 'RM ${totalAmount.toStringAsFixed(2)}',
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: YearDropdown(
                                    selectedYear: selectedYear,
                                    onChanged: (val) {
                                      setState(() {
                                        selectedYear = val;
                                        if (val == null) selectedMonth = null;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: MonthDropdown(
                                    selectedYear: selectedYear,
                                    selectedMonth: selectedMonth,
                                    onChanged: (val) {
                                      setState(() => selectedMonth = val);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Search Bar
                      TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() => searchText = value);
                          getFilteredReceipts(receipts);
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Search receipts',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Dropdown
                      Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: colorScheme.surface,
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedCategory,
                          isExpanded: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: allCategories.map((cat) {
                            return DropdownMenuItem(
                                value: cat, child: Text(cat));
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => selectedCategory = value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (filteredReceipts.isEmpty)
                        Text(
                          'No receipts found.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        )
                      else
                        ...filteredReceipts.map((receipt) {
                          final category = (receipt.expenseCategory);
                          final categoryColor =
                              CategoryHelper.getCategoryColor(category);
                          final categoryIcon = CategoryHelper.getIcon(category);
                          final date =
                              DateTime.parse(receipt.transactionDatetime);
                          final formattedDate = date != null
                              ? DateFormat.yMMMd().format(date)
                              : receipt.transactionDatetime;

                          return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(categoryIcon, color: categoryColor),
                              title: Text(
                                receipt.merchantName,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                formattedDate.toString(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              trailing: Text(
                                'RM ${receipt.totalAmount.toStringAsFixed(2)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/receipt-details',
                                  arguments: receipt,
                                );
                              });
                        }),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
