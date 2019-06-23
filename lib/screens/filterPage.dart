import 'package:easyfood/domain/unitOfWork.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class FilterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final _recordingSection = SafeArea(
      child: ScopedModelDescendant<UnitOfWork>(
        builder: (_, __, model) {

          return PageView(
            children:  
                 <Widget>[_buildCardSection(context)]
                
          );
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
    }

  _buildCardSection(BuildContext context) => Card(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            
            SizedBox(
              height: 40.0,
            ),
            _buildInputCardView(context)
            
          ],
        ));

  _buildInputCardView(BuildContext context) 
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: ScopedModelDescendant<UnitOfWork>(
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
  _buildInputFields(){
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[Center(
            child: CircleAvatar(
              radius: 60.0,
              backgroundColor: Colors.black12,
              backgroundImage: AssetImage("assets/def-res.png"),
            ),
          ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 64.0, 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.flight_takeoff, color: Colors.red),
                  labelText: "From",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 64.0, 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.flight_land, color: Colors.red),
                  labelText: "To",
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.flight_land, color: Colors.red),
                        labelText: "To",
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 64.0,
                  alignment: Alignment.center,
                  child: Icon(Icons.add_circle_outline, color: Colors.grey),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 64.0, 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.person, color: Colors.red),
                  labelText: "Passengers",
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.date_range, color: Colors.red),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: "Departure"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: "Arrival"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}