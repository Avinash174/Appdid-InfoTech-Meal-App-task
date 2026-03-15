import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import 'home_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFE65100)),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2), Color(0xFFFFCC80)],
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo / Icon Section with Hero for smooth transition
                      Hero(
                        tag: 'app_logo',
                        child: Container(
                          height: 80,
                          width: 80,
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
                            size: 40, color: Color(0xFFE65100)),
                        ),
                      ),
                      
                      const SizedBox(height: 24),

                      const Text(
                        'Join Recipe Explorer',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: Color(0xFFE65100),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        'Create an account to start your culinary journey',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      _buildTextField(
                        controller: emailController,
                        label: 'Email',
                        hint: 'your@email.com',
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      _buildTextField(
                        controller: passwordController,
                        label: 'Password',
                        hint: 'Choose a strong password',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        isPasswordVisible: _isPasswordVisible,
                        onTogglePassword: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      _buildTextField(
                        controller: confirmPasswordController,
                        label: 'Confirm Password',
                        hint: 'Repeat your password',
                        icon: Icons.lock_clock_outlined,
                        isPassword: true,
                        isPasswordVisible: _isPasswordVisible,
                      ),
                      
                      const SizedBox(height: 40),
                      
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
                            if (passwordController.text != confirmPasswordController.text) {
                              Get.snackbar('Error', 'Passwords do not match');
                              return;
                            }
                            final success = await authController.register(
                              emailController.text.trim(), 
                              passwordController.text
                            );
                            if (success) {
                              Get.offAll(() => HomeView());
                            }
                          }
                        },
                        child: authController.isLoading.value 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Create Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      )),
                      
                      const SizedBox(height: 24),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?", style: TextStyle(color: Colors.grey[700])),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text('Login', style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.bold)),
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
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.orange[800], size: 22),
            suffixIcon: isPassword && onTogglePassword != null
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
