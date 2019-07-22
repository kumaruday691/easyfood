import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyfood/domain/applicationEnvironment.dart';
import 'package:easyfood/domain/launcher.dart';
import 'package:easyfood/domain/location.dart';
import 'package:easyfood/domain/mapNavigator.dart';
import 'package:easyfood/domain/restaurant.dart';
import 'package:easyfood/domain/restaurantDetail.dart';
import 'package:easyfood/domain/restaurantReview.dart';
import 'package:easyfood/domain/repositoryModel.dart';
import 'package:easyfood/widgets/reviewStars.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';

class RestaurantRandomCard extends StatefulWidget {
  Restaurant restaurant;
  final ApplicationEnvironment applicationEnvironment;

  RestaurantRandomCard(this.restaurant, this.applicationEnvironment);

  @override
  State<StatefulWidget> createState() {
    return RestaurantRandomCardState();
  }
}

class RestaurantRandomCardState extends State<RestaurantRandomCard> {
  RestaurantDetail restaurantDetail = new RestaurantDetail();
  int currentpage = 0;
  int currentReviewPage = 0;

  @override
  void initState() {
    Future<RestaurantDetail> futureDetail = widget
        .applicationEnvironment.unitOfWork
        .getRestaurantDetail(widget.restaurant.placeReference);
    if (futureDetail == null) {
      widget.applicationEnvironment.showAlertDialog(
          context, "Fetch Error", "Failed to fetch restaurant information");
      return;
    }

    futureDetail.then((RestaurantDetail detail) {
      setState(() {
        restaurantDetail = detail;
      });
    });

    super.initState();
  }

