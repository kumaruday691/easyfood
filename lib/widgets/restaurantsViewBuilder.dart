import 'package:easyfood/domain/applicationEnvironment.dart';
import 'package:easyfood/domain/restaurant.dart';
import 'package:easyfood/domain/repositoryModel.dart';
import 'package:easyfood/widgets/restaurantCard.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class RestaurantsViewBuilder extends StatefulWidget {

  // region Properties
  final ApplicationEnvironment applicationEnvironment;

  // region Constructor
  RestaurantsViewBuilder(this.applicationEnvironment);

  @override
  State<StatefulWidget> createState() {
    return new RestaurantViewBuilderState();
  }
}

class RestaurantViewBuilderState extends State<RestaurantsViewBuilder> {

  ScrollController controller;
  TextEditingController editingController;
   List<Restaurant> modelRestaurants; 
   List<Restaurant> copyRestaurants = new List<Restaurant>();

  @override
  void initState(){
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    editingController = new TextEditingController();
    modelRestaurants = widget.applicationEnvironment.unitOfWork.restaurants;

    copyRestaurants.addAll(modelRestaurants);
  }  

  // Helper Methods
  void _scrollListener() {
    if (controller.position.extentAfter < 100) {
      //widget.applicationEnvironment.unitOfWork.fetchNextPageRestaurants(widget.applicationEnvironment.filterCriteria);
    }
    setState(() {
        
      });
    
  }

  void filterSearchResults(String query) {
  List<Restaurant> dummySearchList = List<Restaurant>();
  dummySearchList.addAll(modelRestaurants);
  if(query.isNotEmpty) {
    List<Restaurant> dummyListData = List<Restaurant>();
    dummySearchList.forEach((item) {
      if(item.name.toLowerCase().contains(query.toLowerCase())) {
        dummyListData.add(item);
      }
    });
    setState(() {
      copyRestaurants.clear();
      copyRestaurants.addAll(dummyListData);
    });
    return;
  } else {
    setState(() {
      copyRestaurants.clear();
      copyRestaurants.addAll(modelRestaurants);
    });
  }
}

  Widget _buildPage(List<Restaurant> restaurants){
    return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                 filterSearchResults(value); 
                 
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              ),
            ),
            Expanded(
              child: _renderItemIfApplicable(restaurants)
            ),
          ],
        ),
      );
  }

  Widget _renderItemIfApplicable(List<Restaurant> restaurants) 
  {
      return ListView.builder(
        //shrinkWrap: true,
        controller: controller,
        itemBuilder: (BuildContext context, int index) => RestaurantCard(restaurants[index], index, widget.applicationEnvironment),
        itemCount: restaurants.length,
      );
  }

  // override build Method
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RepositoryModel>(builder: (context, widget, model) {
      return _buildPage(copyRestaurants); 
    },); 
  }
  
}
