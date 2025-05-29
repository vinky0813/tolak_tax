import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/utils/category_colour.dart';
import 'package:tolak_tax/utils/category_constants.dart';
import 'package:tolak_tax/widgets/month_dropdown.dart';
import 'package:tolak_tax/widgets/summary_card.dart';
import 'package:tolak_tax/widgets/year_dropdown.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  String searchText = '';
  String selectedCategory = 'All';
  final TextEditingController searchController = TextEditingController();
  int? selectedMonth = null;
  int? selectedYear = DateTime.now().year;

  final receipts = [
    Receipt.fromMap({
      'title': 'Starbucks Coffee',
      'date': '2025-05-25',
      'amount': 12.50,
      'category': 'food'
    }),
    Receipt.fromMap({
      'title': 'Office Supplies',
      'date': '2025-05-23',
      'amount': 98.75,
      'category': 'shopping'
    }),
    Receipt.fromMap({
      'title': 'Electricity Bill',
      'date': '2025-05-20',
      'amount': 150.00,
      'category': 'utilities'
    }),
    Receipt.fromMap({
      'title': 'Netflix Subscription',
      'date': '2025-05-19',
      'amount': 17.00,
      'category': 'entertainment'
    }),
    Receipt.fromMap({
      'title': 'Grab Ride',
      'date': '2025-05-18',
      'amount': 9.30,
      'category': 'transport'
    }),
    Receipt.fromMap({
      'title': 'Lunch at Nando\'s',
      'date': '2025-05-17',
      'amount': 35.00,
      'category': 'food'
    }),
    Receipt.fromMap({
      'title': 'Shopee Purchase',
      'date': '2025-05-15',
      'amount': 65.90,
      'category': 'shopping'
    }),
    Receipt.fromMap({
      'title': 'Celcom Postpaid',
      'date': '2025-05-13',
      'amount': 89.00,
      'category': 'utilities'
    }),
    Receipt.fromMap({
      'title': 'Cinema Tickets',
      'date': '2025-05-12',
      'amount': 28.00,
      'category': 'entertainment'
    }),
    Receipt.fromMap({
      'title': 'Petrol',
      'date': '2025-05-10',
      'amount': 120.00,
      'category': 'transport'
    }),
    Receipt.fromMap({
      'title': 'Grocery Shopping',
      'date': '2025-05-08',
      'amount': 210.40,
      'category': 'food'
    }),
    Receipt.fromMap({
      'title': 'Spotify Family Plan',
      'date': '2025-05-05',
      'amount': 22.40,
      'category': 'entertainment'
    }),
    Receipt.fromMap({
      'title': 'Parking Fee',
      'date': '2025-05-04',
      'amount': 3.50,
      'category': 'transport'
    }),
    Receipt.fromMap({
      'title': 'Electric Kettle',
      'date': '2025-05-02',
      'amount': 79.99,
      'category': 'shopping'
    }),
    Receipt.fromMap({
      'title': 'Water Bill',
      'date': '2025-04-29',
      'amount': 30.60,
      'category': 'utilities'
    }),
    Receipt.fromMap({
      'title': 'Dinner at Sushi King',
      'date': '2025-04-28',
      'amount': 47.25,
      'category': 'food'
    }),
    Receipt.fromMap({
      'title': 'Bookstore',
      'date': '2025-04-27',
      'amount': 54.90,
      'category': 'shopping'
    }),
  ];

  List<Receipt> get filteredReceipts {
    return receipts.where((receipt) {
      final title = (receipt.title).toString().toLowerCase();
      final category = (receipt.category).toString();
      final matchesSearch =
          searchText.isEmpty || title.contains(searchText.toLowerCase());
      final matchesCategory =
          selectedCategory == 'All' || selectedCategory == category;

      final date = receipt.date;

      final matchesYear =
          selectedYear == null || (date.year == selectedYear);
      final matchesMonth = selectedMonth == null ||
          (date.month == selectedMonth);

      return matchesSearch && matchesCategory && matchesYear && matchesMonth;
    }).toList();
  }

  double getTotalAmount(List<Receipt> data) {
    return data.fold(0.0, (sum, item) {
      final amount = double.tryParse(item.amount.toString()) ?? 0.0;
      return sum + amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalAmount = getTotalAmount(filteredReceipts);

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
                    color: colorScheme.background,
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
                        onChanged: (value) =>
                            setState(() => searchText = value),
                        decoration: InputDecoration(
                          hintText: 'Search receipts',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: colorScheme.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Dropdown
                      Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: colorScheme.background,
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedCategory,
                          isExpanded: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: colorScheme.background,
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
                          final category = (receipt.category);
                          final categoryColor = getCategoryColor(category);
                          final date = receipt.date;
                          final formattedDate = date != null
                              ? DateFormat.yMMMd().format(date)
                              : receipt.date;

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.receipt, color: categoryColor),
                            title: Text(
                              receipt.title,
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
                              'RM ${receipt.amount.toString()}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
