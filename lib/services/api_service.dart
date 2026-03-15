import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import '../model/category_model.dart';
import '../model/meal_model.dart';
import '../model/meal_detail_model.dart';

// Service to handle all API communications with TheMealDB
class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Helper method to log API calls - makes it easier to debug
  void _logApiCall(String endpoint, int statusCode, String body) {
    dev.log('--- API LOG ---', name: 'api.service');
    dev.log('Endpoint: $endpoint', name: 'api.service');
    dev.log('Status: $statusCode', name: 'api.service');
    // We only log the first 200 chars to avoid flooding the console
    dev.log('Body: ${body.length > 200 ? '${body.substring(0, 200)}...' : body}', name: 'api.service');
    dev.log('---------------', name: 'api.service');
  }

  // Get all meal categories
  Future<List<CategoryModel>> fetchCategories() async {
    final url = '$baseUrl/categories.php';
    final response = await http.get(Uri.parse(url));
    
    _logApiCall(url, response.statusCode, response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> categories = data['categories'];
      return categories.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Get specific meals for a category
  Future<List<MealModel>> fetchMealsByCategory(String categoryName) async {
    final url = '$baseUrl/filter.php?c=$categoryName';
    final response = await http.get(Uri.parse(url));
    
    _logApiCall(url, response.statusCode, response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> meals = data['meals'];
      return meals.map((json) => MealModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  // Get full details for a single meal
  Future<MealDetailModel> fetchMealDetail(String mealId) async {
    final url = '$baseUrl/lookup.php?i=$mealId';
    final response = await http.get(Uri.parse(url));
    
    _logApiCall(url, response.statusCode, response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return MealDetailModel.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load meal detail');
    }
  }

  // Pick a random meal for the "Surprise Me" feature
  Future<MealDetailModel> fetchRandomMeal() async {
    final url = '$baseUrl/random.php';
    final response = await http.get(Uri.parse(url));
    
    _logApiCall(url, response.statusCode, response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return MealDetailModel.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load random meal');
    }
  }

  // Search meals by name/query
  Future<List<MealModel>> searchMeals(String query) async {
    final url = '$baseUrl/search.php?s=$query';
    final response = await http.get(Uri.parse(url));
    
    _logApiCall(url, response.statusCode, response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['meals'] == null) return [];
      final List<dynamic> meals = data['meals'];
      return meals.map((json) => MealModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search meals');
    }
  }
}
