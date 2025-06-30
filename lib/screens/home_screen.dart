import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tolak_tax/screens/dashboard_screen.dart';
import 'package:tolak_tax/screens/expense_screen.dart';
import 'package:tolak_tax/screens/profile_screen.dart';
import 'package:tolak_tax/screens/reports_screen.dart';
import 'package:tolak_tax/widgets/bottom_scanned_file_sheet.dart';
import 'package:tolak_tax/services/receipt_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ExpenseScreen(),
    ReportsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onScannerPressed() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const BottomScannedFileSheet();
        });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final receiptService = Provider.of<ReceiptService?>(context, listen: true);

    // Initialize receipts if not already done and user is logged in
    if (receiptService != null &&
        !receiptService.hasInitialized &&
        !receiptService.isLoading) {
      // Use a post-frame callback to avoid calling during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        receiptService.initialize();
      });
    }

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: _screens,
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 10,
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: FloatingActionButton(
              onPressed: _onScannerPressed,
              backgroundColor: theme.primaryColor,
              heroTag: "ScannerButton",
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.onPrimary,
        elevation: 8,
        child: SizedBox(
          height: 30.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.dashboard,
                  color: _selectedIndex == 0
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.list_alt,
                  color: _selectedIndex == 1
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                onPressed: () => _onItemTapped(1),
              ),
              const SizedBox(width: 48),
              IconButton(
                icon: Icon(
                  Icons.bar_chart,
                  color: _selectedIndex == 2
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                onPressed: () => _onItemTapped(2),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _selectedIndex == 3
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                onPressed: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
