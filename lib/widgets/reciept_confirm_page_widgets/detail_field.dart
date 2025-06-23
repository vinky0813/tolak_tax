import 'package:flutter/material.dart';
import 'package:tolak_tax/data/category_constants.dart';

class DetailField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool isRequired;
  final bool isEditing;
  final bool isAmount;
  final bool isTotal;
  final bool isCategoryDropdown;

  const DetailField({
    Key? key,
    required this.label,
    required this.controller,
    required this.icon,
    this.isRequired = false,
    required this.isEditing,
    this.isAmount = false,
    this.isTotal = false,
    this.isCategoryDropdown = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      if (isCategoryDropdown) {
        return _buildCategoryDropdownField(context);
      } else {
        return _buildEditableField(context);
      }
    } else {
      return _buildReadOnlyField(context);
    }
  }

  Widget _buildCategoryDropdownField(BuildContext context) {
    final theme = Theme.of(context);
    final dropdownCategories =
    allCategories.where((category) => category != 'All').toList();

    String? currentValue = controller.text;
    if (currentValue.isEmpty || !dropdownCategories.contains(currentValue)) {
      currentValue = null;
    }

    return DropdownButtonFormField<String>(
      value: currentValue,
      items: dropdownCategories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          controller.text = newValue;
        }
      },
      decoration: InputDecoration(
        labelText: label + (isRequired ? ' *' : ''),
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Please select a category';
        }
        return null;
      },
      hint: Text('Select $label'),
    );
  }

  Widget _buildEditableField(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label + (isRequired ? ' *' : ''),
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        prefixText: isAmount ? '\$ ' : null,
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
      keyboardType: isAmount
          ? const TextInputType.numberWithOptions(decimal: true)
          : null,
    );
  }

  Widget _buildReadOnlyField(BuildContext context) {
    final theme = Theme.of(context);
    final displayValue = isAmount && controller.text.isNotEmpty
        ? '\$${controller.text}'
        : controller.text;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isTotal
            ? theme.colorScheme.primaryContainer.withOpacity(0.3)
            : theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isTotal
              ? theme.colorScheme.primary.withOpacity(0.5)
              : theme.dividerColor,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isTotal
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.7),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label + (isRequired ? ' *' : ''),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  displayValue.isEmpty ? 'Not provided' : displayValue,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                    color: displayValue.isEmpty
                        ? theme.colorScheme.onSurface.withOpacity(0.5)
                        : (isTotal ? theme.colorScheme.primary : null),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
