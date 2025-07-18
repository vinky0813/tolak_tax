import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tolak_tax/firebase/firebase_initializer.dart';
import 'package:tolak_tax/models/receipt_model.dart';
import 'package:tolak_tax/screens/achievement_screen.dart';
import 'package:tolak_tax/screens/budget_overview_screen.dart';
import 'package:tolak_tax/screens/budget_settings_screen.dart';
import 'package:tolak_tax/screens/display_picture_screen.dart';
import 'package:tolak_tax/screens/create_profile_screen.dart';
import 'package:tolak_tax/screens/edit_profile_screen.dart';
import 'package:tolak_tax/screens/forgot_password_screen.dart';
import 'package:tolak_tax/screens/generate_report_screen.dart';
import 'package:tolak_tax/screens/home_screen.dart';
import 'package:tolak_tax/screens/login_screen.dart';
import 'package:tolak_tax/screens/otp_verification_screen.dart';
import 'package:tolak_tax/screens/phone_number_input_screen.dart';
import 'package:tolak_tax/screens/receipt_details_screen.dart';
import 'package:tolak_tax/screens/reset_password_screen.dart';
import 'package:tolak_tax/screens/signup_screen.dart';
import 'package:tolak_tax/screens/splash_screen.dart';
import 'package:tolak_tax/screens/tax_details_screen.dart';
import 'package:tolak_tax/screens/tax_report_screen.dart';
import 'package:tolak_tax/services/auth_service.dart';
import 'package:tolak_tax/services/budget_service.dart';
import 'package:tolak_tax/services/navigation_service.dart';
import 'package:tolak_tax/themes/app_theme.dart';
import 'package:tolak_tax/utils/transitions.dart';
import 'package:tolak_tax/screens/camera_page.dart';
import 'package:tolak_tax/screens/receipt_confirm_screen.dart';

import 'services/receipt_service.dart';
import 'services/achievement_service.dart';
import 'services/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  // adding provider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProxyProvider2<User?, ApiService, ReceiptService?>(
          create: (_) => null,
          update: (context, user, apiService, previousReceiptService) {
            if (user == null) {
              // User logged out - clear any existing service
              previousReceiptService?.clearCache();
              return null;
            }

            // Check if we need to create a new service or if user changed
            if (previousReceiptService == null) {
              print('Creating ReceiptService for user: ${user.uid}');
              final newService = ReceiptService(
                apiService: apiService,
                authService: context.read<AuthService>(),
              );
              return newService;
            }

            return previousReceiptService;
          },
        ),
        ChangeNotifierProxyProvider2<User?, ApiService, AchievementService?>(
          create: (_) => null,
          update: (context, user, apiService, previousAchievementService) {
            if (user == null) {
              return null;
            }
            print('Providing AchievementService for user: ${user.uid}');
            return AchievementService(
              apiService: apiService,
              authService: context.read<AuthService>(),
            );
          },
        ),
        ChangeNotifierProxyProvider2<User?, ApiService, BudgetService?>(
          create: (_) => null,
          update: (context, user, apiService, _) {
            if (user == null) return null;
            print('Providing BudgetService for user: ${user.uid}');
            return BudgetService(
              apiService: apiService,
              authService: context.read<AuthService>(),
            );
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TolakTax',
      navigatorKey: navigatorKey,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return fadeRoute(const LoginScreen());
          case '/signup':
            return fadeRoute(const SignupScreen());
          case '/forgot-password':
            return fadeRoute(const ForgotPasswordScreen());
          case '/reset-password':
            return fadeRoute(const ResetPasswordScreen());
          case '/home':
            return fadeRoute(const HomeScreen());
          case '/input-phone':
            return fadeRoute(const PhoneNumberInputScreen());
          case '/camera':
            return scaleRoute(
              const CameraPage(),
            );
          case '/otp-verification':
            final args = settings.arguments as Map<String, dynamic>;
            return fadeRoute(
              OTPVerificationScreen(
                phoneNumber: args['phoneNumber'],
                verificationId: args['verificationId'],
              ),
            );
          case '/splash-to-home':
            return fadeThroughRoute(const HomeScreen());
          case '/splash-to-login':
            return fadeThroughRoute(const LoginScreen());
          case '/generate-report':
            return fadeThroughRoute(const GenerateReportScreen());
          case '/receipt-details':
            final receipt = settings.arguments as Receipt;
            return fadeThroughRoute(ReceiptDetailsScreen(receipt: receipt));
          case '/achievement':
            return fadeThroughRoute(const AchievementScreen());
          case '/create-profile':
            return fadeThroughRoute(const CreateProfileScreen());
          case '/budget-overview':
            final args = settings.arguments as Map<String, dynamic>;
            return fadeThroughRoute(
              BudgetOverviewScreen(
                initialFocusedCategoryKey:
                    args['initialFocusedCategoryKey'] ?? '',
              ),
            );
          case 'budget-settings':
            return fadeThroughRoute(BudgetSettingsScreen());
          case '/tax-details':
            final args = settings.arguments as Receipt;
            return fadeThroughRoute(TaxDetailsScreen(receipt: args));
          case '/display-picture':
            final args = settings.arguments as Map<String, dynamic>;
            return fadeThroughRoute(
              DisplayPictureScreen(
                imagePath: args['imagePath'],
              ),
            );
          case 'edit-profile':
            return fadeThroughRoute(EditProfileScreen());
          case '/receipt-confirm':
            final args = settings.arguments as Map<String, dynamic>;
            return fadeThroughRoute(
              ReceiptConfirmScreen(
                receiptData: args['receiptData'],
                receiptImagePath: args['receiptImagePath'],
              ),
            );
          case '/tax-report':
            return fadeThroughRoute(const TaxReportScreen());

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
