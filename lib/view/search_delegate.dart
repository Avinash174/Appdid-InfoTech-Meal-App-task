import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/meal_controller.dart';
import 'meal_detail_view.dart';

class MealSearchDelegate extends SearchDelegate {
  final MealController mealController = Get.find<MealController>();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      mealController.searchMeals(query);
    }
    return Obx(() {
      if (mealController.isLoading.value) return Center(child: CircularProgressIndicator());
      if (mealController.meals.isEmpty) return Center(child: Text('No meals found for "$query"'));
      
      return ListView.builder(
        itemCount: mealController.meals.length,
        itemBuilder: (context, index) {
          final meal = mealController.meals[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(meal.strMealThumb!, width: 50, height: 50, fit: BoxFit.cover),
            ),
            title: Text(meal.strMeal!, style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () async {
              await mealController.fetchMealDetail(meal.idMeal!);
              if (mealController.selectedMeal.value != null) {
                Get.to(() => MealDetailView(meal: mealController.selectedMeal.value!));
              }
            },
          );
        },
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child: Text('Search for delicious meals...'));
  }
}
