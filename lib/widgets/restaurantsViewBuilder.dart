import 'package:easyfood/domain/applicationEnvironment.dart';
import 'package:easyfood/domain/restaurant.dart';
import 'package:easyfood/domain/repositoryModel.dart';
import 'package:easyfood/widgets/restaurantCard.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class RestaurantsViewBuilder extends StatelessWidget {

  // region Properties
  final ApplicationEnvironment applicationEnvironment;

  // region Constructor
  RestaurantsViewBuilder(this.applicationEnvironment);

  // Helper Methods
  Widget _renderItemIfApplicable(List<Restaurant> restaurants) 
  {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) => RestaurantCard(restaurants[index], index, this.applicationEnvironment),
        itemCount: restaurants.length,
      );
  }

  // override build Method
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RepositoryModel>(builder: (context, widget, model) {
      return _renderItemIfApplicable(model.restaurants); 
    },); 
  }
  
}
