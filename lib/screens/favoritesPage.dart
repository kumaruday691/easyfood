import 'package:easyfood/domain/applicationEnvironment.dart';
import 'package:easyfood/widgets/restaurantsViewBuilder.dart';
import 'package:flutter/material.dart';

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

class _FavoritesPageState extends State<FavoritesPage>
 {
   @override
  Widget build(BuildContext context) {
    return Center(child: Text("No favorites yet."),); 
  }
 }