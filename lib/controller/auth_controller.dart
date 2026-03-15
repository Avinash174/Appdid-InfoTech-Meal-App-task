import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../app_config.dart';

class AuthController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();
  final RxBool isLoading = false.obs;

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.login(email, password);
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> googleLogin() async {
    try {
      isLoading.value = true;
      final user = await _auth.signInWithGoogle();
      return user != null;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.register(email, password);
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    try {
      await _auth.logout();
    } catch (e) {
      // safe logout
    } finally {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
