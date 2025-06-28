import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tolak_tax/data/dummy_receipt_data.dart';
import 'package:tolak_tax/services/achievement_service.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/services/auth_service.dart';
import 'package:tolak_tax/data/category_constants.dart';
import 'package:tolak_tax/services/budget_service.dart';
import 'package:tolak_tax/services/receipt_service.dart';
import 'package:tolak_tax/utils/category_helper.dart';
import 'package:tolak_tax/widgets/budget_alert_banner.dart';
import 'package:tolak_tax/widgets/achivement_banner.dart';
import 'package:tolak_tax/widgets/cached_network_svg.dart';
import 'package:tolak_tax/widgets/gamified_progress.dart';
import 'package:tolak_tax/widgets/quick_actionbutton.dart';
import 'package:tolak_tax/widgets/recent_receipts_list.dart';
import 'package:tolak_tax/widgets/section_container.dart';
import 'package:tolak_tax/widgets/summary_card.dart';
import 'package:tolak_tax/widgets/weekly_barchart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tolak_tax/widgets/bottom_scanned_file_sheet.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> _displayCategories =
      allCategories.where((c) => c != 'All').toList();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPendingAchievementBanners();
      _showPendingBudgetAlerts();
    });
  }

  void _showPendingBudgetAlerts() {
    Future.delayed(Duration.zero, () {
      if (!mounted) return;

      final budgetService = context.read<BudgetService?>();
      if (budgetService == null) return;

      final categoriesToShow = budgetService.newlyOverBudgetCategories;

      if (categoriesToShow.isNotEmpty) {
        for (final categoryName in categoriesToShow) {
          BudgetAlertBanner.show(context, categoryName);
        }
        budgetService.clearNewlyOverBudgetCategories();
      }
    });
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
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    final String? photoUrl = user?.photoURL;
    final receiptService = Provider.of<ReceiptService>(context, listen: true);
    final bool hasAvatar = photoUrl != null && photoUrl.isNotEmpty;
    final List<Receipt> dummyReceipts = dummyReceiptsData;
    final achievementService = context.watch<AchievementService?>();
    final streakCount = achievementService?.currentScanStreak ?? 0;
    final budgetService = Provider.of<BudgetService?>(context);
    final _budgets = budgetService?.budgets ?? {};

    // Dummy data for demo
    final int totalReceipts = receiptService.getCachedReceiptsCount();
    final double totalExpenses = receiptService.getTotalAmountSpent();
    final double totalTax =
        receiptService.getYearlyTaxData(DateTime.now().year)['totalTaxSaved'];

    final recentReceipts = receiptService.getRecentReceipts();

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
                                icon: Icons.local_fire_department,
                                label: 'Scan Streak',
                                value:
                                    '$streakCount ${streakCount == 1 ? "day" : "days"}',
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
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const BottomScannedFileSheet();
                                    });
                              },
                            ),
                            QuickActionButton(
                              icon: Icons.receipt,
                              label: 'View Receipts',
                              onPressed: () {
                                Navigator.pushNamed(context, '/expense-screen');
                              },
                            ),
                            QuickActionButton(
                              icon: Icons.calculate,
                              label: 'Tax Report',
                              onPressed: () {
                                Navigator.pushNamed(context, '/tax-report');
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

                            final Map<String, double>?
                                categorySpecificBudgetData = _budgets[category];

                            final double budget =
                                categorySpecificBudgetData?['budget'] ?? 0.0;
                            final double spent =
                                categorySpecificBudgetData?['spentAmount'] ??
                                    0.0;

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
