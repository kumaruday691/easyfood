import './location.dart';

class Restaurant {

  // region Constructor
  Restaurant() {
    location = new Location();
    id = "";
    name = "";
    priceLevel = 0;
    placeReference = "";
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
  String placeReference;
  Location location;
  bool isOpen;
  String openTimings;
  String photosLink;
  String displayPhotoReference;
  dynamic rating;
  int usersVoted;

  // region Public Methods

  bool copyFrom(dynamic resultsMap) {
    try {
      _extractCore(resultsMap);
      _extractAvailability(resultsMap);
      _extractLocation(resultsMap);
      _extractPhotoReference(resultsMap);
      return true;
    } on Exception catch (e) {
      return false;
    }
  }

  String buildFormattedUserReview() {
    return "${this.rating.toString()} (${this.usersVoted})";
  }

  String getImageFromReference() {
    String photoRef = this.displayPhotoReference;
    if (photoRef == null || photoRef.isEmpty) {
      return "https://images.app.goo.gl/h124enRUBSsdbiCC8";
    }

    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photoRef}&key=AIzaSyC5Qhe19ZLVWIZ5xCfLRzeRpvTzYU_X2PM";
  }

  // region Helper Methods
  void _extractAvailability(resultsMap) {
    dynamic availabilityMap = resultsMap["opening_hours"];
    if (availabilityMap == null) {
      return;
    }

    this.isOpen = availabilityMap["open_now"];
  }

  void _extractCore(dynamic resultsMap) {
    this.name = resultsMap["name"];
    this.id = resultsMap["id"];
    this.priceLevel = resultsMap["price_level"];
    this.placeReference = resultsMap["place_id"];
    this.rating = resultsMap["rating"] as num;
    this.usersVoted = resultsMap["user_ratings_total"];
    this.location.address = resultsMap["vicinity"];
  }

  void _extractLocation(dynamic resultsMap) {
    dynamic geometry = resultsMap["geometry"];
    if (geometry == null) {
      return;
    }

    dynamic location = geometry["location"];
    if (location == null) {
      return;
    }

    this.location.latitude = location["lat"];
    this.location.longitude = location["lng"];
  }

  void _extractPhotoReference(dynamic resultMap) {
    dynamic photos = resultMap["photos"];
    if (photos == null) {
      return;
    }

    List<dynamic> photosList = new List<dynamic>.from(photos);
    if (photosList == null) {
      return;
    }

    if (photosList.length == 0) {
      return;
    }

    this.displayPhotoReference = photos[0]["photo_reference"];
    dynamic htmlReferences = photos[0]["html_attributions"];
    if (htmlReferences == null) {
      return;
    }

    List<dynamic> referenceList = List<dynamic>.from(htmlReferences);
    if (referenceList.length == 0) {
      return;
    }

    this.photosLink = _getPhotosLink(referenceList[0]);
  }

  String _getPhotosLink(String unformattedString) {
    // guard clause - invalid link
    if (unformattedString.isEmpty) {
      return "";
    }

    RegExp regex = new RegExp('https:[\'"]?([^\'" >]+)');
    if (!regex.hasMatch(unformattedString)) {
      return "";
    }

    return regex.stringMatch(unformattedString);
  }
}
