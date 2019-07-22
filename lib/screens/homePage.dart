import 'dart:math';

import 'package:easyfood/domain/applicationEnvironment.dart';
import 'package:easyfood/domain/likedRestaurant.dart';
import 'package:easyfood/domain/location.dart';
import 'package:easyfood/domain/restaurant.dart';
import 'package:easyfood/domain/repositoryModel.dart';
import 'package:easyfood/screens/availableRestaurantsPage.dart';
import 'package:easyfood/screens/favoritesPage.dart';
import 'package:easyfood/screens/randomCardPage.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  // region Properties
  final ApplicationEnvironment applicationEnvironment;

  // region Constructor
  HomePage(this.applicationEnvironment);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  int pageIndex = 0;

  @override
  void initState() {
    // guard clause - no location found
    final ApplicationEnvironment _applicationEnvironment =
        widget.applicationEnvironment;
    _applicationEnvironment
        .setCurrentLocation(context)
        .then((Location location) {
      if (location == null) {
        _applicationEnvironment.showAlertDialog(context, "Location Error",
            "Could not fetch current location. Please check your location settings.");
        return;
      }

      widget.applicationEnvironment.location = location;
      widget.applicationEnvironment.refreshRestaurantsList();
    });

    super.initState();
  }

  Restaurant _getRandomRestaurant() {
    if( widget.applicationEnvironment.tabIndex== 1){
      return _randomizeLikedRestaurants();
    }
    else{
      return _randomizeAvailableRestaurants();
    }
    
  }

  Restaurant _randomizeLikedRestaurants() {
    List<LikedRestaurant> likedRestaurants = widget.applicationEnvironment.unitOfWork.likedRestaurants.values.toList();
    if (likedRestaurants.length == 0) {
     
      return null;
    }

    Restaurant backedUpRestaurant = new Restaurant();
    int maxLength = likedRestaurants.length;
    if (maxLength == 1) {
      backedUpRestaurant.copyFromBackUp(likedRestaurants[0]);
      return backedUpRestaurant;
    }

    int randomIndex = 0 + new Random().nextInt(maxLength);
    backedUpRestaurant.copyFromBackUp(likedRestaurants[randomIndex]);
    return backedUpRestaurant;
  }

  Restaurant _randomizeAvailableRestaurants(){
    List<Restaurant> availableRestaurants =
        widget.applicationEnvironment.unitOfWork.restaurants;
    if (availableRestaurants.length == 0) {
      widget.applicationEnvironment.showAlertDialog(
          context, "Error", "No restaurants found to randomize");
      return null;
    }

    int maxLength = availableRestaurants.length;
    if (maxLength == 1) {
      return availableRestaurants[0];
    }

    int randomIndex = 0 + new Random().nextInt(maxLength);
    return availableRestaurants[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    ApplicationEnvironment _appEnv = widget.applicationEnvironment;

    List<Widget> pages = new List<Widget>();
    pages.add(AvailableRestaurantsPage(_appEnv));
    pages.add(FavoritesPage(_appEnv));

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        drawer: _appEnv.buildApplicationDrawer(context),
        appBar: GradientAppBar(
          title: Text('Eat-dom'),
          backgroundColorStart: Color(0xffff512f),
          backgroundColorEnd: Color(0xffdd2476),
          actions: <Widget>[
            ScopedModelDescendant<RepositoryModel>(
              builder: (context, child, model) {
                return IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    model.fetchRestaurants(
                        _appEnv.location, _appEnv.filterCriteria);
                  },
                );
              },
            )
          ],
        ),
        body: TabBarView(
          children: pages,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //navigateToCreateGoal(GoalClass("", ""));
            widget.applicationEnvironment.previouslyRandomizedRestaurant = null;
            Restaurant randomRestaurant = this._getRandomRestaurant();
            if(randomRestaurant == null){
              showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid"),
            content: Text("No restaurant found to randomize."),
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
              return;
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RandomCardPage(
                        randomRestaurant,
                        widget.applicationEnvironment)));
          },
          child: Icon(Icons.directions_run),
          elevation: 3.0,
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: new TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.restaurant)),
              Tab(icon: Icon(Icons.favorite))
            ],
            unselectedLabelColor: Colors.blueGrey,
            labelColor: Theme.of(context).accentColor,
            indicatorColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
