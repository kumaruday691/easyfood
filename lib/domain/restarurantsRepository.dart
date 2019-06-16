import 'package:easyfood/requests/googleApiRequests.dart';
import 'package:http/http.dart' as http;

import 'package:easyfood/domain/filterCriteria.dart';
import 'package:easyfood/domain/location.dart';
import 'package:easyfood/domain/restaurant.dart';
import 'package:scoped_model/scoped_model.dart';

mixin RestaurantsRepository on Model {
  
  // region Properties
  List<Restaturant> restaurants;
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

  }

  // region Helper Methods
  void _updateObserver(bool isLoading)
  {
    isLoading = isLoading;
    notifyListeners();
  }
  
}