import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../app_config.dart';

// Controller to manage the user authentication state and logic
class AuthController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();

  // Simple reactive boolean to track loading states across views
  final RxBool isLoading = false.obs;

  // Handle email/password login
  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.login(email, password);
      return true;
    } catch (e) {
      // We could show a specific error snackbar here if needed
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Handle Google Sign-In flow
  Future<bool> googleLogin() async {
    try {
      isLoading.value = true;
      final user = await _auth.signInWithGoogle();
      return user != null;
    } catch (e) {
      print('Google sign in failed: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Handle new user registration
  Future<bool> register(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.register(email, password);
      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Sign out and cleanup
  void logout() async {
    try {
      await _auth.logout();
    } catch (e) {
      print('Error during logout: $e');
    } finally {
      // Always kick back to login if something goes wrong or on success
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
