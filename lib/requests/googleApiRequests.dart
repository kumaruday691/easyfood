import 'package:easyfood/domain/filterCriteria.dart';
import 'package:easyfood/domain/location.dart';
import 'package:http/http.dart' as http;

class GoogleApiRequests {

  // region Public Methods
  static Future<http.Response> fetchRestaurants(Location location, FilterCriteria filterCriteria) async {
    // guard clause - invalid criteria
    if (filterCriteria == null) {
      return null;
    }

    final Uri uri =
        Uri.https('maps.googleapis.com', '/maps/api/place/nearbysearch/json', {
      'location': location.buildFormattedLocation(),
      'radius': filterCriteria.radiusCovered.toString(),
      'key': 'AIzaSyC5Qhe19ZLVWIZ5xCfLRzeRpvTzYU_X2PM',
      'type': 'restaurant',
      'keyword': filterCriteria.getFormattedkeyWords(false),
      'maxprice': filterCriteria.maxPriceLevel.toString(),
      //'opennow':filterCriteria.openNow.toString()
    });

    return await http.get(uri);
  }

  static Future<http.Response> fetchNextPageRestaurants(String nextPageToken) async{
    // guard clause - invalid token
    if(nextPageToken.isEmpty || nextPageToken == null){
      return null;
    }

    final Uri uri =  Uri.https('maps.googleapis.com', '/maps/api/place/nearbysearch/json', {
      'key': 'AIzaSyC5Qhe19ZLVWIZ5xCfLRzeRpvTzYU_X2PM',
      'pagetoken' : nextPageToken
    }); 

    return await http.get(uri);
  }

  static Future<http.Response> fetchRestaurantDetail(String placeId) async {
    // guard clause
    if(placeId.isEmpty) {
      return null;
    }

    final Uri uri =
        Uri.https('maps.googleapis.com', '/maps/api/place/details/json', {
      'placeid': placeId,
      'key': 'AIzaSyC5Qhe19ZLVWIZ5xCfLRzeRpvTzYU_X2PM',
    });

    return await http.get(uri);
  }

  static Future<http.Response> getAddress(double lat, double lng) async {
    final url = Uri.https('maps.googleapis.com', '/maps/api/geocode/json', {
      'latlng': '${lat.toString()},${lng.toString()}',
      'key': 'AIzaSyAatGRplYt8Uuxp3Syyn7poAi293o6wmrY',
    });

    return await http.get(url);
  }
}
