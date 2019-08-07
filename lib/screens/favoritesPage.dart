import 'package:easyfood/domain/applicationEnvironment.dart';
import 'package:easyfood/domain/likedRestaurant.dart';
import 'package:easyfood/domain/location.dart';
import 'package:easyfood/domain/mapNavigator.dart';
import 'package:easyfood/domain/repositoryModel.dart';
import 'package:easyfood/domain/restaurant.dart';
import 'package:easyfood/screens/randomCardPage.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class FavoritesPage extends StatefulWidget {
  // region Properties
  final ApplicationEnvironment applicationEnvironment;

  // region Constructor
  FavoritesPage(this.applicationEnvironment);

  @override
  State<StatefulWidget> createState() {
    return _FavoritesPageState();
  }
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    widget.applicationEnvironment.tabIndex = 1;
    return ScopedModelDescendant<RepositoryModel>(
        builder: (context, child, model) {
      if (model.likedRestaurants.length == 0) {
        return Center(
          child: Text("No favorites yet. Start spreading love."),
        );
      }

      return ListView.builder(
        itemBuilder: (context, index) {
          LikedRestaurant currentLikedRestaurant =
              model.likedRestaurants.values.toList()[index];
          return Dismissible(
            movementDuration: Duration(seconds: 2),
            key: Key(model.likedRestaurants.keys.toList()[index]),
            background: Container(
              child: Align(
                  widthFactor: 2,
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.delete_sweep,
                  )),
              color: Colors.red,
            ),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                widget.applicationEnvironment.unitOfWork.unLikeRestaurant(currentLikedRestaurant.id);
                widget.applicationEnvironment.refreshRestaurantsList();
              }
            },
            child: Column(
              children: <Widget>[
                ListTile(
                    leading: GestureDetector(
                      onTap: () => _buildRandomCard(currentLikedRestaurant),
                      child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              currentLikedRestaurant.getImageFromReference()??"https://images.app.goo.gl/wwH1aFEz6iouatQz8")),
                    ),
                    title: Text(currentLikedRestaurant.name),
                    subtitle: Text(currentLikedRestaurant.address),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.navigation,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                       _showMapNavigation(currentLikedRestaurant); 
                      },
                    )),
                Divider(),
              ],
            ),
          );
        },
        itemCount: model.likedRestaurants.length,
      );
    });
  }

  _buildRandomCard(LikedRestaurant likedRestaurant) {
      Restaurant backedUpRestaurant = new Restaurant();
      backedUpRestaurant.copyFromBackUp(likedRestaurant);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RandomCardPage(backedUpRestaurant, widget.applicationEnvironment)));
    }

  _showMapNavigation(LikedRestaurant likedRestaurant)
  {
    Location restaurantLocation = new Location(latitude: likedRestaurant.latitude, longitude: likedRestaurant.longitude, address: likedRestaurant.address);
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
  
  }

