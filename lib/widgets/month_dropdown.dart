import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthDropdown extends StatelessWidget {
  final int? selectedYear;
  final int? selectedMonth;
  final ValueChanged<int?> onChanged;

  const MonthDropdown({
    super.key,
    required this.selectedYear,
    required this.selectedMonth,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: colorScheme.surface,
      ),
      child: DropdownButtonFormField<int?>(
        isExpanded: true,
        value: selectedMonth,
        decoration: InputDecoration(
          labelText: 'Month',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        items: [
          const DropdownMenuItem<int?>(
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
        onChanged: selectedYear == null ? null : onChanged,
        disabledHint: const Text('Select Year first'),
      ),
    );
  }
}