  _buildReviewsModal(){
    List<RestaurantReview> reviews = restaurantDetail.reviews;
      if (widget.applicationEnvironment.unitOfWork.isLoading) {
        return Center(child:CircularProgressIndicator());
      }

      if (reviews.length == 0) {
        return Container(
          child: Text("Reviews not found."),
        );
      }

      return CarouselSlider(
        height: 600.0,
        initialPage: 0,
        enlargeCenterPage: true,
        autoPlay: false,
        reverse: false,
        enableInfiniteScroll: true,
        viewportFraction: 0.85,
        autoPlayInterval: Duration(seconds: 2),
        autoPlayAnimationDuration: Duration(milliseconds: 2000),
        pauseAutoPlayOnTouch: Duration(seconds: 10),
        scrollDirection: Axis.horizontal,
        onPageChanged: (index) {
          setState(() {
            currentReviewPage = index;
          });
        },
        items: reviews.map((currentReview) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.rectangle,
                  ),
                  child: Center(
      child: Card(
        elevation: 0,
        borderOnForeground: true,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Center(
            child: CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.black12,
              backgroundImage:
                  NetworkImage(currentReview.profilePictureUrl),
            ),
          ),
          ListTile(
      title: Text(
        currentReview.reviewerName,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      subtitle: ButtonTheme.bar(child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          ReviewStars(currentReview.rating.toDouble(), null, null),
          Text("(${currentReview.postedTime})")
        ],
      ),
    ),),
    Expanded(child:Text(currentReview.comment, softWrap: true,textAlign: TextAlign.justify,)),

          ],
        ),
      ),
    ),);},);
        }).toList(),
      );
    }  

  _showTimingsModal() {
    showModalBottomSheet(
      //isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                _buildTimingsModal(
                    index), //ReviewCard(restaurantDetail.reviews[index]),
            itemCount: restaurantDetail.reviews.length);
      },
    );
  }

  _showReviewsModal(){
   showModalBottomSheet(
     isScrollControlled: true,
     elevation: 0,
      context: context,
      builder: (BuildContext bc) {
        return _buildReviewsModal();
      },
    ); 
  }

  _buildTimingsModal(int index) {
    // guard clause
    if (restaurantDetail.weeklyOpenHours.length == 0) {
      return Center(
        child: Text("Restaurant timings not available"),
      );
    }

    String currentDayHours = restaurantDetail.weeklyOpenHours[index];
    List<String> splitOpenHours = currentDayHours.split(": ");

    return Center(
      child: Card(
        elevation: 0,
        borderOnForeground: true,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(
                splitOpenHours[0] + '\n',
                style: TextStyle(color: Colors.blueAccent),
              ),
              subtitle: Text(
                splitOpenHours[1].split(",").join('\n'),
                style: TextStyle(color: Colors.indigoAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showMapNavigation() {
    Location restaurantLocation = widget.restaurant.location;
    if (restaurantLocation == null) {
      return;
    }

    Location currentLocation = widget.applicationEnvironment.location;
    if (currentLocation == null) {
      return;
    }

    MapNavigator.navigate(currentLocation, restaurantLocation);
  }

    _buildWebsiteLinkIfApplicable(RestaurantDetail restaurantDetail){
      if(restaurantDetail.webSiteLink.isEmpty) {
        return Container();
      }

      return 
          ActionChip(avatar:Icon(FontAwesomeIcons.clipboardList, color: Colors.orange, size: 20,),label: Text("Website", style: TextStyle(decoration: TextDecoration.underline, color: Colors.redAccent), ), onPressed: () => {
            Launcher(restaurantDetail.webSiteLink).open()
          },);
    }

  @override
  Widget build(BuildContext context) {
    // previously selected restaurant
    if (widget.applicationEnvironment.previouslyRandomizedRestaurant != null) {
      widget.restaurant =
          widget.applicationEnvironment.previouslyRandomizedRestaurant;
    }

    final _imageSection = widget.restaurant.getImageFromReference() != null
        ? Center(
            child: CircleAvatar(
              radius: 60.0,
              backgroundColor: Colors.black12,
              backgroundImage:
                  NetworkImage(widget.restaurant.getImageFromReference()),
            ),
          )
        : Center(
            child: CircleAvatar(
              radius: 60.0,
              backgroundColor: Colors.black12,
              backgroundImage: AssetImage('assets/def-res.png'),
            ),
          );

    _buildShareButton() => Positioned(
          top: 0.0,
          right: 0.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ScopedModelDescendant<RepositoryModel>(
              builder: (_, __, model) {
                return IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Color(0xffdd2476),
                  ),
                  onPressed: () {
                    //model.stop();
                  Share.share(widget.restaurant.photosLink);
                  },
                );
              },
            ),
          ),
        );

    final _closeButton = Positioned(
      top: 0.0,
      left: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ScopedModelDescendant<RepositoryModel>(
          builder: (_, __, model) {
            return IconButton(
              icon: Icon(
                Icons.close,
                color: Color(0xffdd2476),
              ),
              onPressed: () {
                //model.stop();
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );

    // final _infoSection = Row(
    //   mainAxisSize: MainAxisSize.min,
    //   children: <Widget>[
    // IconButton(
    //   icon: Icon(
    //     Icons.favorite_border,
    //     color: Theme.of(context).accentColor,
    //   ),
    //   onPressed: () => {},
    // ),
    final _infoSection = ListTile(
      title: Text(
        widget.restaurant.name,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      subtitle: ButtonTheme.bar(child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          ActionChip(
            avatar: widget.restaurant.isOpen ? Icon(Icons.lock_open, color: Colors.green, size: 15,) : Icon(Icons.lock_outline, color: Colors.red,size: 15,),
            label: Text(
              widget.restaurant.isOpen ? "Open" : "Closed",
              textAlign: TextAlign.left,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: widget.restaurant.isOpen
                      ? Colors.teal
                      : Colors.redAccent),
            ),
            onPressed: () => _showTimingsModal(),
          ),
          ActionChip(
            // avatar: CircleAvatar(
            //   //backgroundColor:  Colors.teal,
            //   backgroundImage: AssetImage("assets/def-res.png"),

            // ),
            avatar: Icon(Icons.stars, color: Colors.orange),
            label: Text(
              restaurantDetail.formattedUserRating,
              textAlign: TextAlign.center,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: widget.restaurant.isOpen
                      ? Colors.teal
                      : Colors.redAccent),
            ),
            //onPressed: () => ReviewCard(restaurantDetail.reviews, widget.applicationEnvironment),
            onPressed: () => _showReviewsModal(),
            
          ),
          _buildWebsiteLinkIfApplicable(restaurantDetail)
        ],
      ),
    ),);
    // ],
    //);

    _buildReviewCaraouselSection() {
      List<RestaurantReview> photoReferences = restaurantDetail.reviews;
      if (widget.applicationEnvironment.unitOfWork.isLoading) {
        return CircularProgressIndicator();
      }

      if (photoReferences.length == 0) {
        return Container(
          child: Text("Images not found."),
        );
      }

      return CarouselSlider(
        height: 200.0,
        initialPage: 0,
        enlargeCenterPage: true,
        autoPlay: false,
        reverse: false,
        enableInfiniteScroll: true,
        autoPlayInterval: Duration(seconds: 2),
        autoPlayAnimationDuration: Duration(milliseconds: 2000),
        pauseAutoPlayOnTouch: Duration(seconds: 10),
        scrollDirection: Axis.horizontal,
        onPageChanged: (index) {
          setState(() {
            currentpage = index;
          });
        },
        items: photoReferences.map((imgUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.rectangle,
                  ),
                  child: Text(imgUrl.comment));
            },
          );
        }).toList(),
      );
    }

    _buildImagesCaraouselSection() {
      List<String> photoReferences = restaurantDetail.photoReferences;
      if (widget.applicationEnvironment.unitOfWork.isLoading) {
        return Center(child: CircularProgressIndicator());
      }

      if (photoReferences.length == 0) {
        return Container(
          child: Text("Images not found."),
        );
      }

      return CarouselSlider(
        height: 300.0,
        initialPage: 0,
        enlargeCenterPage: true,
        autoPlay: true,
        reverse: false,
        enableInfiniteScroll: true,
        autoPlayInterval: Duration(seconds: 2),
        autoPlayAnimationDuration: Duration(milliseconds: 2000),
        pauseAutoPlayOnTouch: Duration(seconds: 10),
        scrollDirection: Axis.horizontal,
        onPageChanged: (index) {
          setState(() {
            currentpage = index;
          });
        },
        items: photoReferences.map((imgUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.circular(25.0),
                    image: new DecorationImage(
                      image: CachedNetworkImageProvider(imgUrl),
                      fit: BoxFit.fill,
                    )),
              );
            },
          );
        }).toList(),
      );
    }

    _buildReviewSection() {
      // setState(() {

      // });
      return ScopedModelDescendant<RepositoryModel>(
        builder: (context, widget, model) {
          return ListView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  Text("Review"), //ReviewCard(restaurantDetail.reviews[index]),
              itemCount: restaurantDetail.reviews.length);
        },
      );
    }

    final _reviewSection = ExpansionTile(
      leading: Icon(Icons.description),
      title: Text("Reviews"),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  Text("Review"), //ReviewCard(restaurantDetail.reviews[index]),
              itemCount: restaurantDetail.reviews.length),
        ),
      ],
    );
    //final _reviewSection = _buildReviewSection();

    final _navigationSection = GestureDetector(
      onTap: () => {
            _showMapNavigation(),
            widget.applicationEnvironment.previouslyRandomizedRestaurant =
                widget.restaurant,
          },
      child: Padding(
        padding: EdgeInsets.only(left: 10.0, right: 5.0, top: 5.0, bottom: 5.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            Icon(
              Icons.directions_car,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.restaurant.location.address,
              style: TextStyle(
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline),
            )
          ],
        ),
      ),
    );

    final _telephoneSection = GestureDetector(
      onTap: () => {
            Launcher(
                    "tel:${restaurantDetail.phoneNumber.replaceAll('-', '').replaceAll(' ', '').trim()}")
                .open(),
            //Launcher("tel://+919490471846").open(),
            widget.applicationEnvironment.previouslyRandomizedRestaurant =
                widget.restaurant,
          },
      child: Padding(
        padding:
            EdgeInsets.only(left: 10.0, right: 5.0, top: 5.0, bottom: 15.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            Icon(
              Icons.phone,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              restaurantDetail.phoneNumber,
              style: TextStyle(
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline),
            )
          ],
        ),
      ),
    );

    _buildCardSection() => Card(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            GestureDetector(
              child: _imageSection,
              onTap: () => {
                    widget.applicationEnvironment
                        .previouslyRandomizedRestaurant = widget.restaurant,
                    Launcher(restaurantDetail.googleSearchLink).open()
                  },
            ),
            _infoSection,
            _navigationSection,
            _telephoneSection,
            _buildImagesCaraouselSection(),
            //_buildReviewCaraouselSection(),
          ],
        ));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 28.0),
      child: ScopedModelDescendant<RepositoryModel>(
        builder: (_, __, model) {
          return Stack(
            children: <Widget>[
              _buildCardSection(),
              _buildShareButton(),
              _closeButton
            ],
          );
        },
      ),
    );
  }
}
