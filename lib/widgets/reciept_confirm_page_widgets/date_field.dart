import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEditing;

  const DateField({
    Key? key,
    required this.controller,
    required this.isEditing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return _buildEditableDateField(context);
    } else {
      return _buildReadOnlyDateField(context);
    }
  }

  Widget _buildEditableDateField(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Date *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.calendar_today),
        hintText: 'YYYY-MM-DD',
        filled: true,
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          controller.text = picked.toString().split(' ')[0];
        }
      },
    );
  }

  Widget _buildReadOnlyDateField(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date *',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.text.isEmpty ? 'Not provided' : controller.text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: controller.text.isEmpty
                        ? theme.colorScheme.onSurface.withOpacity(0.5)
                        : null,
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
