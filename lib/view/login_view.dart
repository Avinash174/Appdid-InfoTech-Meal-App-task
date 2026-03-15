import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive_helper.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [AppColors.grey100, AppColors.primaryLight, AppColors.primaryLight],
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo / Icon Section with Hero
                      Hero(
                        tag: 'app_logo',
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.restaurant_menu_rounded, 
                            size: 50, color: Color(0xFFE65100)),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      Text(
                        'Welcome Back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: Colors.grey[900],
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        'Discover your next favorite meal',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Input Fields
                      _buildTextField(
                        controller: emailController,
                        label: 'Email',
                        hint: 'hello@example.com',
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      _buildTextField(
                        controller: passwordController,
                        label: 'Password',
                        hint: 'Min. 6 characters',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        isPasswordVisible: _isPasswordVisible,
                        onTogglePassword: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Forgot Password?', 
                            style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.w600)),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Login Button
                      Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE65100),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          shadowColor: Colors.orange.withValues(alpha: 0.4),
                        ),
                        onPressed: authController.isLoading.value ? null : () async {
                          if (_formKey.currentState!.validate()) {
                            final success = await authController.login(
                              emailController.text.trim(), 
                              passwordController.text
                            );
                            if (success) {
                              Get.offAllNamed(AppRoutes.home);
                            }
                          }
                        },
                        child: authController.isLoading.value 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      )),
                      
                      const SizedBox(height: 20),
                      
                      // Google Sign-In Button
                      Obx(() => OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          side: BorderSide(color: Colors.grey[300]!),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: authController.isLoading.value ? null : () async {
                          final success = await authController.googleLogin();
                          if (success) {
                            Get.offAllNamed(AppRoutes.home);
                          }
                        },
                        icon: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/512px-Google_%22G%22_Logo.svg.png',
                          height: 24,
                        ),
                        label: const Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                      
                      const SizedBox(height: 24),
                      
                      // Signup Switch
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?", style: TextStyle(color: Colors.grey[700])),
                          TextButton(
                            onPressed: () => Get.toNamed(AppRoutes.signup),
                            child: const Text('Sign Up', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool? isPasswordVisible,
    VoidCallback? onTogglePassword,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !(isPasswordVisible ?? false),
          keyboardType: keyboardType,
          style: const TextStyle(fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.orange[800], size: 22),
            suffixIcon: isPassword 
              ? IconButton(
                  icon: Icon(isPasswordVisible! ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                  onPressed: onTogglePassword,
                )
              : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE65100), width: 1.5),
            ),
            errorStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'This field is required';
            if (!isPassword && !GetUtils.isEmail(value)) return 'Please enter a valid email';
            if (isPassword && value.length < 6) return 'Password must be at least 6 characters';
            return null;
          },
        ),
      ],
    );
  }
}
