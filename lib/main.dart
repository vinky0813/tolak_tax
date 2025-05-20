import 'package:flutter/material.dart';
import 'package:tolak_tax/firebase/firebase_initializer.dart';
import 'package:tolak_tax/screens/forgot_password_screen.dart';
import 'package:tolak_tax/screens/home_screen.dart';
import 'package:tolak_tax/screens/login_screen.dart';
import 'package:tolak_tax/screens/reset_password_screen.dart';
import 'package:tolak_tax/screens/signup_screen.dart';
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
      home: SignupScreen(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/reset-password': (context) => ResetPasswordScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}