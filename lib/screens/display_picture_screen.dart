import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:tolak_tax/services/api_service.dart';
import 'package:tolak_tax/models/receipt_model.dart';

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
      print('Response from readReceipt: $response');

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
    final ApiService apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Captured Picture'),
        actions: [
          TextButton(
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      Receipt? receipt = await confirmReadReceipt(
                          context, apiService, widget.imagePath);

                      if (receipt != null) {
                        Navigator.pushNamed(context, '/receipt-confirm',
                            arguments: {
                              'receiptImagePath': widget.imagePath,
                              'receiptData': receipt,
                            });
                      } else {
                        print("Failed to read receipt data");
                        // Show error message to user
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
              style: TextStyle(
                color: _isLoading ? Colors.grey : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Image.file(File(widget.imagePath)),
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
    );
  }
}
