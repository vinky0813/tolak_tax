import 'package:flutter/material.dart';

class DateRangeSelector extends StatefulWidget {
  final Function(DateTime start, DateTime end) onRangeSelected;

  const DateRangeSelector({super.key, required this.onRangeSelected});

  @override
  State<DateRangeSelector> createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  String selectedPreset = 'Last Month';
  DateTime? customStartDate;
  DateTime? customEndDate;

  void _setDateRange(DateTime start, DateTime end) {
    widget.onRangeSelected(start, end);
  }

  void _applyPreset(String preset) {
    final now = DateTime.now();
    late DateTime start;
    late DateTime end;

    if (preset != 'Custom') {
      switch (preset) {
        case 'Last Month':
          start = DateTime(now.year, now.month - 1, 1);
          end = DateTime(now.year, now.month, 0);
          break;
        case 'Last Quarter':
          final currentQuarter = ((now.month - 1) ~/ 3) + 1;
          final startMonth = (currentQuarter - 2) * 3 + 1;
          final year = startMonth <= 0 ? now.year - 1 : now.year;
          final sm = startMonth <= 0 ? 12 + startMonth : startMonth;
          start = DateTime(year, sm, 1);
          end = DateTime(now.year, currentQuarter * 3 - 3 + 1, 0);
          break;
        case 'Year-to-Date':
          start = DateTime(now.year, 1, 1);
          end = now;
          break;
      }
      _setDateRange(start, end);
    }

    setState(() {
      selectedPreset = preset;
    });
  }

  Future<void> _selectDate({required bool isStart}) async {
    final now = DateTime.now();
    final initialDate = isStart ? customStartDate ?? now : customEndDate ?? now;

    final picked = await showGeneralDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Select Date",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: ScaleTransition(
            scale:
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            child: Center(
              child: Material(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 350,
                  child: CalendarDatePicker(
                    initialDate: initialDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    onDateChanged: (picked) {
                      Navigator.of(context).pop(picked);
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          customStartDate = picked;
        } else {
          customEndDate = picked;
        }

        if (customStartDate != null && customEndDate != null) {
          _setDateRange(customStartDate!, customEndDate!);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _applyPreset('Last Month');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            canvasColor: colorScheme.surface,
          ),
          child: DropdownButtonFormField<String>(
            value: selectedPreset,
            items: const [
              DropdownMenuItem(value: 'Last Month', child: Text('Last Month')),
              DropdownMenuItem(
                  value: 'Last Quarter', child: Text('Last Quarter')),
              DropdownMenuItem(
                  value: 'Year-to-Date', child: Text('Year-to-Date')),
              DropdownMenuItem(value: 'Custom', child: Text('Custom')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _applyPreset(value);
                });
              }
            },
            decoration: InputDecoration(
              labelText: 'Select Date Range',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: selectedPreset == 'Custom'
              ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(isStart: true),
                            child: AbsorbPointer(
                              child: TextFormField(
                                style: Theme.of(context).textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  labelText: 'Start Date',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.calendar_today,
                                        color: colorScheme.primary),
                                    onPressed: () => _selectDate(isStart: true),
                                  ),
                                ),
                                controller: TextEditingController(
                                  text: customStartDate != null
                                      ? _formatDate(customStartDate!)
                                      : '',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(isStart: false),
                            child: AbsorbPointer(
                              child: TextFormField(
                                style: Theme.of(context).textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  labelText: 'End Date',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.calendar_today,
                                        color: colorScheme.primary),
                                    onPressed: () =>
                                        _selectDate(isStart: false),
                                  ),
                                ),
                                controller: TextEditingController(
                                  text: customEndDate != null
                                      ? _formatDate(customEndDate!)
                                      : '',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
