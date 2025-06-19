import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:tolak_tax/widgets/date_range_selector.dart';
import 'package:tolak_tax/widgets/section_container.dart';
import '../data/category_constants.dart';

class GenerateReportScreen extends StatefulWidget {
  const GenerateReportScreen({super.key});

  @override
  State<GenerateReportScreen> createState() => _GenerateReportScreenState();
}

class _GenerateReportScreenState extends State<GenerateReportScreen> {
  int _currentStep = 0;
  DateTime? startDate;
  DateTime? endDate;
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'All';
  String _selectedReportType = 'Summary';
  String? _selectedFileType;

  final List<String> _categories = allCategories;
  final List<String> _reportTypes = ['Summary', 'Detailed', 'Custom'];

  final List<String> stepTitles = [
    'Select Report Criteria',
    'Review and Confirm',
    'Report Generated',
  ];

  void _onNext() {
    if (_currentStep == 0 && !_formKey.currentState!.validate()) return;
    setState(() {
      _currentStep = (_currentStep + 1).clamp(0, stepTitles.length - 1);
    });
  }

  void _onBack() {
    setState(() {
      _currentStep = (_currentStep - 1).clamp(0, stepTitles.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  surfaceTintColor: colorScheme.primary,
                  backgroundColor: colorScheme.primary,
                  expandedHeight: 170,
                  pinned: true,
                  stretch: true,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    title: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Row(
                        key: ValueKey<int>(_currentStep),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularStepProgressIndicator(
                            totalSteps: stepTitles.length,
                            currentStep: _currentStep + 1,
                            stepSize: 5,
                            selectedColor: colorScheme.onPrimary,
                            unselectedColor: colorScheme.onPrimary.withOpacity(0.4),
                            padding: 0,
                            width: 32,
                            height: 32,
                            roundedCap: (_, __) => true,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            stepTitles[_currentStep],
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                    background: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            BackButton(
                              color: colorScheme.onPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: true,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.background,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                        child: KeyedSubtree(
                          key: ValueKey<int>(_currentStep),
                          child: _buildStepContent(_currentStep, theme, colorScheme),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: colorScheme.background,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: _currentStep == 0 ? null : _onBack,
                  style: OutlinedButton.styleFrom(
                    textStyle: theme.textTheme.labelLarge,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: _currentStep == stepTitles.length - 1 ? null : _onNext,
                  style: ElevatedButton.styleFrom(
                    textStyle: theme.textTheme.labelLarge,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(_currentStep == 1 ? 'Confirm' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(int step, ThemeData theme, ColorScheme colorScheme) {
    switch (step) {
      case 0:
        return Column(
          key: const ValueKey(0),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 1: Choose Report Criteria',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SectionContainer(
              title: 'Report Type',
              child: Theme(
                data: Theme.of(context).copyWith(canvasColor: Colors.white),
                child: DropdownButtonFormField<String>(
                  value: _selectedReportType,
                  decoration: InputDecoration(
                    hintText: 'Select Report Type',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: _reportTypes
                      .map((type) => DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedReportType = value!;
                    });
                  },
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please select a report type' : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SectionContainer(
              title: 'Date Range',
              child: DateRangeSelector(
                onRangeSelected: (start, end) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        startDate = start;
                        endDate = end;
                      });
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            SectionContainer(
              title: 'Category',
              child: Theme(
                data: Theme.of(context).copyWith(canvasColor: Colors.white),
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    hintText: 'Select Category',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: _categories
                      .map((category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please select a category' : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SectionContainer(
              title: 'File Type',
              child: Theme(
                data: Theme.of(context).copyWith(canvasColor: Colors.white),
                child: DropdownButtonFormField<String>(
                  value: _selectedFileType,
                  decoration: InputDecoration(
                    hintText: 'Select File Type',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: ['PDF', 'CSV'].map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFileType = value!;
                    });
                  },
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please select a file type' : null,
                ),
              ),
            ),
          ],
        );

      case 1:
        return Column(
          key: const ValueKey(1),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 2: Review and Confirm',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
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
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.insert_drive_file, color: colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Report Type: $_selectedReportType',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.date_range, color: colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Date Range: ${startDate != null && endDate != null ? "${DateFormat.yMMMd().format(startDate!)} - ${DateFormat.yMMMd().format(endDate!)}" : "Not selected"}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.category, color: colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Category: $_selectedCategory',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.file_present, color: colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'File Type: $_selectedFileType',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );

      case 2:
        return Container(
          key: const ValueKey(2),
          alignment: Alignment.center,
          child: Text(
            'Show generated preview here',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}