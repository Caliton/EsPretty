import 'dart:async';
import 'package:espresso_app/pages/home.dart';
// import 'package:espretty/pages/initial-page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () => _dashboard());
  }

  _dashboard() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.blue
            ),
          ),

          Center (
            child: Image.asset("assets/picture.png", width: 100, height: 100)
          )
        ],
      )
    );
  }
}