import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../controller/meal_controller.dart';
import '../app_config.dart';
import '../services/auth_service.dart';
import 'search_delegate.dart';

class HomeView extends StatelessWidget {
  final mealController = Get.put(MealController());
  final authController = Get.find<AuthController>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Column(
          children: [
            const Text('App', style: TextStyle(fontWeight: FontWeight.bold)),
            if (authService.loggedInUserIdentifier.isNotEmpty)
              Text(
                authService.loggedInUserIdentifier.value,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.grey),
              ),
          ],
        )),
        actions: [
          IconButton(
            icon: const Icon(Icons.search), 
            onPressed: () => showSearch(context: context, delegate: MealSearchDelegate()),
          ),
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
          IconButton(
            icon: const Icon(Icons.logout), 
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Obx(() {
        if (mealController.isLoading.value && mealController.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
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
