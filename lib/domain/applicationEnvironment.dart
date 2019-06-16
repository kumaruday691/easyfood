import 'package:easyfood/domain/filterCriteria.dart';
import 'package:easyfood/domain/location.dart';
import 'package:easyfood/domain/unitOfWork.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as prefix0;

class ApplicationEnvironment {
  // region Constructor
  ApplicationEnvironment() {
    unitOfWork = new UnitOfWork();
    themeData = _createThemeData();
    location = null;
    filterCriteria = new FilterCriteria();
  }

  // region Properties
  UnitOfWork unitOfWork;
  ThemeData themeData;
  Location location;
  FilterCriteria filterCriteria;

  // region Public Methods
  Drawer buildApplicationDrawer(BuildContext context) {
    return Drawer(
        child: Column(
        children: <Widget>[
        AppBar(
          automaticallyImplyLeading: false,
          title: Text('Navigate'),
        ),
        ListTile(
          leading: Icon(Icons.search),
          title: Text('Filters'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        Divider(),
      ],
    ));
  }

  Future<Location> setCurrentLocation() async {
    Location currentLocation = new Location();
    Future<Location> locationFuture = currentLocation.getCurrentLocation();
    return locationFuture;
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
                onPressed: () => Navigator.of(context).pop(),
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
        accentColor: Colors.orangeAccent);
  }
}
