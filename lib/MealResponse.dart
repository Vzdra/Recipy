import 'dart:convert';


class MealResponse{
  String idMeal;
  String strMeal;
  String strCategory;
  String strArea;
  String strInstructions;
  String strMealThumb;
  String strTags;
  bool network;

  MealResponse(
      this.idMeal,
      this.strMeal,
      this.strCategory,
      this.strArea,
      this.strInstructions,
      this.strMealThumb,
      this.strTags,
      this.network
      );

  MealResponse.forMapping(String id, String name, String desc, String img, bool network){
    this.idMeal = id;
    this.strMeal = name;
    this.strInstructions = desc;
    this.strMealThumb = img;
    this.network = network;
  }

  MealResponse.essentials(Map<String, dynamic> json){
    this.idMeal = json["id"];
    this.strMeal = json["name"];
    this.strInstructions = json["description"];
    this.strMealThumb = json["thumb"];

    if(json["network"] == "true"){
      this.network = true;
    }else{
      this.network = false;
    }
  }

  MealResponse.createMeal(Map<String, dynamic> json){
    this.idMeal = json["idMeal"];
    this.strMeal = json["strMeal"];
    this.strCategory = json["strCategory"];
    this.strArea = json["strArea"];
    this.strInstructions = json["strInstructions"];
    this.strMealThumb = json["strMealThumb"];
    this.strTags = json["strTags"];

    if(json["network"] == "true"){
      this.network = true;
    }else{
      this.network = false;
    }
  }

  factory MealResponse.fromJson(Map<String, dynamic> jsonData){
    return new MealResponse.essentials(jsonData);
  }

  static Map<String, dynamic> toMap(MealResponse mealResponse) => {
    'id': mealResponse.idMeal,
    'name': mealResponse.strMeal,
    'description': mealResponse.strInstructions,
    'thumb': mealResponse.strMealThumb,
    'network': mealResponse.network.toString()
  };

  static String encode(List<MealResponse> meals) => json.encode(
      meals.map<Map<String, dynamic>>((meal) => MealResponse.toMap(meal)).toList()
  );

  static List<MealResponse> decode(String meals) => (
    json.decode(meals) as List<dynamic>)
      .map<MealResponse>((item) => MealResponse.fromJson(item)).toList();
}