import 'package:flutter/material.dart';
import 'package:info_app/AddRecipe.dart';
import 'package:info_app/FavoritesWidget.dart';
import 'package:info_app/HomeDetails.dart';
import 'package:http/http.dart' as http;
import 'package:info_app/MealResponse.dart';
import 'package:info_app/Response.dart';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'SearchWidget.dart';

class Home extends StatefulWidget{

  final String title;

  Home({
    Key key,
    this.title
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState(title);
}

class _HomeState extends State<Home>{

  FlutterLocalNotificationsPlugin localNotificationsPlugin;

  int _selectedIndex = 0;
  String title;

  String _itemTitle;
  String _itemDescription;
  String _imageUrl;
  String _itemId;

  List<Widget> _widgetOptions = <Widget>[];

  _HomeState(this.title);

  Map<String, String> item;

  @override
  void initState() {
    super.initState();
    var androidInitialize = new AndroidInitializationSettings('ic_launcher');
    var iosInitialize = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(
        android: androidInitialize,
        iOS: iosInitialize
    );

    localNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    localNotificationsPlugin.initialize(initSettings);


    if(_itemTitle==null){
      fetchRandom().then((value){
        MealResponse res = value.meals[0];

        setState(() {
          _itemId = res.idMeal;
          _itemTitle = res.strMeal;
          _itemDescription = res.strInstructions;
          _imageUrl = res.strMealThumb;
        });
        setState(() {
          _widgetOptions.add(
              HomeDetails(_itemId, _itemTitle, _itemDescription, _imageUrl, false, true),
          );
          _widgetOptions.add(SearchWidget());
          _widgetOptions.add(FavoritesWidget());
        });
      }).catchError((onError) {
        setState(() {
          _itemId = "";
          _itemTitle ="No network connection.";
          _itemDescription = "";
          _imageUrl = "";
        });
        setState(() {
          _widgetOptions.add(
            HomeDetails(_itemId, _itemTitle, _itemDescription, _imageUrl, true, true),
          );
          _widgetOptions.add(SearchWidget());
          _widgetOptions.add(FavoritesWidget());
        });
      });
    }

    _showNotifications();
  }

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  void _resetItem(){
    setState(() {
      _selectedIndex = 0;
    });
  }

  Future _showNotifications() async{
    var androidDetails = new AndroidNotificationDetails(
        "repeating channel id",
        "Local Notification",
        "Testing purposes.",
      importance: Importance.max
    );

    var iOSDetails = new IOSNotificationDetails();

    var generalNotificationDetails = new NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails
    );

    await localNotificationsPlugin.periodicallyShow(0, "Recipy!", "Try something new!", RepeatInterval.everyMinute, generalNotificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    if(_widgetOptions!=null && _widgetOptions.length>0){
      return Scaffold(
        appBar: AppBar(
            title: Text(title),
            centerTitle: true,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      AddRecipe(_resetItem)
                    ))
                  },
                  child: Icon(
                    Icons.add,
                    size: 26.0,
                  )
                )
            )
          ],
        ),
        body: Container(
            child: _widgetOptions.elementAt(_selectedIndex)
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                  icon: new Icon(Icons.search),
                  label: "Find"
              ),
              BottomNavigationBarItem(
                  icon: new Icon(Icons.star),
                  label: "Favorites"
              )
            ],
            selectedItemColor: Colors.cyan,
            onTap: _onItemTapped,
            unselectedItemColor: Colors.grey
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Text("Loading Data!")
      ),
    );
  }
}

Future<Response> fetchRandom() async {
  final response = await http.get("https://www.themealdb.com/api/json/v1/1/random.php");

  if(response.statusCode == 200){
    Map vals = jsonDecode(response.body);
    var res = Response.fromJson(vals);
    return res;
  }

  return null;
}