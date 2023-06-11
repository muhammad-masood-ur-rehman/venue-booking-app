import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:venue_connect/components/Panorama.dart';
import 'package:venue_connect/components/ServicesScreen.dart';
import 'package:slideupscreen/slide_up_screen.dart';

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
              margin: const EdgeInsets.only(top: 10),
              child: Text(widget.name),
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
          child: Text("View Services"),
        ),
      ],
    );
  }
}
