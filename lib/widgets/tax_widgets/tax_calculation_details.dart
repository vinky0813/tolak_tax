import 'package:flutter/material.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/widgets/receipt_item.dart';

class TaxCalculationDetails extends StatelessWidget {
  final Receipt receipt;

  const TaxCalculationDetails({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildTaxCalculationDetails(),
    );
  }

  List<Widget> _buildTaxCalculationDetails() {
    final subtotal = receipt.lineItems.fold(
        0.0,
        (sum, item) =>
            sum + (item.totalPrice - (item.taxLine?.taxAmount ?? 0.0)));
    final taxAmount = receipt.lineItems
        .where((item) => item.taxLine != null)
        .fold(0.0, (sum, item) => sum + (item.taxLine?.taxAmount ?? 0.0));
    final total =
        receipt.lineItems.fold(0.0, (sum, item) => sum + item.totalPrice);

    return [
      ReceiptItem(
        icon: Icons.receipt_long,
        label: "Subtotal (Before Tax)",
        value: 'RM ${subtotal.toStringAsFixed(2)}',
      ),
      if (receipt.overallDiscounts != null &&
          receipt.overallDiscounts!.isNotEmpty)
        ...receipt.overallDiscounts!.map((discount) => ReceiptItem(
              icon: Icons.discount,
              label: "Discount: ${discount.description}",
              value: '-RM ${discount.amount.toStringAsFixed(2)}',
            )),
      const Divider(height: 16),
      ReceiptItem(
        icon: Icons.calculate,
        label: "Tax Applied",
        value: 'RM ${taxAmount.toStringAsFixed(2)}',
      ),
      ReceiptItem(
        icon: Icons.percent,
        label: "Effective Tax Rate",
        value:
            '${subtotal > 0 ? (taxAmount / subtotal * 100).toStringAsFixed(2) : '0.00'}%',
      ),
      const Divider(height: 16),
      ReceiptItem(
        icon: Icons.attach_money,
        label: "Final Total",
        value: 'RM ${total.toStringAsFixed(2)}',
      ),
    ];
  }
}
