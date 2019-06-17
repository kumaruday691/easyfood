import './location.dart';

class Restaturant {

  // region Constructor
  Restaturant()
  {
    location = new Location();
    id = "";
    name = "";
    priceLevel = 0;
    isOpen = true;
    openTimings = "";
    photosLink = "";
    rating = 0.0;
    usersVoted = 0;
  }

  // region Properties
  String id;
  String name;
  int priceLevel;
  Location location;
  bool isOpen;
  String openTimings;
  String photosLink;
  double rating;
  int usersVoted;

  // region Public Methods
  bool copyFrom(dynamic resultsMap)
  {
    _extractLocation(resultsMap);
  }

  // region Helper Methods
  void _extractLocation(dynamic resultsMap)
  {
    dynamic geometry = resultsMap["geometry"];
    if(geometry == null)
    {
      return;
    }

    dynamic location = geometry["location"];
    if(location == null)
    {
      return;
    }

    this.location.latitude = location["lat"];
    this.location.longitude = location["lng"];
  }


}