import 'package:flutter/material.dart';
import 'package:venue_connect/components/HomeScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_connect/components/Login.dart';
import 'package:venue_connect/components/SplashScreen.dart';
import 'package:venue_connect/utils/ListSlider.dart';
import 'package:venue_connect/utils/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _scrollController1 = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  ScrollController _scrollController3 = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double minScrollExtent1 = _scrollController1.position.minScrollExtent;
      double maxScrollExtent1 = _scrollController1.position.maxScrollExtent;
      double minScrollExtent2 = _scrollController2.position.minScrollExtent;
      double maxScrollExtent2 = _scrollController2.position.maxScrollExtent;
      double minScrollExtent3 = _scrollController3.position.minScrollExtent;
      double maxScrollExtent3 = _scrollController3.position.maxScrollExtent;
      //
      animateToMaxMin(maxScrollExtent1, minScrollExtent1, maxScrollExtent1, 25,
          _scrollController1);
      animateToMaxMin(maxScrollExtent2, minScrollExtent2, maxScrollExtent2, 15,
          _scrollController2);
      animateToMaxMin(maxScrollExtent3, minScrollExtent3, maxScrollExtent3, 20,
          _scrollController3);
    });
  }

  animateToMaxMin(double max, double min, double direction, int seconds,
      ScrollController scrollController) {
    scrollController
        .animateTo(direction,
            duration: Duration(seconds: seconds), curve: Curves.linear)
        .then((value) {
      direction = direction == max ? min : max;
      animateToMaxMin(max, min, direction, seconds, scrollController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/startbg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  ListSlider(
                    scrollController: _scrollController1,
                    images: list1,
                  ),
                  ListSlider(
                    scrollController: _scrollController2,
                    images: list2,
                  ),
                  ListSlider(
                    scrollController: _scrollController3,
                    images: list3,
                  ),
                ],
              ),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'YOUR ONLY VENUE BOOKING COMPANION',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.josefinSans().fontFamily),
                ),
              ),
              Material(
                elevation: 0,
                color: Color.fromARGB(255, 148, 212, 238),
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  minWidth: 220,
                  height: 60,
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.josefinSans().fontFamily,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
