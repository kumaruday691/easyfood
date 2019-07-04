import 'dart:convert';
import 'package:easyfood/domain/filterCriteria.dart';
import 'package:easyfood/domain/location.dart';
import 'package:easyfood/domain/restaurant.dart';
import 'package:easyfood/domain/unitOfWork.dart';
import 'package:easyfood/screens/filterPage.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationEnvironment {

  // region Constructor
  ApplicationEnvironment() {
    unitOfWork = new UnitOfWork();
    themeData = _createThemeData();
    location = null;
    previouslyRandomizedRestaurant = null;

    _findOrAddFilterCriteria(); 
  }

  // region Properties
  UnitOfWork unitOfWork;
  ThemeData themeData;
  Location location;
  FilterCriteria filterCriteria;
  Restaurant previouslyRandomizedRestaurant;

  // region Public Methods
  Drawer buildApplicationDrawer(BuildContext context) {
    return Drawer(
        child: Column(
        children: <Widget>[
        GradientAppBar(
          automaticallyImplyLeading: false,
          title: Text('Navigate'),
          backgroundColorStart: Color(0xffff512f),
          backgroundColorEnd: Color(0xffdd2476),
        ),
        ListTile(
          leading: Icon(Icons.search),
          title: Text('Filters'),
          onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage(this)));
          },
        ),
        Divider(),
      ],
    ));
  }

  Future<bool> refreshRestaurantsList()
  {
    unitOfWork.restaurants.clear();
    return unitOfWork.fetchRestaurants(location, filterCriteria);
  }

  Future<Location> setCurrentLocation(BuildContext context) async {
    try{
    Location currentLocation = new Location();
    Future<Location> locationFuture = currentLocation.getCurrentLocation();
    return locationFuture;
    }
    on Exception catch(e)
    {
      showAlertDialog(context, "Network Error", "Failed to fetch current location");
    }
  }

  AlertDialog showAlertDialog(
      BuildContext context, String alertHeader, String alertText) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(alertHeader),
            content: Text(alertText),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: () => {
                  Navigator.of(context).pop()
                  },
              )
            ],
          );
        });
  }

  // region helper Methods
  ThemeData _createThemeData() {
    // TODO: UK - implement dark theme when app is ready
    return ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        accentColor: Colors.orangeAccent,
        cardColor: Colors.tealAccent,
        );
  }

  void _findOrAddFilterCriteria() async{
    FilterCriteria defaultFilterCriteria = new FilterCriteria();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String filterCriteriaString = prefs.getString('filterCriteria');
    if(filterCriteriaString == null || filterCriteriaString.isEmpty || filterCriteriaString == "null"){
      this.filterCriteria =  defaultFilterCriteria;
      return;
    }

    Map<String, dynamic> criteriaMap = jsonDecode(filterCriteriaString);
    if(criteriaMap == null){
      this.filterCriteria = defaultFilterCriteria;
      return;
    }

    defaultFilterCriteria.copyFrom(criteriaMap);
    this.filterCriteria = defaultFilterCriteria;
  }

}
