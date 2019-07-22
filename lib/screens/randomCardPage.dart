import 'package:easyfood/domain/applicationEnvironment.dart';
import 'package:easyfood/domain/restaurant.dart';
import 'package:easyfood/domain/repositoryModel.dart';
import 'package:easyfood/widgets/restaurantRandomCard.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class RandomCardPage extends StatelessWidget {
  // region Properties
  final Restaurant restaurant;
  final ApplicationEnvironment applicationEnvironment;

  const RandomCardPage(this.restaurant, this.applicationEnvironment);

  @override
  Widget build(BuildContext context) {
    final _recordingSection = SafeArea(
      child: ScopedModelDescendant<RepositoryModel>(
        builder: (_, __, model) {
          if (this.restaurant == null) {
            return this.applicationEnvironment.showAlertDialog(
                context,
                "Invalid State",
                "Something went wrong. We will investigate about that something.");
          }

          return PageView(children: <Widget>[
            RestaurantRandomCard(restaurant, this.applicationEnvironment)
          ]);
        },
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white70,

      //appBar: _appBar,
      body: _recordingSection,
    );
  }
}
