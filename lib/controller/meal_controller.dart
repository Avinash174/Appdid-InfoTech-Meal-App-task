import 'package:get/get.dart';
import '../model/category_model.dart';
import '../model/meal_model.dart';
import '../model/meal_detail_model.dart';
import '../services/api_service.dart';

class MealController extends GetxController {
  final ApiService _apiService = ApiService();

  var categories = <CategoryModel>[].obs;
  var meals = <MealModel>[].obs;
  var selectedMeal = Rxn<MealDetailModel>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      categories.value = await _apiService.fetchCategories();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMealsByCategory(String categoryName) async {
    try {
      isLoading.value = true;
      meals.value = await _apiService.fetchMealsByCategory(categoryName);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch meals: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMealDetail(String mealId) async {
    try {
      isLoading.value = true;
      selectedMeal.value = await _apiService.fetchMealDetail(mealId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch meal detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRandomMeal() async {
    try {
      isLoading.value = true;
      selectedMeal.value = await _apiService.fetchRandomMeal();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch random meal: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchMeals(String query) async {
    try {
      isLoading.value = true;
      meals.value = await _apiService.searchMeals(query);
    } catch (e) {
      Get.snackbar('Error', 'Failed to search meals: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
