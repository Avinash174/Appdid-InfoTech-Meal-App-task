import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isAdminLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    _loadSessions();
    ever(firebaseUser, (User? user) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_firebase_logged_in', user != null);
    });
  }

  Future<void> _loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    isAdminLoggedIn.value = prefs.getBool('is_admin_logged_in') ?? false;
  }

  bool get isLoggedIn => firebaseUser.value != null || isAdminLoggedIn.value;

   Future<void> login(String usernameOrEmail, String password) async {
    if (usernameOrEmail == 'admin' && (password == '1234' || password == 'admin')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_admin_logged_in', true);
      isAdminLoggedIn.value = true;
      return;
    }
    try {
      await _auth.signInWithEmailAndPassword(email: usernameOrEmail, password: password);
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is badly formatted.';
      } else if (e.code == 'network-request-failed') {
        message = 'Network error. Please check your connection.';
      }
      Get.snackbar('Login Error', message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.errorContainer,
          colorText: Get.theme.colorScheme.onErrorContainer);
      rethrow;
    } catch (e) {
      Get.snackbar('Login Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.errorContainer,
          colorText: Get.theme.colorScheme.onErrorContainer);
      rethrow;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final AuthCredential cred = GoogleAuthProvider.credential(
        accessToken: null,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(cred);
    } catch (e) {
      Get.snackbar('Google Sign-In Error', 'Something went wrong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.errorContainer,
          colorText: Get.theme.colorScheme.onErrorContainer);
      return null;
    }
  }


  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_admin_logged_in', false);
      await prefs.setBool('is_firebase_logged_in', false);
      isAdminLoggedIn.value = false;
      try {
        await _googleSignIn.signOut();
      } catch (_) {
        // empty catch for safety
      }
      await _auth.signOut();
    } catch (e) {
      // safe logout
    }
  }
}
