import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:info_app/HomeDetails.dart';
import 'package:info_app/MealResponse.dart';
import 'package:info_app/Response.dart';

class DetailsWidget extends StatelessWidget{
  final String id;

  DetailsWidget(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipy"),
      ),
      body: Container(
        child: FutureBuilder<MealResponse>(
          future: _getById(id),
          builder: (BuildContext context, AsyncSnapshot<MealResponse> snapshot){
            if(snapshot.hasData){
              return HomeDetails(snapshot.data.strMeal, snapshot.data.strInstructions, snapshot.data.strMealThumb);
            }
            return Center(
              child: Text("Error loading item!"),
            );
          },
        )
      ),
    );
  }
}

Future<MealResponse> _getById(String id) async {
  final response = await http.get("https://www.themealdb.com/api/json/v1/1/lookup.php?i=" + id);

  if(response.statusCode == 200){
    Map vals = jsonDecode(response.body);
    var res = Response.fromJson(vals);
    var mealResponse = res.meals[0];
    return mealResponse;
  }

  return null;
}