import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:tolak_tax/services/api_service.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/widgets/section_container.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  bool _isLoading = false;

  Future<Receipt?> confirmReadReceipt(
      BuildContext context, ApiService apiService, String imagePath) async {
    try {
      final String? idToken = await apiService.getIdToken(context);

      if (idToken == null || idToken.isEmpty) {
        print('Error: Could not retrieve ID token.');
        return null;
      }

      final String response = await apiService.readReceipt(imagePath);

      // Parse the JSON string response
      final Map<String, dynamic> receiptData = jsonDecode(response);

      // Create Receipt object from the parsed data
      final Receipt receipt = Receipt.fromMap(receiptData);

      return receipt;
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ApiService apiService = ApiService();

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: colorScheme.onPrimary),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  final receipt = await confirmReadReceipt(
                                      context, apiService, widget.imagePath);

                                  print("receipt : $receipt");

                                  if (receipt != null) {
                                    Navigator.pushNamed(
                                      context,
                                      '/receipt-confirm',
                                      arguments: {
                                        'receiptImagePath': widget.imagePath,
                                        'receiptData': receipt,
                                      },
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Failed to read receipt. Please try again.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } finally {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                        child: Text(
                          'Confirm',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: _isLoading
                                ? Colors.grey
                                : colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: SectionContainer(
                      title: 'Confirm Captured Receipt',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(widget.imagePath),
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
