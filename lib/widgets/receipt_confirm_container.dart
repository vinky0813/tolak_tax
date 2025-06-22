import 'package:flutter/material.dart';

class ReceiptConfirmContainer extends StatelessWidget {
  final Widget header;
  final Widget child;

  const ReceiptConfirmContainer({
    super.key,
    required this.header,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: header
      ),
    );
  }
}