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

    // Sync Firebase state to SharedPreferences for extra durability
    ever(firebaseUser, (User? user) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_firebase_logged_in', user != null);
    });
  }

  Future<void> _loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    isAdminLoggedIn.value = prefs.getBool('is_admin_logged_in') ?? false;
    // We don't manually set firebaseUser, Firebase handles that, 
    // but the ever() listener will keep prefs in sync.
  }

  bool get isLoggedIn => firebaseUser.value != null || isAdminLoggedIn.value;

  Future<void> login(String usernameOrEmail, String password) async {
    // 1. Check for Admin Login (Requirement 1)
    if (usernameOrEmail == 'admin' && password == '1234') {
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
      }
      Get.snackbar('Login Error', message,
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

      final UserCredential credential = await _auth.signInWithCredential(cred);
      if (credential.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_firebase_logged_in', true);
      }
      return credential;
    } catch (e) {
      Get.snackbar('Google Sign-In Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.errorContainer,
          colorText: Get.theme.colorScheme.onErrorContainer);
      return null;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      Get.snackbar('Registration Error', message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.errorContainer,
          colorText: Get.theme.colorScheme.onErrorContainer);
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_admin_logged_in', false);
    await prefs.setBool('is_firebase_logged_in', false);
    isAdminLoggedIn.value = false;
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
