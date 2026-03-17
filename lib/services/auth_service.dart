import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  
  Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isAdminLoggedIn = false.obs;
  RxString loggedInUserIdentifier = ''.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    _loadSessions();
    
    ever(firebaseUser, (User? user) {
      if (user != null) {
        loggedInUserIdentifier.value = user.email ?? 'Google User';
        _saveUserIdentifier(loggedInUserIdentifier.value);
      }
    });
  }

  Future<void> _loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    isAdminLoggedIn.value = prefs.getBool('is_admin_logged_in') ?? false;
    loggedInUserIdentifier.value = prefs.getString('user_identifier') ?? '';
  }

  Future<void> _saveUserIdentifier(String identifier) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_identifier', identifier);
  }

  bool get isLoggedIn => firebaseUser.value != null || isAdminLoggedIn.value;

  Future<void> login(String username, String password) async {
    if (username == 'admin' && (password == '1234' || password == 'admin')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_admin_logged_in', true);
      await prefs.setString('user_identifier', username);
      
      isAdminLoggedIn.value = true;
      loggedInUserIdentifier.value = username;
      return;
    }
    
    Get.snackbar('Login Error', 'Invalid username or password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer);
    throw Exception('Unauthorized');
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
      await prefs.remove('user_identifier');
      
      isAdminLoggedIn.value = false;
      loggedInUserIdentifier.value = '';
      
      try {
        await _googleSignIn.signOut();
      } catch (_) {}
      await _auth.signOut();
    } catch (e) {
      // Ignore errors on logout
    }
  }
}
