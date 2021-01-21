import 'package:info_app/MealResponse.dart';

class Response {
  List<MealResponse> meals = [];

  Response(this.meals);

  Response.fromJson(Map<String, dynamic> json){
    List<dynamic> mealitems = json["meals"];
    mealitems.forEach((element) {
      var meal = MealResponse.createMeal(element);
      meals.add(meal);
    });
  }
}