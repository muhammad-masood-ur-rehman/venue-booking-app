import 'dart:async';
import 'package:venue_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 4);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  initScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Gif(
            image: AssetImage("assets/splashscreens.gif"),
            fit: BoxFit.cover,
            autostart: Autostart.loop,
          ),
        ),
      ),
    );
  }
}
