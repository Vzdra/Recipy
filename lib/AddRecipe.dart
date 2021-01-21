import 'package:flutter/material.dart';

class AddRecipe extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipy"),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () => {

                  },
                  child: Icon(
                    Icons.approval,
                    size: 26.0,
                  )
              )
          )
        ],
      ),
    )
  }

}