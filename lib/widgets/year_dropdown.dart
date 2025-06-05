import 'package:flutter/material.dart';

class YearDropdown extends StatelessWidget {
  final int? selectedYear;
  final ValueChanged<int?> onChanged;

  const YearDropdown({
    super.key,
    required this.selectedYear,
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
        value: selectedYear,
        decoration: InputDecoration(
          labelText: 'Year',
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
        onChanged: onChanged,
      ),
    );
  }
}
