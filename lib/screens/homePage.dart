import 'package:easyfood/domain/applicationEnvironment.dart';
import 'package:easyfood/domain/location.dart';
import 'package:easyfood/domain/unitOfWork.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {

  // region Properties
  final ApplicationEnvironment applicationEnvironment;

  // region Constructor
  HomePage(this.applicationEnvironment);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage>
 {

  @override
  void initState() {
    // guard clause - no location found
    final ApplicationEnvironment _applicationEnvironment = widget.applicationEnvironment;
    _applicationEnvironment.setCurrentLocation().then((Location location) {
      if (location == null)
      {
        _applicationEnvironment.showAlertDialog(context, "Location Error",
            "Could not fetch current location. Please check your location settings.");
        return;
      }

      widget.applicationEnvironment.location = location;
      refreshList();
    });
 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ApplicationEnvironment _appEnv = widget.applicationEnvironment;

    return Scaffold(
      drawer: _appEnv.buildApplicationDrawer(context),
      appBar: AppBar(
        title: Text('Restaurants'),
        actions: <Widget>[
         ScopedModelDescendant<UnitOfWork>(builder: (context, child, model){
            return IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              model.fetchRestaurants(_appEnv.location, _appEnv.filterCriteria);
            },
          );
         },) 
        ],
      ),
      body: _buildRestaurantsList(),
    );
  }

  Future<bool> refreshList()
  {
    ApplicationEnvironment _appEnv = widget.applicationEnvironment;
    return _appEnv.unitOfWork.fetchRestaurants(_appEnv.location, _appEnv.filterCriteria);
  }

  Widget _buildRestaurantsList() {
    return ScopedModelDescendant<UnitOfWork>(builder: (context, child, model) {
    Widget content = Center(child:Text("No restaurants found!"));
    if(widget.applicationEnvironment.location == null)
    {
      content = Center(child: Text("Location information not available"),);
    }

    if(model.restaurants.length > 0 && !model.isLoading) {
        content = Center(child:Text("Restaurants"));
    }
    else if(model.isLoading) {
      content = Center(child:CircularProgressIndicator());
    }
    
    return RefreshIndicator(onRefresh: refreshList, // needs future, so your function needs to be future
      child:content
      );
    });
  }

}
