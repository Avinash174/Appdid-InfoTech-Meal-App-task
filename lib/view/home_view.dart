import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../controller/meal_controller.dart';
import '../app_config.dart';
import 'search_delegate.dart';

class HomeView extends StatelessWidget {
  // Inject our controllers
  final mealController = Get.put(MealController());
  final authController = Get.find<AuthController>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // 1. Search button
          IconButton(
            icon: const Icon(Icons.search), 
            onPressed: () => showSearch(context: context, delegate: MealSearchDelegate()),
          ),
          
          // 2. Random Meal button (requirement #6)
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: 'Surprise Me',
            onPressed: () async {
              await mealController.fetchRandomMeal();
              if (mealController.selectedMeal.value != null) {
                Get.toNamed(AppRoutes.mealDetail, arguments: mealController.selectedMeal.value!);
              }
            },
          ),

          // 3. Logout button
          IconButton(
            icon: const Icon(Icons.logout), 
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Obx(() {
        // Show loader if we're fetching categories for the first time
        if (mealController.isLoading.value && mealController.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Grid display for all categories
        return GridView.builder(
          padding: EdgeInsets.all(4.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Get.width > 600 ? 3 : 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 3.w,
          ),
          itemCount: mealController.categories.length,
          itemBuilder: (context, index) {
            final cat = mealController.categories[index];
            return GestureDetector(
              onTap: () {
                mealController.fetchMealsByCategory(cat.strCategory!);
                Get.toNamed(AppRoutes.meals, arguments: cat.strCategory!);
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Expanded(
                      child: Hero(
                        tag: 'cat-${cat.strCategory}',
                        child: Image.network(
                          cat.strCategoryThumb!, 
                          fit: BoxFit.cover, 
                          width: double.infinity
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Text(
                        cat.strCategory!, 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
