import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/meal_controller.dart';
import '../app_config.dart';

class MealsView extends StatelessWidget {
  final String categoryName;
  final mealController = Get.find<MealController>();

  MealsView({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: Obx(() {
        if (mealController.isLoading.value) return const Center(child: CircularProgressIndicator());
        return ListView.builder(
          padding: EdgeInsets.all(4.w),
          itemCount: mealController.meals.length,
          itemBuilder: (context, index) {
            final meal = mealController.meals[index];
            return Card(
              margin: EdgeInsets.only(bottom: 2.h),
              child: ListTile(
                leading: Hero(
                  tag: 'meal-${meal.idMeal}',
                  child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(meal.strMealThumb!, width: 60, height: 60, fit: BoxFit.cover)),
                ),
                title: Text(meal.strMeal!, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  await mealController.fetchMealDetail(meal.idMeal!);
                  if (mealController.selectedMeal.value != null) {
                    Get.toNamed(AppRoutes.mealDetail, arguments: mealController.selectedMeal.value!);
                  }
                },
              ),
            );
          },
        );
      }),
    );
  }
}
