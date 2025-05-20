import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tolak_tax/services/auth_service.dart';
import 'package:tolak_tax/utils/validators.dart';
import 'package:tolak_tax/widgets/login_soclalbutton.dart';
import 'package:tolak_tax/widgets/login_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      print("Logging in with: $email / $password");

      try {
        final user = await AuthService().signInWithEmail(email, password);
        if (user != null) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login failed. Please try again."),
              backgroundColor: Colors.red,
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided.';
        } else {
          errorMessage = e.message ?? 'Login failed.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An unexpected error occurred."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 400,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/backgrounds/tolaktax-background1.png"),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          Positioned(
            top: screenHeight * 0.05,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset(
                        "assets/icons/app_icon_without_background.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "TolakTax",
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Smart Receipts. Smarter Taxes.",
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
              height: screenHeight * 0.6,
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
                        "Welcome Back",
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      LoginTextField(
                        controller: _emailController,
                        label: "Email",
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 16),

                      LoginTextField(
                        controller: _passwordController,
                        label: "Password",
                        icon: Icons.lock,
                        obscureText: true,
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 24),
                  
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _handleLogin,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: const Text("Forgot password?", style: TextStyle(fontFamily: "DMSans"),),
                        ),
                      ),
                  
                      //const SizedBox(height: 6),
                      Center(
                        child: Text(
                          "or continue with",
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoginSoclalbutton(assetPath:'assets/icons/icons8-google.svg',
                            onTap: () async {
                              final userCredential = await _authService.signInWithGoogle();
                              if (userCredential != null) {
                                Navigator.pushReplacementNamed(context, '/home');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Google Sign-In failed")),
                                );
                              }
                            },),
                          const SizedBox(width: 16),
                          LoginSoclalbutton(assetPath:'assets/icons/icons8-facebook.svg',
                            onTap: () {
                              // handle Facebook login
                            },),
                          const SizedBox(width: 16),
                          LoginSoclalbutton(assetPath:'assets/icons/icons8-twitter.svg',
                            onTap: () {
                              // handle Twitter login
                            },),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?", style: theme.textTheme.bodyMedium),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Text("Sign up", ),
                          )
                        ],
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
