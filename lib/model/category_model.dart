class CategoryModel {
  String? idCategory;
  String? strCategory;
  String? strCategoryThumb;

  CategoryModel({this.idCategory, this.strCategory, this.strCategoryThumb});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    idCategory = json['idCategory'];
    strCategory = json['strCategory'];
    strCategoryThumb = json['strCategoryThumb'];
  }
}
