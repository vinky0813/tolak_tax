import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tolak_tax/services/auth_service.dart';
import 'package:tolak_tax/widgets/back_button.dart';
import 'package:tolak_tax/widgets/login_textfield.dart';
import '../utils/validators.dart';

class PhoneNumberInputScreen extends StatefulWidget {
  const PhoneNumberInputScreen({super.key});

  @override
  State<PhoneNumberInputScreen> createState() => _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOTP() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final rawPhoneNumebr = _phoneNumberController.text.trim();
      final phoneNumber = '+60$rawPhoneNumebr';
      print("Send OTP to: $phoneNumber");

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      await authService.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationFailed: (e) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Verification failed: ${e.message}")),
          );
          log('Error: ${e.message}');
        },
        codeSent: (verificationId) {
          Navigator.of(context).pop();
          Navigator.pushNamed(
            context,
            '/otp-verification',
            arguments: {
              'phoneNumber': phoneNumber,
              'verificationId': verificationId,
            },
          );
        },
        codeAutoRetrievalTimeout: (msg) {
          Navigator.of(context).pop();
          print("Auto-retrieval timeout: $msg");
        },
        onVerificationCompleted: (UserCredential userCredential) {
          Navigator.of(context).pop();
          if (userCredential.additionalUserInfo?.isNewUser == true) {
            Navigator.pushNamedAndRemoveUntil(context, '/create-profile', (_) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
          }
      },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage("assets/backgrounds/tolaktax-background2.png"),
                fit: BoxFit.cover,
                alignment: Alignment.topRight,
              ),
            ),
          ),
          const BackButtonWidget(),
          Positioned(
            top: screenHeight * 0.12,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Phone Verification",
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Enter your phone number to receive a verification code.",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.65,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Phone Number:",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        validator: validatePhoneNumber,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: const TextStyle(
                            fontFamily: "DMSans",
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Container(
                            width: 90,
                            padding: const EdgeInsets.only(left: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.phone, color: colorScheme.primary),
                                Container(
                                  height: 24,
                                  width: 1,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  color: colorScheme.outline,
                                ),
                                Text(
                                  '+60',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: colorScheme.outline),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _handleSendOTP,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "Send OTP",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Back to Login"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
