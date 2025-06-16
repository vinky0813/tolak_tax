import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tolak_tax/services/auth_result.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String? _verificationId;

  Future<AuthResult> signInWithEmail(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return AuthResult(
      user: userCredential.user,
      isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false,
    );
  }

  Future<AuthResult> registerWithEmail(String email, String password, String name) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User? user = userCredential.user;

    if (user != null) {
      await user.updateDisplayName(name);
      await user.reload();
      final updatedUser = _auth.currentUser;
    }
    return AuthResult(
      user: userCredential.user,
      isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false,
    );
  }

  // google sign in implementation
  // https://firebase.google.com/docs/auth/flutter/federated-auth#google
  // ------------------------- IMPORTANT -----------------------------
  // SHA-key is generated for production, meaning if you are not connected to android studio
  // via USB or in emulator it would not work
  // IF WANT A REAL RELEASE VERSION TRY TO RUN THE FOLLOWING AND GET THE SHA1 KEY FOR FIREBASE
  // keytool -genkey -v -keystore my-release-key.keystore -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000
  // keytool -list -v -keystore my-release-key.keystore -alias my-key-alias
  Future<AuthResult?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // User cancelled the sign-in
      if (googleUser == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);
      return AuthResult(
        user: userCredential.user,
        isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false,
      );
    } catch (e) {
      print('Google Sign-In error: $e');
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // THIS IS TEST ONLY, NOT REAL
  // NEED TO SET BILLING ACCOUTN IF WANT A REAL ONE
  // USE THE TEST PHONE NUMBER OR SET A NEW TEST PHONE NUMBER
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(UserCredential) onVerificationCompleted,
    required Function(FirebaseAuthException e) verificationFailed,
    required Function(String message) codeAutoRetrievalTimeout,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          final userCredential = await _auth.signInWithCredential(credential);
          onVerificationCompleted(userCredential);
        },
        verificationFailed: verificationFailed,
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          codeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          codeAutoRetrievalTimeout("Code timeout. Try again.");
        },
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> resendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required BuildContext context
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Resend failed: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
      },
    );
  }

  Future<AuthResult> signInWithOTP(String smsCode) async {
    if (_verificationId == null) {
      throw FirebaseAuthException(
        code: 'invalid-verification-id',
        message: 'Verification ID not set. Start verification first.',
      );
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    return AuthResult(
      user: userCredential.user,
      isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false,
    );
  }

  Future<AuthResult?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(
                '${loginResult.accessToken?.tokenString}');
        final userCredential = await _auth.signInWithCredential(credential);
        return AuthResult(
          user: userCredential.user,
          isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false,
        );
      } else {
        return null;
      }
    } catch (e) {
      print("Facebook Sign-In Error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    final user = _auth.currentUser;

    if (user != null) {
      final providerIds = user.providerData.map((info) => info.providerId).toList();

      if (providerIds.contains('google.com')) {
        await GoogleSignIn().signOut();
      }
    }
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
