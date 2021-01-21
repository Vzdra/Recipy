import 'package:flutter/material.dart';
import 'package:info_app/MealResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
          child: FutureBuilder(
            future: _getFavorites(),
            builder: (context, AsyncSnapshot<List<MealResponse>> snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index){
                      MealResponse mealResponse = snapshot.data[index];
                      return ListTile(
                        trailing: CircleAvatar(
                          backgroundImage: NetworkImage(mealResponse.strMealThumb),
                        ),
                        title: Text(mealResponse.strMeal),
                      );
                    }
                );
              }
              return Center(
                child: Text("No favored meals!"),
              );
            },
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