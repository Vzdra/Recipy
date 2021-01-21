import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:info_app/MealResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDetails extends StatelessWidget{

  final String id;
  final String title;
  final String description;
  final String image;

  HomeDetails(this.id, this.title, this.description, this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: OutlineButton(
                    onPressed:() => _saveItem(title, description, image),
                    child: Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                    ),
                    borderSide: BorderSide(
                      color: Colors.green
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                  height: 50,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(image),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  height: 30,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    title,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5
                    )
                )
              ],
            ),
            Row(
              children: [
                Container(
                  height: 30,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width/1.1,
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      children: [
                        Text(
                          description,
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: .5
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                )
              ],
            ),
            Row(
              children: [
                Container(
                  height: 30,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

_saveItem(String title, String description, String imageUrl) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  MealResponse meal = MealResponse.forMapping("0", title, description, imageUrl);
  String items = prefs.getString("meals");
  if(items == null){
    List<MealResponse> meals2 = [];
    meals2.add(meal);
    await prefs.setString("meals", MealResponse.encode(meals2));
  }else{
    var meals = MealResponse.decode(items);
    print('Checking');
    if(!MealResponse.checkExists(meal, meals)){
      meals.add(meal);
      await prefs.setString("meals", MealResponse.encode(meals));
    }
  }
}