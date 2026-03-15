import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/login_view.dart';
import 'view/signup_view.dart';
import 'view/home_view.dart';
import 'view/meals_view.dart';
import 'view/meal_detail_view.dart';
import 'model/meal_detail_model.dart';

class AppColors {
  static const Color primary = Color(0xFFFF9800);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color card = Colors.white;
  static const Color appBar = Colors.white;
}

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
      transition: Transition.fadeIn,
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

extension AppResponsive on num {
  double get w => Get.width * (this / 100);
  double get h => Get.height * (this / 100);
  double get sp => Get.width >= 600 ? this * 1.15 : toDouble();
}
