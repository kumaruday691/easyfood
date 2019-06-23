import 'package:easyfood/domain/filterCriteria.dart';
import 'package:easyfood/domain/location.dart';
import 'package:easyfood/domain/restaurant.dart';
import 'package:easyfood/domain/unitOfWork.dart';
import 'package:easyfood/screens/filterPage.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class ApplicationEnvironment {

  // region Constructor
  ApplicationEnvironment() {
    unitOfWork = new UnitOfWork();
    themeData = _createThemeData();
    location = null;
    filterCriteria = new FilterCriteria();
    previouslyRandomizedRestaurant = null;
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage()));
          },
        ),
        Divider(),
      ],
    ));
  }

  Future<bool> refreshRestaurantsList()
  {
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
}
