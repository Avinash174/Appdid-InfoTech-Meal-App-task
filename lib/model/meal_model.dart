class MealModel {
  String? strMeal;
  String? strMealThumb;
  String? idMeal;

  MealModel({this.strMeal, this.strMealThumb, this.idMeal});

  MealModel.fromJson(Map<String, dynamic> json) {
    strMeal = json['strMeal'];
    strMealThumb = json['strMealThumb'];
    idMeal = json['idMeal'];
  }
}
