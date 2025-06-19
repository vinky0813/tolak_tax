import 'package:flutter/material.dart';
import 'package:tolak_tax/widgets/reciept_confirm_page_widgets/detail_field.dart';

class MerchantInfoCard extends StatefulWidget {
  final TextEditingController merchantNameController;
  final TextEditingController merchantAddressController;
  final bool isEditing;

  const MerchantInfoCard({
    Key? key,
    required this.merchantNameController,
    required this.merchantAddressController,
    required this.isEditing,
  }) : super(key: key);
  @override
  State<MerchantInfoCard> createState() => _MerchantInfoCardState();
}

class _MerchantInfoCardState extends State<MerchantInfoCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.store,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Merchant Information',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              DetailField(
                label: 'Merchant Name',
                controller: widget.merchantNameController,
                icon: Icons.store,
                isRequired: true,
                isEditing: widget.isEditing,
              ),
              const SizedBox(height: 12),
              DetailField(
                label: 'Merchant Address',
                controller: widget.merchantAddressController,
                icon: Icons.location_on,
                isEditing: widget.isEditing,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
