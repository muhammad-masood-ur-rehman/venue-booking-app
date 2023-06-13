import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:venue_connect/components/SlideUpScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_card/image_card.dart';
import 'package:slideupscreen/blurred_popup.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class MyScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> responseData = [];
  List<Widget> imageContainers = [];
  List<String> popularImages = [];

  @override
  void initState() {
    super.initState();
    getVenueData();
  }

  getVenueData() async {
    const url = "https://venueconnect.azurewebsites.net/api/getvenues";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      debugPrint('Successful Retrieve of Venues');
      List<dynamic> jsonResponse = json.decode(response.body) as List<dynamic>;
      for (dynamic data in jsonResponse) {
        Map<String, dynamic> dataMap = Map<String, dynamic>.from(data);
        responseData.add(dataMap);
      }
      responseData.forEach((data) {
        if (data['images'] != null && (data['images'] as List).isNotEmpty) {
          String firstImageUrl = (data['images'] as List)[0] as String;
          popularImages.add(firstImageUrl);
        }
      });
      setState(() {
        for (Map<String, dynamic> data in responseData) {
          List<String> images = (data['images'][0] as String).split(',');

          String randomImage = images.isNotEmpty ? images[0] : '';
          int numberOfStars = Random().nextInt(3) + 3;
          String starString = List.generate(numberOfStars, (_) => "⭐").join();

          imageContainers.add(
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  BlurredPopup.withSlideUp(
                    screen: SlideUpScreenWidget(
                      // Passing the list of image URLs to SlideUpScreenWidget
                      images: images,
                      name: data['name'],
                      address: data['address'],
                      rating: starString,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 15),
                alignment: Alignment.center,
                child: TransparentImageCard(
                  width: 300,
                  imageProvider: NetworkImage(randomImage),
                  tags: [Text(starString)],
                  title:
                      Text(data['name'], style: TextStyle(color: Colors.white)),
                  description: Text(data['address'],
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          );
        }
      });
    } else {
      debugPrint("Can't Retrieve the Venues Right NoW");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: RoundedAppBar(
          appBarHeight: 80,
          leading: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(right: 50),
                child: Text(
                  "WELCOME,",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.dancingScript().fontFamily,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 30, top: 5),
                child: Text("{name_of_user}"),
              )
            ],
          ),
          actions: [
            SizedBox(
              width: 20,
              height: 20,
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/homebg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              //Popular Listings
              Container(
                height: 30,
                margin: const EdgeInsets.only(top: 15, right: 180),
                decoration: const BoxDecoration(
                    color: Color(0XFF2262FA),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0))),
                child: const Center(
                    child: Text(
                  "Popular Bookings",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                )),
              ),
              // Swipper of Popular Listings
              Container(
                  margin: EdgeInsets.only(top: 15),
                  height: 200,
                  width: 300,
                  child: Swiper(
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          popularImages[index],
                          fit: BoxFit.fill,
                        ),
                      );
                    },
                    autoplay: true,
                    itemCount: popularImages.length,
                    scrollDirection: Axis.horizontal,
                    itemWidth: 300.0,
                    layout: SwiperLayout.STACK,
                    // pagination:
                    //     const SwiperPagination(alignment: Alignment.bottomCenter),
                    // control: const SwiperControl(),
                  )),
              SizedBox(
                height: 15,
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    color: Color(0XFF2660FC),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Find Your Venue",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.sort,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              Column(
                children: imageContainers,
              ),
              const SizedBox(height: 10)
            ],
          ),
        ));
  }
}

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appBarHeight;
  final Widget leading;
  final List<Widget> actions;

  const RoundedAppBar({
    Key? key,
    required this.appBarHeight,
    required this.leading,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(
            255, 92, 132, 245), // Customize the background color here
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
      ),
      child: AppBar(
        toolbarHeight: appBarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 150,
        leading: leading,
        actions: actions,
        backgroundColor: Colors.transparent, // Make the AppBar transparent
        elevation: 0, // Remove the AppBar shadow
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
