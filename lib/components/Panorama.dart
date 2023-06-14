import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';

class ArViewImage extends StatefulWidget {
  final String imageURL;
  const ArViewImage({super.key, required this.imageURL});

  @override
  State<ArViewImage> createState() => _ArViewImageState();
}

class _ArViewImageState extends State<ArViewImage> {
  @override
  Widget build(BuildContext context) {
    return Panorama(
      animSpeed: 1,
      sensorControl: SensorControl.Orientation,
      child: Image.network(
          "${widget.imageURL}?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"),
    );
  }
}
