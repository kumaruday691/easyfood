import 'package:easyfood/requests/googleApiRequests.dart';
import 'package:location/location.dart' as geoLoc;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Location {

// region Constructor
Location({
  this.latitude,
  this.longitude,
  this.address
}
);

// region Properties
double latitude;
double longitude;
String address;

// region Public Methods
String buildFormattedLocation()
{
  return "${this.latitude},${this.longitude}";
}

Future<Location> getCurrentLocation() async
{
  final location = geoLoc.Location();
  final currentLocation = await location.getLocation();
  if(currentLocation == null)
  {
    return new Location();
  }

  this.latitude = currentLocation['latitude'];
  this.longitude = currentLocation['longitude'];
  this.address = await _getAddress(this.latitude, this.longitude);

  return this;
}

// region Helper Methods
Future<String> _getAddress(double lat , double lng) async
{
  final http.Response response = await GoogleApiRequests.getAddress(lat, lng); 
  final decodedResponse = json.decode(response.body);

  return decodedResponse['results'][0]['formatted_address'];
}

}