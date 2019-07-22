import 'dart:convert';

import 'package:easyfood/domain/restaurantDetail.dart';
import 'package:easyfood/requests/googleApiRequests.dart';
import 'package:http/http.dart' as http;

import 'package:easyfood/domain/filterCriteria.dart';
import 'package:easyfood/domain/restaurant.dart';
import 'package:scoped_model/scoped_model.dart';

mixin RestaurantsRepository on Model {
  
  // region Properties
  List<Restaurant> restaurants;
  bool isLoading;

  // region Public Methods
 
  Future<RestaurantDetail> getRestaurantDetail(String placeId) async
  {
    this.isLoading = true;
    http.Response response = await GoogleApiRequests.fetchRestaurantDetail(placeId);
    if(response.statusCode != 200)
    {
      this.updateObserver(false);
      return null;
    }

    Map<String, dynamic> responseJson = json.decode(response.body);
    if(!responseJson.containsKey("status"))
    {
      this.updateObserver(false);
      return null;
    }

    if(responseJson["status"] != "OK")
    {
      this.updateObserver(false);
      return null;
    }

    Map<String, dynamic> resultMap = responseJson["result"];
    this.updateObserver(false);
    return new RestaurantDetail().copyFrom(resultMap);
  }

  // region Shared Methods
  void createNewRestaurant(dynamic restaurantProps, FilterCriteria filterCriteria, List<String> likableIds)
  {
    Restaurant newRestaurant = new Restaurant();
    bool isParsed = newRestaurant.copyFrom(restaurantProps);
    if(isParsed)
    {
      if(filterCriteria.openNow && !newRestaurant.isOpen){
        return;
      }

      if(likableIds.contains(newRestaurant.placeReference)){
        newRestaurant.isLiked = true;
      }
      this.restaurants.add(newRestaurant);
    }
  }

  void updateObserver(bool isWaiting)
  {
    isLoading = isWaiting;
    notifyListeners();
  }
  
}