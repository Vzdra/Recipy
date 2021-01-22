import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MealResponse.dart';

class AddRecipe extends StatefulWidget{
  var resetItem;

  AddRecipe(this.resetItem);

  @override
  State<StatefulWidget> createState() => _AddRecipeState(resetItem);
}

class _AddRecipeState extends State<AddRecipe> {

  var resetItem;

  File _image;
  final nameController = TextEditingController();
  final fieldController = TextEditingController();
  final picker = ImagePicker();

  _AddRecipeState(this.resetItem);

  @override
  void dispose(){
    nameController.dispose();
    fieldController.dispose();
    super.dispose();
  }

  Future _imageFromCamera() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image selected!");
      }
    });
  }

  Future _imageFromGallery() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image selected!");
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
              child: Container(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text("Photo Library"),
                      onTap: () {
                        _imageFromGallery();
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_camera),
                      title: Text("Camera"),
                      onTap: () {
                        _imageFromCamera();
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              )
          );
        });
  }


  _saveItems(String name, String description, String imageUri) async {
    if (name.isNotEmpty && description.isNotEmpty && imageUri.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();

      MealResponse meal = MealResponse.forMapping(
          "asd", name, description, imageUri, false);
      String items = prefs.getString("meals");
      if (items == null) {
        List<MealResponse> meals2 = [];
        meals2.add(meal);
        await prefs.setString("meals", MealResponse.encode(meals2));
      } else {
        var meals = MealResponse.decode(items);
        meals.add(meal);
        await prefs.setString("meals", MealResponse.encode(meals));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final cWidth = MediaQuery
        .of(context)
        .size
        .width / 1.1;

    return Scaffold(
        appBar: AppBar(
          title: Text("Recipy"),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                    onTap: () async {
                      resetItem();
                      await _saveItems(nameController.text, fieldController.text, _image.path);
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.done_sharp,
                      size: 26.0,
                    )
                )
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 32,
              ),
              Center(
                child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey,
                      child: _image != null
                          ? null : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(50)
                        ),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
                      backgroundImage: _image != null
                          ? FileImage(_image)
                          : null,
                    )
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Center(
                  child: SizedBox(
                    width: cWidth,
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          hintText: "Enter name..."
                      ),
                    ),
                  )
              ),
              SizedBox(
                height: 32,
              ),
              Center(
                  child: SizedBox(
                    width: cWidth,
                    child: TextField(
                      controller: fieldController,
                      decoration: InputDecoration(
                          hintText: "Enter instructions...",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.cyan,
                                  width: .5
                              )
                          )
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  )
              ),
            ],
          ),
        )
    );
  }
}

