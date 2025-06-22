import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tolak_tax/data/dummy_receipt_data.dart';
import 'package:tolak_tax/models/achievement_model.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/services/achievement_service.dart';
import 'package:tolak_tax/services/auth_service.dart';
import 'package:tolak_tax/data/category_constants.dart';
import 'package:tolak_tax/utils/category_helper.dart';
import 'package:tolak_tax/widgets/achivement_banner.dart';
import 'package:tolak_tax/widgets/cached_network_svg.dart';
import 'package:tolak_tax/widgets/gamified_progress.dart';
import 'package:tolak_tax/widgets/quick_actionbutton.dart';
import 'package:tolak_tax/widgets/recent_receipts_list.dart';
import 'package:tolak_tax/widgets/section_container.dart';
import 'package:tolak_tax/widgets/summary_card.dart';
import 'package:tolak_tax/widgets/weekly_barchart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tolak_tax/data/dummy_receipt_data.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Map<String, double> _budgets;
  late Map<String, double> _spentAmounts;

  final List<String> _displayCategories =
      allCategories.where((c) => c != 'All').toList();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPendingAchievementBanners();
    });

    _budgets = {
      'food': 500.0,
      'shopping': 300.0,
      'utilities': 400.0,
      'entertainment': 150.0,
      'transport': 200.0,
    };

    _spentAmounts = {
      'food': 285.50,
      'shopping': 310.75,
      'utilities': 150.0,
      'entertainment': 95.20,
      'transport': 120.0,
    };
  }

  void _showPendingAchievementBanners() {
    final achievementService = context.read<AchievementService?>();
    if (achievementService == null) return;

    final achievementsToShow = achievementService.newlyUnlocked;

    if (achievementsToShow.isNotEmpty) {
      for (final achievement in achievementsToShow) {
        AchievementBanner.show(achievement);
      }
      achievementService.clearNewlyUnlocked();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = Provider.of<AuthService>(context).currentUser;
    final String? photoUrl = user?.photoURL;
    final bool hasAvatar = photoUrl != null && photoUrl.isNotEmpty;
    final List<Receipt> dummyReceipts = dummyReceiptsData;

    // Dummy data for demo
    final int totalReceipts = dummyReceipts.length;
    final double totalExpenses =
        dummyReceipts.fold(0.0, (sum, receipt) => sum + receipt.totalAmount);
    final double totalTax = dummyReceipts.fold(
        0.0, (sum, receipt) => sum + (receipt.taxAmount ?? 0.0));
    const double taxDue = 40.00;

    final recentReceipts = dummyReceipts;

    final userName = Provider.of<AuthService>(context).currentUser?.displayName;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 260,
              backgroundColor: colorScheme.primary,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, right: 10),
                  child: IconButton(
                    icon: const Icon(Icons.settings),
                    color: colorScheme.onPrimary,
                    onPressed: () {
                      // handle go to settings
                      print("Settings button tapped");
                    },
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: colorScheme.primary,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: hasAvatar
                                  ? ClipOval(
                                      child: CachedNetworkSvg(
                                        url: photoUrl,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            const CircularProgressIndicator
                                                .adaptive(),
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      color: colorScheme.primary,
                                    ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome!',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  userName?.isNotEmpty == true
                                      ? userName!
                                      : 'No name',
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        WeeklyBarChart(
                          receipts: recentReceipts,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Summary Cards
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 12,
                          children: [
                            SummaryCard(
                                width: 70,
                                icon: Icons.receipt_long,
                                label: 'Receipts',
                                value: totalReceipts.toString(),
                                color: colorScheme.primary),
                            SummaryCard(
                                width: 70,
                                icon: Icons.money_off,
                                label: 'Expenses',
                                value: 'RM ${totalExpenses.toStringAsFixed(2)}',
                                color: Colors.redAccent),
                            SummaryCard(
                                width: 70,
                                icon: Icons.calculate,
                                label: 'Tax Calculated',
                                value: 'RM ${totalTax.toStringAsFixed(2)}',
                                color: Colors.green),
                            SummaryCard(
                                width: 70,
                                icon: Icons.attach_money,
                                label: 'Tax Due',
                                value: 'RM ${taxDue.toStringAsFixed(2)}',
                                color: Colors.orange),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      SectionContainer(
                        title: 'Quick Actions',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            QuickActionButton(
                              icon: Icons.camera_alt,
                              label: 'Scan Receipt',
                              onPressed: () {
                                // TODO: Add scan logic
                              },
                            ),
                            QuickActionButton(
                              icon: Icons.receipt,
                              label: 'View Receipts',
                              onPressed: () {
                                // TODO: Navigate to receipts list
                              },
                            ),
                            QuickActionButton(
                              icon: Icons.calculate,
                              label: 'Generate Report',
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/generate-report');
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      CarouselSlider.builder(
                          itemCount: _displayCategories.length,
                          itemBuilder: (context, index, realIndex) {
                            final category = _displayCategories[index];
                            final budget = _budgets[category] ?? 0.0;
                            final spent = _spentAmounts[category] ?? 0.0;
                            final icon = CategoryHelper.getIcon(category);
                            final label =
                                CategoryHelper.getDisplayName(category);
                            final color =
                                CategoryHelper.getCategoryColor(category);

                            return GamifiedProgress(
                              label: label,
                              icon: icon,
                              budget: budget,
                              spent: spent,
                              color: color,
                              onTap: () {
                                Navigator.pushNamed(context, '/budget-overview',
                                    arguments: {
                                      'initialFocusedCategoryKey': category,
                                      'budgets': _budgets,
                                      'spentAmounts': _spentAmounts,
                                    });
                              },
                            );
                          },
                          options: CarouselOptions(
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 5),
                            enlargeCenterPage: true,
                            viewportFraction: 0.85,
                            height: 170,
                          )),

                      const SizedBox(height: 20),

                      // Recent Receipts List Section
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: RecentReceiptsList(
                          receipts: recentReceipts,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
