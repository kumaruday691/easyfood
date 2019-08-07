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
    nextPageToken = null;
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

    _extractAndAddRestaurantsIfApplicable(response, filterCriteria, true);
    if(nextPageToken !=null){
      fetchNextPageRestaurants(filterCriteria);
    }
  }

  void fetchNextPageRestaurants(FilterCriteria filterCriteria) async{
    http.Response response = await GoogleApiRequests.fetchNextPageRestaurants(nextPageToken);
    if(response.statusCode != 200)
    {
      updateObserver(false);
      return;
    }

    _extractAndAddRestaurantsIfApplicable(response, filterCriteria, false);
    if(this.nextPageToken != null){
      fetchNextPageRestaurants(filterCriteria);
    }
  }

  // region Helper Methods
  Future<String> _extractAndAddRestaurantsIfApplicable(http.Response response, FilterCriteria filterCriteria, bool shouldClearInitially) async{
    Map<String, dynamic> responseJson = json.decode(response.body);
    if(!responseJson.containsKey("status"))
    {
      updateObserver(false);
      return null;
    }

    if(responseJson["status"] != "OK")
    {
      updateObserver(false);
      return null;
    }

    if(!responseJson.containsKey("results"))
    {
      updateObserver(false);
      return null;
    }

    this.nextPageToken = responseJson["next_page_token"];
    List<dynamic> resultsList = responseJson["results"];

    if(shouldClearInitially){
    this.restaurants.clear();
    }

    resultsList.forEach((propertyMap) => createNewRestaurant(propertyMap, filterCriteria, likedRestaurants.keys.toList()));
    updateObserver(false);

    return nextPageToken;

  }


}