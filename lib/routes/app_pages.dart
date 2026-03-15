import 'package:get/get.dart';
import '../view/login_view.dart';
import '../view/signup_view.dart';
import '../view/home_view.dart';
import '../view/meals_view.dart';
import '../view/meal_detail_view.dart';
import './app_routes.dart';
import '../model/meal_detail_model.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.meals,
      page: () {
        final categoryName = Get.arguments as String? ?? 'Meals';
        return MealsView(categoryName: categoryName);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.mealDetail,
      page: () {
        final meal = Get.arguments as MealDetailModel;
        return MealDetailView(meal: meal);
      },
      transition: Transition.cupertino,
    ),
  ];
}
