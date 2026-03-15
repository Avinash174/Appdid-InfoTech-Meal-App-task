import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../controller/meal_controller.dart';
import '../model/category_model.dart';
import 'meals_view.dart';
import 'meal_detail_view.dart';
import 'search_delegate.dart';

class HomeView extends StatelessWidget {
  final MealController mealController = Get.put(MealController());
  final AuthController authController = Get.find<AuthController>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Text('Recipe Explorer', 
          style: TextStyle(
            fontWeight: FontWeight.w900, 
            fontSize: 24, 
            color: Colors.orange[900],
            letterSpacing: -0.5,
          )
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          _buildActionButton(
            icon: Icons.search_rounded,
            onTap: () => showSearch(context: context, delegate: MealSearchDelegate()),
          ),
          _buildActionButton(
            icon: Icons.casino_rounded,
            onTap: () async {
              mealController.isLoading.value = true;
              await mealController.fetchRandomMeal();
              mealController.isLoading.value = false;
              if (mealController.selectedMeal.value != null) {
                Get.to(() => MealDetailView(meal: mealController.selectedMeal.value!));
              }
            },
          ),
          _buildActionButton(
            icon: Icons.logout_rounded,
            onTap: () => authController.logout(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (mealController.isLoading.value && mealController.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Colors.orange));
        }
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What would you like to cook today?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Explore Categories',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = mealController.categories[index];
                    return _buildCategoryCard(category);
                  },
                  childCount: mealController.categories.length,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.orange[900], size: 22),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildCategoryCard(CategoryModel category) {
    return GestureDetector(
      onTap: () {
        mealController.fetchMealsByCategory(category.strCategory!);
        Get.to(() => MealsView(categoryName: category.strCategory!));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'category_${category.strCategory}',
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    image: DecorationImage(
                      image: NetworkImage(category.strCategoryThumb!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.strCategory!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.restaurant, size: 12, color: Colors.orange[800]),
                      const SizedBox(width: 4),
                      Text(
                        'Recipes',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
