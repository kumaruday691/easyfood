import 'package:easyfood/domain/restaurantReview.dart';

class RestaurantDetail {
  // region Constructor
  RestaurantDetail() {
    googleSearchLink = "";
    webSiteLink = "";
    formattedAddress = "";
    formattedUserRating = "N/A";
    phoneNumber = "N/A";
    weeklyOpenHours =[];
    photoReferences = [];
    reviews = [];
  }

  // region Properties
  String googleSearchLink;
  String webSiteLink;
  String formattedUserRating;
  String formattedAddress;
  String phoneNumber;
  List<dynamic> weeklyOpenHours;
  List<String> photoReferences;
  List<RestaurantReview> reviews;

  // region Public Methods
  RestaurantDetail copyFrom(Map<String, dynamic> resultsMap) {
    _extractFormattedAddress(resultsMap);
    _extractedFormattedUserReviews(resultsMap);
    _extractPhoneNumber(resultsMap);
    _extractOpenHours(resultsMap);
    _extractPhotoReferences(resultsMap);
    _extractReviews(resultsMap);
    _extractLinks(resultsMap);

    return this;
  }

  // region Helper Methods
  void _createRestaurantReview(dynamic reviewMap)
  {
    RestaurantReview restaurantReview = new RestaurantReview();
    restaurantReview.reviewerName = reviewMap["author_name"] ?? "";
    restaurantReview.comment = reviewMap["text"];
    restaurantReview.profilePictureUrl = reviewMap["profile_photo_url"];
    restaurantReview.postedTime = reviewMap["relative_time_description"];
    restaurantReview.rating = reviewMap["rating"];

    this.reviews.add(restaurantReview);
  }

  void _extractedFormattedUserReviews(Map<String, dynamic> resultsMap){
   // guard clause
    if (!resultsMap.containsKey("rating") || !resultsMap.containsKey("user_ratings_total")) {
      return;
    } 

    this.formattedUserRating = "${resultsMap["rating"]}(${resultsMap["user_ratings_total"]})";
  }

  void _extractFormattedAddress(Map<String, dynamic> resultsMap) {
    // guard clause
    if (!resultsMap.containsKey("formatted_address")) {
      return;
    }

    this.formattedAddress = resultsMap["formatted_address"];
  }

  void _extractLinks(Map<String, dynamic> resultsMap){
    if (resultsMap.containsKey("website")) {
      this.webSiteLink = resultsMap["website"];
    }
 
    if (resultsMap.containsKey("url")) {
      this.googleSearchLink = resultsMap["url"];
    }
  }

  void _extractPhotoReferences(Map<String, dynamic> resultsMap)
  {
    // guard clause
    if (!resultsMap.containsKey("photos")) {
      return;
    }

    List<dynamic> photoReferenceMaps = resultsMap["photos"];
    photoReferenceMaps.forEach((photoReferenceMap) => {
      this.photoReferences.add(_getImageFromReference(photoReferenceMap["photo_reference"]))
    });
  }

  void _extractPhoneNumber(Map<String, dynamic> resultsMap) {
    // guard clause
    if (!resultsMap.containsKey("international_phone_number")) {
      return;
    }

    this.phoneNumber = resultsMap["international_phone_number"];
  }

  void _extractOpenHours(Map<String, dynamic> resultsMap) {
    // guard clause
    if (!resultsMap.containsKey("opening_hours")) {
      return;
    }
    
    Map<String, dynamic> openHoursMap = resultsMap["opening_hours"];
    if(!openHoursMap.containsKey("weekday_text"))
    {
      return;
    }

    this.weeklyOpenHours =  openHoursMap["weekday_text"];
  }

  void _extractReviews(Map<String, dynamic> resultsMap)
  {
    // guard clause
    if (!resultsMap.containsKey("reviews")) {
      return;
    }
    
    List<dynamic> reviewMaps = resultsMap["reviews"];
    reviewMaps.forEach((reviewMap) => _createRestaurantReview(reviewMap));
  }

  String _getImageFromReference(String photoReference) {
    if (photoReference == null || photoReference.isEmpty) {
      return "https://images.app.goo.gl/h124enRUBSsdbiCC8";
    }

    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photoReference}&key=AIzaSyC5Qhe19ZLVWIZ5xCfLRzeRpvTzYU_X2PM";
  }

}
