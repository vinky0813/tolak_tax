import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tolak_tax/services/auth_result.dart';
import 'package:tolak_tax/services/auth_service.dart';
import 'package:tolak_tax/widgets/back_button.dart';
import 'package:tolak_tax/widgets/login_textfield.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OTPVerificationScreen(
      {super.key, required this.phoneNumber, required this.verificationId});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  late String _currentVerificationId;

  @override
  void initState() {
    super.initState();
    _currentVerificationId = widget.verificationId;
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleVerifyOTP() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final otp = _otpController.text.trim();
      // handle verify otp

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {

        final AuthResult result = await authService.signInWithOTP(otp);

        Navigator.of(context).pop();

        if (result.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.errorMessage!)),
          );
          return;
        }

        if (result.isNewUser) {
          Navigator.pushNamedAndRemoveUntil(context, '/create-profile', (_) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
        }
      } catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP verification failed: ${e.toString()}")),
        );
      }
    }
  }

  Future<void> _handleResendOTP() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP resent')),
    );
    // handle resend otp
    final authService = Provider.of<AuthService>(context, listen: false);

    await authService.resendOtp(
      phoneNumber: widget.phoneNumber,
      context: context,
      onCodeSent: (String verificationId) {
        setState(() {
          _currentVerificationId = verificationId;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

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
                  "Verify OTP",
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Enter the OTP sent to ${widget.phoneNumber}",
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
                        "Please enter the 6-digit code:",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 24),
                      LoginTextField(
                        controller: _otpController,
                        label: "OTP Code",
                        icon: Icons.sms,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().length != 6) {
                            return 'Enter a valid 6-digit OTP';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _handleVerifyOTP,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "Verify",
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
                          onPressed: _handleResendOTP,
                          child: const Text("Resend OTP"),
                        ),
                      ),
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
