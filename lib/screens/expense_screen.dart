import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tolak_tax/utils/category_colour.dart';
import 'package:tolak_tax/widgets/summary_card.dart';

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
    {
      'title': 'Starbucks Coffee',
      'date': '2025-05-25',
      'amount': 12.50,
      'category': 'food'
    },
    {
      'title': 'Office Supplies',
      'date': '2025-05-23',
      'amount': 98.75,
      'category': 'shopping'
    },
    {
      'title': 'Electricity Bill',
      'date': '2025-05-20',
      'amount': 150.00,
      'category': 'utilities'
    },
    {
      'title': 'Netflix Subscription',
      'date': '2025-05-19',
      'amount': 17.00,
      'category': 'entertainment'
    },
    {
      'title': 'Grab Ride',
      'date': '2025-05-18',
      'amount': 9.30,
      'category': 'transport'
    },
    {
      'title': 'Lunch at Nando\'s',
      'date': '2025-05-17',
      'amount': 35.00,
      'category': 'food'
    },
    {
      'title': 'Shopee Purchase',
      'date': '2025-05-15',
      'amount': 65.90,
      'category': 'shopping'
    },
    {
      'title': 'Celcom Postpaid',
      'date': '2025-05-13',
      'amount': 89.00,
      'category': 'utilities'
    },
    {
      'title': 'Cinema Tickets',
      'date': '2025-05-12',
      'amount': 28.00,
      'category': 'entertainment'
    },
    {
      'title': 'Petrol',
      'date': '2025-05-10',
      'amount': 120.00,
      'category': 'transport'
    },
    {
      'title': 'Grocery Shopping',
      'date': '2025-05-08',
      'amount': 210.40,
      'category': 'food'
    },
    {
      'title': 'Spotify Family Plan',
      'date': '2025-05-05',
      'amount': 22.40,
      'category': 'entertainment'
    },
    {
      'title': 'Parking Fee',
      'date': '2025-05-04',
      'amount': 3.50,
      'category': 'transport'
    },
    {
      'title': 'Electric Kettle',
      'date': '2025-05-02',
      'amount': 79.99,
      'category': 'shopping'
    },
    {
      'title': 'Water Bill',
      'date': '2025-04-29',
      'amount': 30.60,
      'category': 'utilities'
    },
    {
      'title': 'Dinner at Sushi King',
      'date': '2025-04-28',
      'amount': 47.25,
      'category': 'food'
    },
    {
      'title': 'Bookstore',
      'date': '2025-04-27',
      'amount': 54.90,
      'category': 'shopping'
    },
  ];

  List<Map<String, dynamic>> get filteredReceipts {
    return receipts.where((receipt) {
      final title = (receipt['title'] ?? '').toString().toLowerCase();
      final category = (receipt['category'] ?? '').toString();
      final matchesSearch = searchText.isEmpty || title.contains(searchText.toLowerCase());
      final matchesCategory = selectedCategory == 'All' || selectedCategory == category;

      final date = DateTime.tryParse((receipt['date'] ?? '') as String);

      final matchesYear = selectedYear == null || (date != null && date.year == selectedYear);
      final matchesMonth = selectedMonth == null || (date != null && date.month == selectedMonth);

      return matchesSearch && matchesCategory && matchesYear && matchesMonth;
    }).toList();
  }



  List<String> getAllCategories() {
    final categories =
        receipts.map((r) => (r['category'] ?? '').toString()).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  double getTotalAmount(List<Map<String, dynamic>> data) {
    return data.fold(0.0, (sum, item) {
      final amount = double.tryParse(item['amount'].toString()) ?? 0.0;
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
                      // Total
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
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor: colorScheme.background,
                                    ),
                                    child: DropdownButtonFormField<int?>(
                                      isExpanded: true,
                                      value: selectedYear,
                                      decoration: InputDecoration(
                                        labelText: 'Year',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                      items: [
                                        DropdownMenuItem<int?>(
                                          value: null,
                                          child: Text('All Years'),
                                        ),
                                        ...List.generate(10, (index) {
                                          final year = DateTime.now().year - index;
                                          return DropdownMenuItem<int?>(
                                            value: year,
                                            child: Text(year.toString()),
                                          );
                                        }),
                                      ],
                                      onChanged: (val) {
                                        setState(() {
                                          selectedYear = val;
                                          if (val == null) {
                                            selectedMonth = null;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),

                                SizedBox(
                                  width: double.infinity,
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor: colorScheme.background,
                                    ),
                                    child: DropdownButtonFormField<int?>(
                                      isExpanded: true,
                                      value: selectedMonth,
                                      decoration: InputDecoration(
                                        labelText: 'Month',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                      items: [
                                        DropdownMenuItem<int?>(
                                          value: null,
                                          child: Text('All Months'),
                                        ),
                                        ...List.generate(12, (index) {
                                          final month = index + 1;
                                          final monthName = DateFormat.MMMM().format(DateTime(0, month));
                                          return DropdownMenuItem<int?>(
                                            value: month,
                                            child: Text(monthName),
                                          );
                                        }),
                                      ],
                                      onChanged: selectedYear == null
                                          ? null
                                          : (val) {
                                        setState(() => selectedMonth = val);
                                      },
                                      disabledHint: Text('Select Year first'),
                                    ),
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
                          items: getAllCategories().map((cat) {
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
                          final category =
                              (receipt['category'] ?? '') as String;
                          final categoryColor = getCategoryColor(category);
                          final date = DateTime.tryParse(receipt['date'] ?? '');
                          final formattedDate = date != null
                              ? DateFormat.yMMMd().format(date)
                              : receipt['date'] ?? '';

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.receipt, color: categoryColor),
                            title: Text(
                              receipt['title'] ?? '',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            subtitle: Text(
                              formattedDate,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            trailing: Text(
                              'RM ${receipt['amount'].toString()}',
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
