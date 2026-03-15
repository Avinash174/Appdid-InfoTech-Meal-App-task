import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/meal_controller.dart';
import '../routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive_helper.dart';

class MealsView extends StatelessWidget {
  final String categoryName;
  final MealController mealController = Get.find<MealController>();

  MealsView({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(categoryName, 
          style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.w900, fontSize: 22)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
      ),
      body: Obx(() {
        if (mealController.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.orange));
        }
        if (mealController.meals.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.no_meals_rounded, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('No meals found', style: TextStyle(color: Colors.grey[600], fontSize: 18)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: mealController.meals.length,
          itemBuilder: (context, index) {
            final meal = mealController.meals[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GestureDetector(
                onTap: () async {
                  await mealController.fetchMealDetail(meal.idMeal!);
                  if (mealController.selectedMeal.value != null) {
                    Get.toNamed(AppRoutes.mealDetail, arguments: mealController.selectedMeal.value!);
                  }
                },
                child: Container(
                  height: ResponsiveHelper.h(15),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Hero(
                        tag: meal.idMeal!,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
                          child: Image.network(
                            meal.strMealThumb!,
                            width: ResponsiveHelper.w(30),
                            height: ResponsiveHelper.h(15),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                meal.strMeal!,
                                style: TextStyle(
                                  fontSize: 18 * ResponsiveHelper.fontScale, 
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.timer_outlined, size: 14, color: Colors.orange[800]),
                                  const SizedBox(width: 4),
                                  Text('20-30 mins', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFE65100)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
