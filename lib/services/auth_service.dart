import 'dart:developer' as dev;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Service to handle all auth logic: Firebase, Google, and simple Admin login
class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Reactively track the current user and admin status
  Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isAdminLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Bind the firebase user stream to our reactive variable
    firebaseUser.bindStream(_auth.authStateChanges());
    _loadSessions();

    // Sync session state to persistent storage whenever the user changes
    ever(firebaseUser, (User? user) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_firebase_logged_in', user != null);
      if (user != null) {
        dev.log('User logged in: ${user.email}', name: 'auth.service');
      }
    });
  }

  // Check storage for existing local sessions (like admin)
  Future<void> _loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    isAdminLoggedIn.value = prefs.getBool('is_admin_logged_in') ?? false;
    dev.log('Session loaded. Admin: ${isAdminLoggedIn.value}', name: 'auth.service');
  }

  // Quick check if anyone is logged in
  bool get isLoggedIn => firebaseUser.value != null || isAdminLoggedIn.value;

  // Standard email/pass login + custom admin check
  Future<void> login(String usernameOrEmail, String password) async {
    dev.log('Attempting login for: $usernameOrEmail', name: 'auth.service');
    
    // Check for hardcoded Admin credentials
    if (usernameOrEmail == 'admin' && password == '1234') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_admin_logged_in', true);
      isAdminLoggedIn.value = true;
      dev.log('Admin login successful', name: 'auth.service');
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: usernameOrEmail, password: password);
      dev.log('Firebase login successful', name: 'auth.service');
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is badly formatted.';
      }
      
      dev.log('Login failed: ${e.code}', name: 'auth.service', error: e);
      
      Get.snackbar('Login Error', message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.errorContainer,
          colorText: Get.theme.colorScheme.onErrorContainer);
      rethrow;
    }
  }

  // Launch Google Sign-In flow
  Future<UserCredential?> signInWithGoogle() async {
    dev.log('Starting Google Sign-In', name: 'auth.service');
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      
      final AuthCredential cred = GoogleAuthProvider.credential(
        accessToken: null,
        idToken: googleAuth.idToken,
      );

      final UserCredential credential = await _auth.signInWithCredential(cred);
      dev.log('Google login successful: ${credential.user?.email}', name: 'auth.service');
      
      return credential;
    } catch (e) {
      dev.log('Google login failed', name: 'auth.service', error: e);
      Get.snackbar('Google Sign-In Error', 'Something went wrong with Google Login',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.errorContainer,
          colorText: Get.theme.colorScheme.onErrorContainer);
      return null;
    }
  }

  // Create a new user account
  Future<void> register(String email, String password) async {
    dev.log('Registering new user: $email', name: 'auth.service');
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      dev.log('Registration successful', name: 'auth.service');
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      
      dev.log('Registration failed: ${e.code}', name: 'auth.service', error: e);

      Get.snackbar('Registration Error', message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.errorContainer,
          colorText: Get.theme.colorScheme.onErrorContainer);
      rethrow;
    }
  }

  // Clear all sessions and log out
  Future<void> logout() async {
    dev.log('Logging out...', name: 'auth.service');
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_admin_logged_in', false);
      await prefs.setBool('is_firebase_logged_in', false);
      isAdminLoggedIn.value = false;
      
      // Clean up Google session if it exists
      try {
        await _googleSignIn.signOut();
      } catch (_) {}
      
      await _auth.signOut();
      dev.log('Logout successful', name: 'auth.service');
    } catch (e) {
      dev.log('Logout error', name: 'auth.service', error: e);
    }
  }
}
