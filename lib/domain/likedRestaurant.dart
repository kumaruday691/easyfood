class LikedRestaurant {

  // region Constructor
  LikedRestaurant() {
    name = "";
    photoReference = "";
    id = "";
    address = "";
  }

  // region Properties
  String name;
  String photoReference;
  String id;
  String address;
  double latitude;
  double longitude;
  bool isOpen;

  // region Public Methods
   void copyFrom(Map<String, dynamic> likedMap) {
    this.id = likedMap["id"];
    this.photoReference = likedMap["photoRef"];
    this.name = likedMap["name"];
    this.address = likedMap["address"];
    this.latitude = likedMap["latitude"];
    this.longitude = likedMap["longitude"];
    this.isOpen = likedMap["isOpen"];
  }

  String getImageFromReference() {
    String photoRef = this.photoReference;
    if (photoRef == null || photoRef.isEmpty) {
      return "https://images.app.goo.gl/h124enRUBSsdbiCC8";
    }

    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photoRef}&key=AIzaSyC5Qhe19ZLVWIZ5xCfLRzeRpvTzYU_X2PM";
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> likedRestaurantMap = new Map<String, dynamic>();
    likedRestaurantMap["id"] = this.id;
    likedRestaurantMap["photoRef"] = this.photoReference;
    likedRestaurantMap["name"] = this.name;
    likedRestaurantMap["address"] = this.address;
    likedRestaurantMap["latitude"] = this.latitude;
    likedRestaurantMap["longitude"] = this.longitude;
    likedRestaurantMap["isOpen"] = this.isOpen;
    return likedRestaurantMap;
  }

}