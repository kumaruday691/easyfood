
import 'package:easyfood/domain/applicationEnvironment.dart';
import 'package:easyfood/domain/unitOfWork.dart';
import 'package:easyfood/widgets/restaurantsViewBuilder.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AvailableRestaurantsPage extends StatefulWidget {

  // region Properties
  final ApplicationEnvironment applicationEnvironment;

  // region Constructor
  AvailableRestaurantsPage(this.applicationEnvironment);

  @override
  State<StatefulWidget> createState() {
    return _AvailableRestaurantsPageState();
  }

}

class _AvailableRestaurantsPageState extends State<AvailableRestaurantsPage>
 {
   @override
  Widget build(BuildContext context) {
    return _buildRestaurantsList();
  }

  Widget _buildRestaurantsList() {
    return ScopedModelDescendant<UnitOfWork>(builder: (context, child, model) {
    Widget content = Center(child: Column(
        children: <Widget>[
          CircularProgressIndicator(), 
          Text("Restaurants information pending..."),
        ]
        ),);
    if(widget.applicationEnvironment.location == null)
    {
      content = Center(child: Column(
        children: <Widget>[
          CircularProgressIndicator(), 
          Text("Location information pending..."),
        ]
        ),);
    }

    if(model.restaurants.length > 0 && !model.isLoading) {
        content = RestaurantsViewBuilder(widget.applicationEnvironment); 
    }
    else if(model.isLoading) {
      content = Center(child:CircularProgressIndicator());
    }
    
    return RefreshIndicator(onRefresh: widget.applicationEnvironment.refreshRestaurantsList, // needs future, so your function needs to be future
      child:content
      );
    });
  }

 }