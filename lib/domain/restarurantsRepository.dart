import 'dart:convert';

import 'package:easyfood/requests/googleApiRequests.dart';
import 'package:http/http.dart' as http;

import 'package:easyfood/domain/filterCriteria.dart';
import 'package:easyfood/domain/location.dart';
import 'package:easyfood/domain/restaurant.dart';
import 'package:scoped_model/scoped_model.dart';

mixin RestaurantsRepository on Model {
  
  // region Properties
  List<Restaurant> restaurants;
  bool isLoading;

  // region Public Methods
  Future<bool> fetchRestaurants(Location location, FilterCriteria filterCriteria) async
  {
    // guard clause - invalid
    if(location == null || filterCriteria == null) 
    {
      return false;
    }

    this._updateObserver(true);
    http.Response response = await GoogleApiRequests.fetchRestaurants(location, filterCriteria);
    if(response.statusCode != 200)
    {
      this._updateObserver(false);
      return false;
    }

    Map<String, dynamic> responseJson = json.decode(response.body);
    if(!responseJson.containsKey("status"))
    {
      this._updateObserver(false);
      return false;
    }

    if(responseJson["status"] != "OK")
    {
      this._updateObserver(false);
      return false;
    }

    if(!responseJson.containsKey("results"))
    {
      this._updateObserver(false);
      return false;
    }

    List<dynamic> resultsList = responseJson["results"];
    resultsList.forEach((propertyMap) => this._createNewRestaurant(propertyMap));
    this._updateObserver(false);

    return true;

  }

  // region Helper Methods
  void _createNewRestaurant(dynamic restaurantProps)
  {
    Restaurant newRestaurant = new Restaurant();
    bool isParsed = newRestaurant.copyFrom(restaurantProps);
    if(isParsed)
    {
      this.restaurants.add(newRestaurant);
    }
  }

  void _updateObserver(bool isLoading)
  {
    isLoading = isLoading;
    notifyListeners();
  }
  
}