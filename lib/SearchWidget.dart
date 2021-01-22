import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:info_app/DetailsWidget.dart';
import 'package:info_app/HomeDetails.dart';
import 'package:info_app/MealResponse.dart';
import 'dart:convert';

import 'package:info_app/Response.dart';

class SearchWidget extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<MealResponse>(
            onSearch: search,
            onItemFound: (MealResponse mealResponse, int index) {
              return ListTile(
                onTap:() => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    DetailsWidget(mealResponse.idMeal)
                  ))
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(mealResponse.strMealThumb),
                ),
                title: Text(mealResponse.strMeal),
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<List<MealResponse>> search(String search) async{
  final response = await http.get("https://www.themealdb.com/api/json/v1/1/filter.php?i=" + search);

  if(response.statusCode == 200){
    Map vals = jsonDecode(response.body);
    var res = Response.fromJson(vals);
    return res.meals;
  }

  return null;
}