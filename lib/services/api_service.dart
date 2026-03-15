import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/category_model.dart';
import '../model/meal_model.dart';
import '../model/meal_detail_model.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> categories = data['categories'];
      return categories.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<MealModel>> fetchMealsByCategory(String categoryName) async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?c=$categoryName'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> meals = data['meals'];
      return meals.map((json) => MealModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<MealDetailModel> fetchMealDetail(String mealId) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$mealId'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return MealDetailModel.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load meal detail');
    }
  }

  Future<MealDetailModel> fetchRandomMeal() async {
    final response = await http.get(Uri.parse('$baseUrl/random.php'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return MealDetailModel.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load random meal');
    }
  }

  Future<List<MealModel>> searchMeals(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data['meals'] == null) return [];
      List<dynamic> meals = data['meals'];
      return meals.map((json) => MealModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search meals');
    }
  }
}
