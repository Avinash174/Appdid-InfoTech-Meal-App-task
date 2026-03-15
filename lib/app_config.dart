import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/login_view.dart';
import 'view/signup_view.dart';
import 'view/home_view.dart';
import 'view/meals_view.dart';
import 'view/meal_detail_view.dart';
import 'model/meal_detail_model.dart';

// Just basic colors we're using across the app
class AppColors {
  // Brand primary (Orange)
  static const Color primary = Color(0xFFFF9800);
  
  // Neutral colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color card = Colors.white;
  static const Color appBar = Colors.white;
}

// Simple route management
class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String meals = '/meals';
  static const String mealDetail = '/meal-detail';

  static final pages = [
    GetPage(
      name: login, 
      page: () => const LoginView(),
      transition: Transition.fadeIn, // Fade in feels a bit more premium
    ),
    GetPage(name: signup, page: () => const SignupView()),
    GetPage(name: home, page: () => HomeView()),
    GetPage(
      name: meals, 
      page: () => MealsView(categoryName: Get.arguments as String? ?? 'Meals'),
    ),
    GetPage(
      name: mealDetail, 
      page: () => MealDetailView(meal: Get.arguments as MealDetailModel),
    ),
  ];
}

// Quick helper for responsive stuff
// We use percentage of screen width/height for sizing
extension AppResponsive on num {
  double get w => Get.width * (this / 100);
  double get h => Get.height * (this / 100);
  
  // Font scaling - slightly bigger on tablets/large screens
  double get sp => Get.width >= 600 ? this * 1.15 : toDouble();
}
