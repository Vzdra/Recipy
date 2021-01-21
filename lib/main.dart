import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:info_app/Home.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String title = "Recipy";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Home(title: title),
    );
  }
}
