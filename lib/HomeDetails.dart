import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:info_app/MealResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDetails extends StatelessWidget{

  final String id;
  final String title;
  final String description;
  final String image;
  final bool owned;
  final bool network;



  HomeDetails(this.id, this.title, this.description, this.image, this.owned, this.network);

  @override
  Widget build(BuildContext context) {

    final cWidth = MediaQuery.of(context).size.width/1.1;

    return Container(
      child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: !owned ? OutlineButton(
                      onPressed:() => _saveItem(title, description, image),
                      child: Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ),
                      borderSide: BorderSide(
                          color: Colors.green
                      ),
                    ) : null,
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
                    backgroundImage: network ? NetworkImage(image) : FileImage(File(image)),
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
                        maxWidth: cWidth,
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: 20,
                                letterSpacing: .5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: cWidth,
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
  MealResponse meal = MealResponse.forMapping("0", title, description, imageUrl, true);
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