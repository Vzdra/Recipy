class MealResponse{
  String idMeal;
  String strMeal;
  String strCategory;
  String strArea;
  String strInstructions;
  String strMealThumb;
  String strTags;

  MealResponse(
      this.idMeal,
      this.strMeal,
      this.strCategory,
      this.strArea,
      this.strInstructions,
      this.strMealThumb,
      this.strTags
      );

  MealResponse.createMeal(Map<String, dynamic> json){
    this.idMeal = json["idMeal"];
    this.strMeal = json["strMeal"];
    this.strCategory = json["strCategory"];
    this.strArea = json["strArea"];
    this.strInstructions = json["strInstructions"];
    this.strMealThumb = json["strMealThumb"];
    this.strTags = json["strTags"];
  }
}