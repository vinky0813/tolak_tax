import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget  ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: IconButton(
          icon: Icon(Icons.arrow_back,
              color: theme.colorScheme.primary, size: 28),
          onPressed: () => Navigator.pop(context),
          tooltip: "Back",
        ),
      ),
    );
  }
}
