import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:venue_connect/components/Panorama.dart';
import 'package:venue_connect/components/ServicesScreen.dart';
import 'package:slideupscreen/slide_up_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SlideUpScreenWidget extends SlideUpScreen {
  final List<String> images;
  final String name;
  final String address;
  final String rating;

  SlideUpScreenWidget({
    Key? key,
    required this.images,
    required this.name,
    required this.address,
    required this.rating,
  }) : super(key: key);

  @override
  SlideUpScreenWidgetState createState() => SlideUpScreenWidgetState();
}

class SlideUpScreenWidgetState extends SlideUpScreenState<SlideUpScreenWidget> {
  int currentIndex = 0;

  @override
  Color get backgroundColor => Colors.white;

  @override
  Radius get topRadius => Radius.circular(24);

  @override
  double get topOffset => 100;

  @override
  double get offsetToCollapse => 120;

  @override
  Widget? bottomBlock(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.bottom + 16,
      color: Colors.white,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        // Image of the Hall
        Container(
          height: 200, // Adjust the height as needed
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ArViewImage(imageURL: widget.images[index])));
                  },
                  child: Image.network(
                    widget.images[index],
                    fit: BoxFit.fill,
                  ));
            },
            autoplay: true,
            itemCount: widget.images.length,
            // pagination: SwiperPagination(),
            // control: SwiperControl(),
          ),
        ),

        // Details of the Hall
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, right: 20,),
              child: Text(widget.name,
              textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2661FA),),),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(widget.rating),
            ),
          ],
        ),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            widget.address,
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ServicesScreen(
                          name: widget.name,
                          address: widget.address,
                        )));
          },
          style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 40.0,
                  width: 280,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: new LinearGradient(colors: [
                        Color.fromARGB(255, 255, 136, 34),
                        Color.fromARGB(255, 255, 177, 41)
                      ])),
                  padding: const EdgeInsets.all(0),
          child: Text("VIEW SERVICES",textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),)
        ),
      ],
    );
  }
}
