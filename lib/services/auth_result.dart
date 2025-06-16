import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  final User? user;
  final bool isNewUser;
  final String? errorMessage;

  AuthResult({
    this.user,
    this.isNewUser = false,
    this.errorMessage,
  });
}