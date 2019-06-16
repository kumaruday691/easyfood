import 'package:easyfood/domain/applicationEnvironment.dart';
import 'package:easyfood/domain/unitOfWork.dart';
import 'package:easyfood/screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

final ApplicationEnvironment applicationEnvironment = new ApplicationEnvironment();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UnitOfWork>(
      model: applicationEnvironment.unitOfWork,
      child:MaterialApp(
        theme: applicationEnvironment.themeData,
        routes: {
         "/" :  (context) => HomePage(applicationEnvironment),
        },
      ),
      

    );
  }

}