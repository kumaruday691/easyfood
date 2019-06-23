import 'package:easyfood/domain/applicationEnvironment.dart';
import 'package:easyfood/domain/launcher.dart';
import 'package:easyfood/domain/restaurant.dart';
import 'package:easyfood/domain/unitOfWork.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class RestaurantRandomCard extends StatelessWidget {

  Restaurant restaurant;
  final ApplicationEnvironment applicationEnvironment;

  RestaurantRandomCard(this.restaurant, this.applicationEnvironment);

  String _getImageFromReference()
  {
    String photoRef = restaurant.displayPhotoReference;
    if(photoRef.isEmpty)
    {
      return "";
    }

    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photoRef}&key=AIzaSyC5Qhe19ZLVWIZ5xCfLRzeRpvTzYU_X2PM";
  }

  @override
  Widget build(BuildContext context) {

    // previously selected restaurant
    if(applicationEnvironment.previouslyRandomizedRestaurant != null)
    {
      restaurant = applicationEnvironment.previouslyRandomizedRestaurant;
    }

    final _imageSection = _getImageFromReference() != null
            ? Center(
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Colors.black12,
                  backgroundImage: NetworkImage(_getImageFromReference()),
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
            child: ScopedModelDescendant<UnitOfWork>(
          builder: (_, __, model) {
            return IconButton(
              icon: Icon(
                Icons.share,
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

    final _closeButton = Positioned(
      top: 0.0,
      left: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ScopedModelDescendant<UnitOfWork>(
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

    final _infoSection = ListTile(
      title: Text(
        restaurant.name,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      subtitle: 
          ActionChip(
              avatar: CircleAvatar(
                backgroundColor: Colors.tealAccent,
                backgroundImage: NetworkImage(_getImageFromReference()),
              ),
              label: Text(
                restaurant.name,
                textAlign: TextAlign.center,
              ),
              onPressed: () => Launcher(restaurant.photosLink).open(),
            )
          
    );

    
    final _descriptionSection = ExpansionTile(
      leading: Icon(Icons.description),
      title: Text(restaurant.location.address),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            restaurant.location.address,
            textAlign: TextAlign.start,
          ),
        )
      ],
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
              onTap:() => {
                this.applicationEnvironment.previouslyRandomizedRestaurant = restaurant,
                Launcher(this.restaurant.photosLink).open()
                },
              ),
            _infoSection,
            _descriptionSection,
            
          ],
        ));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 28.0),
      child: ScopedModelDescendant<UnitOfWork>(
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