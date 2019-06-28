import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyfood/domain/applicationEnvironment.dart';
import 'package:easyfood/domain/launcher.dart';
import 'package:easyfood/domain/location.dart';
import 'package:easyfood/domain/mapNavigator.dart';
import 'package:easyfood/domain/restaurant.dart';
import 'package:easyfood/widgets/reviewStars.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatefulWidget {

  // region Properties
  final Restaurant currentRestaurant;
  final int currentRestaurantIndex;
  final ApplicationEnvironment applicationEnvironment;

  // region Constructor
  RestaurantCard(this.currentRestaurant, this.currentRestaurantIndex, this.applicationEnvironment);

  @override
  State<StatefulWidget> createState() {
    return RestaurantCardState();
  }
}

class RestaurantCardState extends State<RestaurantCard>
    with TickerProviderStateMixin {
// Animations
  Animation colorAnimation;
  AnimationController colorAnimationController;

  initState() {
    colorAnimationController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    colorAnimation =
        Tween(begin: 1.0, end: .5).animate(colorAnimationController);
    super.initState();
  }

  dispose() {
    colorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String url = widget.currentRestaurant.getImageFromReference();
    Restaurant currentRestaurant = widget.currentRestaurant;
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 5.0, top: 5.0),
      margin: EdgeInsets.only(bottom: 10.0),
      height: 240,
      child: Row(
        children: <Widget>[
           Expanded(
              child: GestureDetector(child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black87.withOpacity(colorAnimation.value),
                          BlendMode.difference),
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(url),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(5.0, 5.0),
                          blurRadius: 10.0)
                    ]),
              ),
              onTap: () => 
                Launcher(currentRestaurant.photosLink).open(),
            ),
            
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    currentRestaurant.name,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        color: Color(0xFFFFD700),
                      ),
                      Text(widget.currentRestaurant.buildFormattedUserReview(),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18.0,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildPriceLevel(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Wrap(
                    //mainAxisSize: MainAxisSize.min,
                    //alignment: WrapAlignment.start,
                    children: <Widget>[
                      // Icon(
                      //   Icons.location_on,
                      //   color: Colors.redAccent,
                      // ),
                      GestureDetector(
                          child: Text(
                            currentRestaurant.location.address,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                                //height: 1.5,
                                decoration: TextDecoration.underline),
                          ),
                          onTap: () => Launcher(_getMapLauncherUrl()).open()),
                    ],
                  ),
                  
                  _headerItemBuild()
                ],
              ),
              //margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(5.0, 5.0),
                        blurRadius: 10.0)
                  ]),
            ),
          )
        ],
      ),
    );
  }

  String _getMapLauncherUrl() {
    Restaurant restaturant = widget.currentRestaurant;
    if (restaturant == null) {
      return "";
    }

    Location location = restaturant.location;
    if (location == null) {
      return "https://images.app.goo.gl/yvKsXenfLVhVLWWx8";
    }

    return 'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
  }

  Widget _buildPriceLevel() {
    int priceLevel = widget.currentRestaurant.priceLevel;
    if (priceLevel == null) {
      return Container();
    }

    String priceLevelString = new List.filled(priceLevel, "\$").join();
    return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.credit_card,
                        color: Color(0xFFFFD700),
                      ),
                      SizedBox(width: 5,),
                      Text(priceLevelString,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 18.0,
                          )),
                    ],
                  );
  }

  _showMapNavigation()
  {
    Location restaurantLocation = widget.currentRestaurant.location;
    if(restaurantLocation == null)
    {
      return;
    }

    Location currentLocation = widget.applicationEnvironment.location;
    if(currentLocation == null)
    {
      return;
    }

    MapNavigator.navigate(currentLocation, restaurantLocation);    
  }

  _headerItemBuild() {
    return Align(
      alignment: Alignment.center,
      child:  ButtonTheme.bar(
          
          //alignedDropdown: true,
          child: new ButtonBar(
            
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.directions_car,
                  color: Theme.of(context).accentColor,
                  size: 20,
                ),
                onPressed: () => {
                  _showMapNavigation()
                },
                splashColor: Colors.blue,
              ),
              
              IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                  size: 20,
                ),
                onPressed: () => {},
              ),

              IconButton(
                icon: Icon(
                  Icons.share,
                  color: Theme.of(context).accentColor,
                  size: 20,
                ),
                onPressed: () {
                  Share.share(widget.currentRestaurant.photosLink);
                },
                splashColor: Color(0xffdd2476),
              ),
               
            ],)
         
        
    ),);
  }
}
