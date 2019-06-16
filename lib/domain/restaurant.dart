import './location.dart';

class Restaturant {

  // region Constructor
  Restaturant({
    this.id,
    this.name,
  }
  );

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


}