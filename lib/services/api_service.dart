import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tolak_tax/models/achievement_model.dart';
import '../data/category_constants.dart';
import 'auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  //final apiUrl = 'tolaktaxapi-291467312481.asia-east1.run.app';
  final apiUrl = '10.0.2.2:8000'; // For Android emulator, use localhost
  //final apiUrl = '192.168.0.117:8000'; // kelvin's home at penang
  //final apiUrl = '192.168.0.6:8000'; // kelvin's home at sp
  //final apiUrl = '10.3.226.75:8000'; // inti ip

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

  Future<String> uploadReceipt(
      String? idToken, String imagePath, Map<String?, dynamic> receipt) async {
    if (idToken == null || idToken.isEmpty) {
      throw Exception('ID token is required to add a receipt.');
    }

    // Send both id_token and receipt as query parameters with proper JSON encoding
    var url = Uri.http(apiUrl, '/add-receipt/', {
      'id_token': idToken,
      'receipt': jsonEncode(receipt),
    });
    var request = http.MultipartRequest('POST', url);

    var multipartFile = await http.MultipartFile.fromPath('file', imagePath);
    request.files.add(multipartFile);

    try {
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print('Response from uploadReceipt: $responseBody');
      return responseBody;
    } catch (e) {
      throw Exception('Error sending request to add receipt: $e');
    }
  }

  Future<String> readReceipt(String imagePath) async {
    // Send id_token as a query parameter
    var url = Uri.http(apiUrl, '/read-receipt-image/');
    var request = http.MultipartRequest('POST', url);

    var multipartFile = await http.MultipartFile.fromPath('file', imagePath);
    request.files.add(multipartFile);

    try {
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      return responseBody;
    } catch (e) {
      throw Exception('Error sending request to add receipt: $e');
    }
  }

  Future<void> deleteReceipt({
    required String? idToken,
    required String receiptId,
  }) async {
    if (idToken == null || idToken.isEmpty) {
      throw Exception('ID token is required to delete a receipt.');
    }
    var url = Uri.http(apiUrl, '/delete-receipt-by-id', {
      'id_token': idToken,
      'receipt_id': receiptId,
    });

    try {
      print('ApiService: Calling DELETE ${url.toString()}');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Successfully deleted
        print(
            'ApiService: Receipt deleted successfully. Response: ${response.body}');
        return;
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage =
            errorBody['detail'] ?? 'An unknown error occurred.';
        print(
            'ApiService Error: Failed to delete receipt. Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to delete receipt: $errorMessage');
      }
    } on SocketException catch (e) {
      print('ApiService Network Error on DELETE (SocketException): $e');
      throw Exception('Could not connect to the server to delete the receipt.');
    } catch (e) {
      print('ApiService Error on DELETE: $e');
      throw Exception(
          'An unexpected error occurred while deleting the receipt.');
    }
  }

  Future<Map<String, dynamic>?> getAchievements(String? idToken) async {
    if (idToken == null || idToken.isEmpty) {
      throw Exception('ID token is required to get achievements.');
    }

    var url =
        Uri.http(apiUrl, '/get-achievements-by-user', {'id_token': idToken});

    try {
      print('ApiService: Calling GET ${url.toString()}');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        print('ApiService: No achievement data found for user (404).');
        return null;
      } else {
        print(
            'ApiService Error: Failed to load achievements. Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to load achievements from server.');
      }
    } catch (e) {
      print('ApiService Network Error on GET: $e');
      throw Exception('Could not connect to the server.');
    }
  }

  Future<void> saveAchievements({
    required String? idToken,
    required int totalPoints,
    required Map<String, AchievementProgress> userAchievements,
    required int currentScanStreak,
    required String? lastScanTimestamp,
  }) async {
    if (idToken == null || idToken.isEmpty) {
      throw Exception('ID token is required to save achievements.');
    }

    final Map<String, dynamic> payload = {
      'totalPoints': totalPoints,
      'progress': userAchievements.values.map((p) => p.toJson()).toList(),
      'currentScanStreak': currentScanStreak,
      'lastScanTimestamp': lastScanTimestamp,
    };

    var url =
        Uri.http(apiUrl, '/save-achievements-by-user', {'id_token': idToken});

    try {
      print('ApiService: Calling POST ${url.toString()}');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(payload),
      );

      if (response.statusCode != 200) {
        print(
            'ApiService Error: Failed to save achievements. Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to save achievements to server.');
      }
      print('ApiService: Achievements saved successfully.');
    } catch (e) {
      print('ApiService Network Error on POST: $e');
      throw Exception('Could not connect to the server to save progress.');
    }
  }

  Future<Map<String, dynamic>> getBudget({
    required String? idToken,
  }) async {
    if (idToken == null || idToken.isEmpty) {
      throw Exception('ID token is required to fetch budgets.');
    }

    var url = Uri.http(apiUrl, '/get-budgets-by-user', {'id_token': idToken});

    print('ApiService: Calling GET ${url.toString()}');
    var response = await http.get(url);

    try {
      print('ApiService: Calling GET ${url.toString()}');
      var response = await http.get(url);

      if (response.statusCode != 200) {
        final errorMsg =
            'ApiService Error: Failed to get budgets. Status: ${response.statusCode}, Body: ${response.body}';
        print(errorMsg);
        throw Exception(errorMsg);
      }

      final decoded = json.decode(response.body) as Map<String, dynamic>;
      print('ApiService: Budgets fetched successfully.');
      return decoded;
    } catch (e) {
      print('ApiService Network Error on GET: $e');
      throw Exception(
          'Could not connect to the server to load budgets. error: $e');
    }
  }

  Future<void> saveBudget(
      {required String? idToken,
      required Map<String, Map<String, double>> budgets,
      String? budgetPeriod}) async {
    if (idToken == null || idToken.isEmpty) {
      throw Exception('ID token is required to save budgets.');
    }

    final Map<String, dynamic> payload = {
      'budgets': budgets,
    };
    if (budgetPeriod != null) {
      payload['budgetPeriod'] = budgetPeriod;
    }

    var url = Uri.http(apiUrl, '/save-budgets-by-user', {'id_token': idToken});

    print('payload: $payload');
    try {
      print('ApiService: Calling POST ${url.toString()}');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(payload),
      );
    } on SocketException catch (e) {
      print('ApiService Network Error on POST (SocketException): $e');
      throw Exception(
          'Could not connect to the server to save budgets (Network Issue).');
    } on http.ClientException catch (e) {
      print('ApiService Network Error on POST (ClientException): $e');
      throw Exception(
          'Could not connect to the server to save budgets (Client Network Issue).');
    }
  }
}
