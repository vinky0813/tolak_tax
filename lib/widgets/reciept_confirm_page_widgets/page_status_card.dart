import 'package:flutter/material.dart';

class PageStatusCard extends StatefulWidget {
  final bool initialEditMode;

  const PageStatusCard(
    bool isEditing, {
    Key? key,
    this.initialEditMode = false,
  }) : super(key: key);

  @override
  State<PageStatusCard> createState() => _PageStatusCardState();
}

class _PageStatusCardState extends State<PageStatusCard> {
  late bool isEditing;

  @override
  void initState() {
    super.initState();
    isEditing = widget.initialEditMode;
  }

  void toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              isEditing ? Icons.edit : Icons.verified,
              color: isEditing ? theme.colorScheme.primary : Colors.green,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEditing ? 'Edit Mode' : 'Review Mode',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isEditing
                        ? 'You can now edit the receipt details below'
                        : 'Please verify all receipt details are correct',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
