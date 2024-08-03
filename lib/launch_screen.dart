import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_forecast/main.dart';

void main(){
  runApp(const MaterialApp(
    home: LaunchScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainFunction(),));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Image.asset("Assets/WeatherLogo.gif"),
              width: 250,
            ),
          ),
          SizedBox(height: 50,),
          Center(
            child: Text("My Weather",style: TextStyle(fontSize: 30,fontFamily: 'Georgia'),),
          )
        ],
      ),
    );
  }
}
