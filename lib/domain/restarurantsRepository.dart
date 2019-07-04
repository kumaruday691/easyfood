import 'dart:convert';

import 'package:easyfood/domain/restaurantDetail.dart';
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
    this.restaurants.clear();
    resultsList.forEach((propertyMap) => this._createNewRestaurant(propertyMap, filterCriteria));
    this._updateObserver(false);

    return true;
  }

  Future<RestaurantDetail> getRestaurantDetail(String placeId) async
  {
    this.isLoading = true;
    http.Response response = await GoogleApiRequests.fetchRestaurantDetail(placeId);
    if(response.statusCode != 200)
    {
      this._updateObserver(false);
      return null;
    }

    Map<String, dynamic> responseJson = json.decode(response.body);
    if(!responseJson.containsKey("status"))
    {
      this._updateObserver(false);
      return null;
    }

    if(responseJson["status"] != "OK")
    {
      this._updateObserver(false);
      return null;
    }

    Map<String, dynamic> resultMap = responseJson["result"];
    this._updateObserver(false);
    return new RestaurantDetail().copyFrom(resultMap);
  }

  // region Helper Methods
  void _createNewRestaurant(dynamic restaurantProps, FilterCriteria filterCriteria)
  {
    Restaurant newRestaurant = new Restaurant();
    bool isParsed = newRestaurant.copyFrom(restaurantProps);
    if(isParsed)
    {
      if(filterCriteria.openNow && !newRestaurant.isOpen){
        return;
      }

      this.restaurants.add(newRestaurant);
    }
  }

  void _updateObserver(bool isWaiting)
  {
    isLoading = isWaiting;
    notifyListeners();
  }
  
}