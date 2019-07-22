import 'dart:convert';

import 'package:easyfood/domain/filterCriteria.dart';
import 'package:easyfood/domain/likedRestaurantsRepository.dart';
import 'package:easyfood/domain/location.dart';
import 'package:easyfood/domain/restarurantsRepository.dart';
import 'package:easyfood/requests/googleApiRequests.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class RepositoryModel extends Model with RestaurantsRepository, LikedRestaurantsRepository
{
  
  // region Constructors
  RepositoryModel()
  {
    restaurants = [];
    likedRestaurants = {};
    isLoading = false;
  }
  
  // region Public Methods
   Future<bool> fetchRestaurants(Location location, FilterCriteria filterCriteria) async
  {
    // guard clause - invalid
    if(location == null || filterCriteria == null) 
    {
      return false;
    }

    updateObserver(true);
    http.Response response = await GoogleApiRequests.fetchRestaurants(location, filterCriteria);
    if(response.statusCode != 200)
    {
      updateObserver(false);
      return false;
    }

    Map<String, dynamic> responseJson = json.decode(response.body);
    if(!responseJson.containsKey("status"))
    {
      updateObserver(false);
      return false;
    }

    if(responseJson["status"] != "OK")
    {
      updateObserver(false);
      return false;
    }

    if(!responseJson.containsKey("results"))
    {
      updateObserver(false);
      return false;
    }

    List<dynamic> resultsList = responseJson["results"];
    this.restaurants.clear();
    resultsList.forEach((propertyMap) => createNewRestaurant(propertyMap, filterCriteria, likedRestaurants.keys.toList()));
    updateObserver(false);

    return true;
  }


}