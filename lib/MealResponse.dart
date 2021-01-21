import 'dart:convert';


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

  MealResponse.forMapping(String id, String name, String desc, String img){
    this.idMeal = id;
    this.strMeal = name;
    this.strInstructions = desc;
    this.strMealThumb = img;
  }

  MealResponse.essentials(Map<String, dynamic> json){
    this.idMeal = json["id"];
    this.strMeal = json["name"];
    this.strInstructions = json["description"];
    this.strMealThumb = json["thumb"];
  }

  MealResponse.createMeal(Map<String, dynamic> json){
    this.idMeal = json["idMeal"];
    this.strMeal = json["strMeal"];
    this.strCategory = json["strCategory"];
    this.strArea = json["strArea"];
    this.strInstructions = json["strInstructions"];
    this.strMealThumb = json["strMealThumb"];
    this.strTags = json["strTags"];
  }

  factory MealResponse.fromJson(Map<String, dynamic> jsonData){
    return new MealResponse.essentials(jsonData);
  }

  static Map<String, dynamic> toMap(MealResponse mealResponse) => {
    'id': mealResponse.idMeal,
    'name': mealResponse.strMeal,
    'description': mealResponse.strInstructions,
    'thumb': mealResponse.strMealThumb
  };

  static String encode(List<MealResponse> meals) => json.encode(
      meals.map<Map<String, dynamic>>((meal) => MealResponse.toMap(meal)).toList()
  );

  static bool checkExists(MealResponse meal,List<MealResponse> meals) {
    meals.forEach((element) {
      if(element.idMeal== meal.idMeal){
        return true;
      }
    });

    return false;
  }

  static List<MealResponse> decode(String meals) => (
    json.decode(meals) as List<dynamic>)
      .map<MealResponse>((item) => MealResponse.fromJson(item)).toList();
}