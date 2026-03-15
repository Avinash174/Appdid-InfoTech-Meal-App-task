import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'controller/auth_controller.dart';
import 'view/login_view.dart';
import 'view/home_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb && Platform.isAndroid) {
    await GoogleSignIn.instance.initialize();
  }

  // Initialize Services and Controllers
  Get.put(AuthService(), permanent: true);
  Get.put(AuthController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Explorer',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF9800),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      // Use Obx to listen to auth state changes for initial route
      home: Obx(() => authService.isLoggedIn ? HomeView() : LoginView()),
    );
  }
}
