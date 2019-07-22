import 'dart:convert';

import 'package:easyfood/domain/likedRestaurant.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin LikedRestaurantsRepository on Model {
  // region Properties
  Map<String, LikedRestaurant> likedRestaurants;
  bool isLoading;

  // region Public Methods
  Future<bool> loadLikedRestaurants() async {
    this.isLoading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String likedRestaurantsString = prefs.getString('likedRestaurants');
    if (likedRestaurantsString == null ||
        likedRestaurantsString.isEmpty ||
        likedRestaurantsString == "null") {
      return false;
    }

    Map<String, dynamic> likedRestaurantsMap = jsonDecode(likedRestaurantsString);
    if (likedRestaurantsMap == null) {
      return false;
    }

    likedRestaurantsMap.forEach((String key, dynamic value) => this._load(key, value));
    this.isLoading = false;
    notifyListeners();
  }

  Future<bool> saveLikedRestaurant(LikedRestaurant likedRestaurant) async {
    this.isLoading = true;
    // guard clause
    if(this.likedRestaurants.containsKey(likedRestaurant.id)){
      return false;
    }
    else{
      this.likedRestaurants[likedRestaurant.id] = likedRestaurant;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("likedRestaurants");

    Map<String, dynamic> toSaveLikedRestaurants = {};
    this.likedRestaurants.forEach((String key, LikedRestaurant lr) => toSaveLikedRestaurants[key] = lr.toMap());

    prefs.setString("likedRestaurants", jsonEncode(toSaveLikedRestaurants));
    
    bool isSaved = prefs.containsKey("likedRestaurants");
    print(isSaved);
    this.isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> unLikeRestaurant(String id) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("likedRestaurants");
    this.likedRestaurants.clear();
    this.isLoading = false;
  }

  // region Helper Methods
  void _load(String key, dynamic value) {
    // guard clause
    if (key == null || key.isEmpty || key == "null") {
      return;
    }

    // guard clause
    if (this.likedRestaurants.containsKey(key)) {
      return;
    }

    LikedRestaurant likedRestaurant = new LikedRestaurant();
    likedRestaurant.copyFrom(value);

    this.likedRestaurants[key] = likedRestaurant;
  }
}
