import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../app_config.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // GetX handles the business logic here
    final auth = Get.find<AuthController>();
    
    // Form controllers
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                
                // Greeting section
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  'Login to your account',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                
                const SizedBox(height: 40),
                
                // Email input
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'e.g. user@example.com',
                    prefixIcon: const Icon(Icons.mail_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Please enter your email';
                    if (!val.contains('@')) return 'Enter a valid email address';
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Password input
                TextFormField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (val) => (val == null || val.isEmpty) ? 'Password is required' : null,
                ),
                
                const SizedBox(height: 32),
                
                // Primary Login Button
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: auth.isLoading.value ? null : () async {
                      if (formKey.currentState!.validate()) {
                        final success = await auth.login(emailCtrl.text.trim(), passCtrl.text);
                        if (success) Get.offAllNamed(AppRoutes.home);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, 
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: auth.isLoading.value 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                      : const Text('LOGIN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                )),
                
                // Social Login Divider
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                    ],
                  ),
                ),
                
                // Google Login Option
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: auth.isLoading.value ? null : () async {
                      final success = await auth.googleLogin();
                      if (success) Get.offAllNamed(AppRoutes.home);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: auth.isLoading.value 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)) 
                      : const Text('CONTINUE WITH GOOGLE', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
                  ),
                )),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
