import 'dart:io';

import 'package:flutter/material.dart';
import 'package:info_app/HomeDetails.dart';
import 'package:info_app/MealResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _FavoritesWidgetState();
}


class _FavoritesWidgetState extends State<FavoritesWidget>{

  var items = [];

  @override
  void initState() {
    super.initState();

    setStuff();
  }

  void setStuff() async{
    var it = await _getFavorites();
    setState(() {
      items = it;
    });
  }

  _removeItem(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<MealResponse> meals = MealResponse.decode(prefs.getString("meals"));

    for(var i = 0; i< meals.length; i++){
      if(meals[i].idMeal == id){
        meals.removeAt(i);
      }
    }

    await prefs.setString("meals", MealResponse.encode(meals));

    setState(() {
      items = meals;
    });

    print(items);
  }

  @override
  Widget build(BuildContext context) {
    print(items);

    return Container(
      child: SafeArea(
          child: items.length != 0 ? ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                MealResponse mealResponse = items[index];
                return ListTile(
                  onLongPress: () => _removeItem(mealResponse.idMeal),
                  onTap: () =>
                  {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) =>
                        Scaffold(
                            appBar: AppBar(
                              title: Text("Recipy"),
                            ),
                            body: mealResponse.network
                                ? HomeDetails(
                                mealResponse.idMeal,
                                mealResponse.strMeal,
                                mealResponse.strInstructions,
                                mealResponse.strMealThumb,
                                true, true)
                                : HomeDetails(mealResponse.idMeal,
                                mealResponse.strMeal,
                                mealResponse.strInstructions,
                                mealResponse.strMealThumb,
                                true, false)
                        )
                    ))
                  },
                  trailing: CircleAvatar(
                      backgroundImage: mealResponse.network
                          ? NetworkImage(mealResponse.strMealThumb)
                          : FileImage(File(mealResponse.strMealThumb))
                  ),
                  title: Text(mealResponse.strMeal),
                );
              }
          ) : Center(
            child: Text("No items favored!"),
          )
      ),
    );
  }
}


Future<List<MealResponse>> _getFavorites() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<MealResponse> meals = MealResponse.decode(prefs.getString("meals"));
  return meals;
}