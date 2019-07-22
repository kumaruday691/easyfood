import 'dart:convert';
import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:easyfood/domain/applicationEnvironment.dart';
import 'package:easyfood/domain/filterCriteria.dart';
import 'package:easyfood/domain/repositoryModel.dart';
import 'package:easyfood/widgets/reviewStars.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterPage extends StatefulWidget {
  final List<String> keywords = [
    "chinese",
    "thai",
    "italian",
    "indian",
    "japanese",
    "continental",
    "mexican",
    "american(really?)"
  ];

  final ApplicationEnvironment applicationEnvironment;

  FilterPage(this.applicationEnvironment);

  @override
  State<StatefulWidget> createState() {
    return FilterPageState();
  }
}

class FilterPageState extends State<FilterPage> {
  PublishSubject<bool> subject = PublishSubject();
  FilterCriteria filterCriteria;

  _saveFilterCriteria(FilterCriteria filterCriteria) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("filterCriteria");
    prefs.setString("filterCriteria", jsonEncode(filterCriteria.toMap()));
    this.subject.add(true);
    
    bool isSaved = prefs.containsKey("filterCriteria");
    print(isSaved);
  }

  @override
  Widget build(BuildContext context) {
    filterCriteria = widget.applicationEnvironment.filterCriteria;

    final _recordingSection = SafeArea(
      child: ScopedModelDescendant<RepositoryModel>(
        builder: (_, __, model) {
          return PageView(children: <Widget>[_buildCardSection(context)]);
        },
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white70,
      //appBar: _appBar,
      body: _recordingSection,
    );
  }

  _closeButton(BuildContext context) {
    return Positioned(
      top: 0.0,
      left: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ScopedModelDescendant<RepositoryModel>(
          builder: (_, __, model) {
            return IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
                size: 30,
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
  }

  _buildCardSection(BuildContext context) => Card(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          _buildInputCardView(context)
        ],
      ));

  _buildInputCardView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: ScopedModelDescendant<RepositoryModel>(
        builder: (_, __, model) {
          return Stack(
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              _buildInputFields(),
              _closeButton(context),
            ],
          );
        },
      ),
    );
  }

  _buildMultiSelectOptions() {
    List<Widget> choices = List();
    widget.keywords.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: filterCriteria.keywords.contains(item),
          onSelected: (selected) {
            setState(() {
              filterCriteria.keywords.contains(item)
                  ? filterCriteria.keywords.remove(item)
                  : filterCriteria.keywords.add(item);
            });
          },
        ),
      ));
    });

    return Wrap(
      children: choices,
    );
  }

  _buildInputFields() {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 60.0,
                backgroundColor: Colors.black12,
                backgroundImage: AssetImage("assets/tenor.gif"),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.center,
              widthFactor: 2.0,
              child: Row(
                //padding: const EdgeInsets.fromLTRB(0.0, 0.0, 64.0, 8.0),
                children: <Widget>[
                  Icon(
                    Icons.location_searching,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Search Radius"),
                  SizedBox(
                    width: 20,
                  ),
                  DropdownButton<int>(
                    hint: Text((filterCriteria.radiusCovered / 1609.34).toString()),
                    items: <int>[
                      5,
                      10,
                      15,
                      20,
                      25,
                    ].map((int value) {
                      return new DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        filterCriteria.radiusCovered = newValue * 1609.34;
                      });
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "miles",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Filter by types",
                textAlign: TextAlign.left,
                style: TextStyle(
                  decorationThickness: 5.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            _buildMultiSelectOptions(),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.lock_open,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Open Only",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    decorationThickness: 5.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Switch(
                  value: filterCriteria.openNow,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.openNow = value;
                    });
                  },
                  activeTrackColor: Colors.deepOrangeAccent,
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.credit_card,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Upto ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    decorationThickness: 5.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ReviewStars(
                    filterCriteria.maxPriceLevel,
                    (rating) =>
                        setState(() => filterCriteria.maxPriceLevel = rating),
                    Icons.attach_money)
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            SizedBox(
              height: 40,
            ),
            RaisedButton(
              child: Text("Save"),
              onPressed: () => {
                _saveFilterCriteria(filterCriteria),
                 widget.applicationEnvironment.filterCriteria = filterCriteria,
                 widget.applicationEnvironment.refreshRestaurantsList(),
                Navigator.pop(context),
                Navigator.pop(context)
                },
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
