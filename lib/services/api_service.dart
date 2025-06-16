import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final apiUrl = '10.0.2.2:8000';

  Future<String?> getIdToken(BuildContext context) async {
    final String? token =
        await Provider.of<AuthService>(context, listen: false).getIdToken();
    return token;
  }

  Future<String> getUserReciepts(String? idToken) async {
    var url =
        Uri.http(apiUrl, '/get-receipts-by-user/', {'id_token': idToken ?? ''});

    var response = await http.get(url);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> uploadReceipt(String? idToken, String imagePath) async {
    if (idToken == null || idToken.isEmpty) {
      throw Exception('ID token is required to add a receipt.');
    }

    // Send id_token as a query parameter
    var url = Uri.http(apiUrl, '/add-receipt/');
    var request = http.MultipartRequest('POST', url);

    var multipartFile = await http.MultipartFile.fromPath('file', imagePath);
    request.files.add(multipartFile);

    try {
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print(responseBody);
    } catch (e) {
      throw Exception('Error sending request to add receipt: $e');
    }
  }
}
