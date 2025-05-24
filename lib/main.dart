import 'package:flutter/material.dart';
import 'package:tolak_tax/firebase/firebase_initializer.dart';
import 'package:tolak_tax/screens/forgot_password_screen.dart';
import 'package:tolak_tax/screens/home_screen.dart';
import 'package:tolak_tax/screens/login_screen.dart';
import 'package:tolak_tax/screens/otp_verification_screen.dart';
import 'package:tolak_tax/screens/phone_number_input_screen.dart';
import 'package:tolak_tax/screens/reset_password_screen.dart';
import 'package:tolak_tax/screens/signup_screen.dart';
import 'package:tolak_tax/screens/splash_screen.dart';
import 'package:tolak_tax/themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TolakTax',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/signup':
            return MaterialPageRoute(builder: (_) => const SignupScreen());
          case '/forgot-password':
            return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
          case '/reset-password':
            return MaterialPageRoute(builder: (_) => ResetPasswordScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/input-phone':
            return MaterialPageRoute(builder: (_) => const PhoneNumberInputScreen());
          case '/otp-verification':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => OTPVerificationScreen(
                phoneNumber: args['phoneNumber'],
                verificationId: args['verificationId'],
              ),
            );
          default:
            // make a real 404 error page when free
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text("Page not found")),
              ),
            );
        }
      },

    );
  }
}