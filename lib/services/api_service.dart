import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

class ApiService {
  Future<void> printUserDetails(BuildContext context) async {
    final String? token =
        await Provider.of<AuthService>(context, listen: false).getIdToken();
    print(token);
  }
}
