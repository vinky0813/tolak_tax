import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tolak_tax/services/api_service.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  Future<void> confirmUploadReceipts(
      BuildContext context, ApiService apiService, String imagePath) async {
    try {
      final String? idToken = await apiService.getIdToken(context);

      if (idToken == null || idToken.isEmpty) {
        print('Error: Could not retrieve ID token.');
        return;
      }

      final String response =
          await apiService.uploadReceipt(idToken, imagePath);

      print(response);
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  const DisplayPictureScreen({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();
    final Future<String?> idToken = apiService.getIdToken(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Captured Picture'),
          actions: [
            TextButton(
              onPressed: () {
                confirmUploadReceipts(context, apiService, imagePath);
              },
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: Image.file(File(imagePath)),
        ));
  }
}
