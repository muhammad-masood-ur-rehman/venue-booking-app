import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Options.dart';

class ServicesScreen extends StatefulWidget {
  final String name;
  final String address;
  const ServicesScreen({Key? key, required this.name, required this.address})
      : super(key: key);

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<Widget> packageContainers = [];

  List<Option> options = [];

  List<DateTime> bookedDates = [];

  void parseAndStoreDates(String responseBody) {
    final Map<String, dynamic> response = json.decode(responseBody);
    final List<String> dateStrings = List<String>.from(response['bookedDates']);

    bookedDates =
        dateStrings.map((dateString) => DateTime.parse(dateString)).toList();
  }

  void openCalendar() async {
    final DateTime today = DateTime.now();
    final DateTime minDate =
        today.subtract(Duration(days: 1)); // Disable past dates

    final List<DateTime> parsedDates = bookedDates;

    final DateTime? maxDate = parsedDates.isNotEmpty
        ? parsedDates.reduce((a, b) => a.isAfter(b) ? a : b)
        : null;

    final DateTime initialDate =
        maxDate != null ? maxDate.add(Duration(days: 1)) : minDate;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.add(Duration(days: 1)),
      firstDate: initialDate,
      lastDate: today.add(
          Duration(days: 365)), // Limit the date range to one year from today
    );

    if (pickedDate != null) {
      print('Selected date: $pickedDate');
    }
  }

  // void openCalendar() async {
  //   final DateTime today = DateTime.now();
  //   final DateTime minDate =
  //       today.subtract(Duration(days: 1)); // Disable past dates
  //   final DateTime maxDate =
  //       today.add(Duration(days: 365)); // Limit the date range

  //   final List<DateTime>? disabledDates =
  //       bookedDates.isNotEmpty ? bookedDates : null;

  //   final DateTime initialDate =
  //       disabledDates!.isNotEmpty ? disabledDates.first : today;

  //   final DateTime? pickedDate = await showDatePicker(
  //       context: context,
  //       initialDate: initialDate, // Explicitly set initialDate to today
  //       firstDate: minDate,
  //       lastDate: maxDate,
  //       selectableDayPredicate: (DateTime date) {
  //         if (bookedDates.isNotEmpty) {
  //           return !date.isBefore(today) && !disabledDates!.contains(date);
  //         } else {
  //           return true;
  //         }
  //       });

  //   if (pickedDate != null) {
  //     print('Selected date: $pickedDate');
  //   }
  // }

  Future<void> fetchBookedDates(String address) async {
    debugPrint(address);
    final url = Uri.parse(
        'https://venueconnect.azurewebsites.net/api/booking/123 Main St/bookedDates');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Successful API call
      final responseData = response.body;
      // Handle the response data here
      print(responseData);

      parseAndStoreDates(responseData);

      // After storing the dates, open the calendar
      openCalendar();
    } else {
      // Error in API call
      print('Request failed with status: ${response.statusCode}.');
      openCalendar();
    }
  }

  void openURLWithParams(name, price) async {
    final String productName = name; // Set your desired product name
    final String productPrice = price; // Set your desired product price

    final url = Uri.encodeFull(
      'https://venueconnect-payment-frontend.azurewebsites.net/?Productname=$productName&Productprice=$productPrice',
    );

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  getVenueOptions() async {
    final url =
        "https://venueconnect.azurewebsites.net/api/venue/${widget.name}/options";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      debugPrint('Successful Retrieve of Venues');
      // Parse the response and populate the options list
      Map<String, dynamic> jsonResponse =
          json.decode(response.body) as Map<String, dynamic>;
      List<dynamic> optionsData = jsonResponse['options'] as List<dynamic>;
      if (optionsData.isNotEmpty) {
        for (dynamic data in optionsData[0]) {
          Map<String, dynamic> amenities = data['amenities'];
          Option option = Option(
            category: data['category'],
            price: data['price'],
            amenities: amenities,
          );
          options.add(option);
        }
      } else {
        debugPrint('No options available');
      }

      // Update the packageContainers list and trigger a rebuild
      setState(() {
        packageContainers = options.map((option) {
          return Container(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                debugPrint("Package is Tapped!!");
                fetchBookedDates(widget.address);
                // Payment Gateway 💸
                // openURLWithParams(widget.name, option.price);
              },
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 40, left: 30),
                    width: 300,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(option.category),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AmenityIcon(
                              icon: Icons.star,
                              label: 'Entertainment',
                              value: option.amenities['entertainment'],
                            ),
                            AmenityIcon(
                              icon: Icons.kitchen,
                              label: 'Pantry',
                              value: option.amenities['pentry'],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AmenityIcon(
                              icon: Icons.restaurant,
                              label: 'Catering',
                              value: option.amenities['catering'],
                            ),
                            AmenityIcon(
                              icon: Icons.security,
                              label: 'Security',
                              value: option.amenities['security'],
                            ),
                            AmenityIcon(
                              icon: Icons.local_parking,
                              label: 'Parking',
                              value: option.amenities['parking'],
                            ),
                          ],
                        ),
                        Container(
                          width: 250,
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              gradient: new LinearGradient(colors: [
                                Color.fromARGB(255, 255, 136, 34),
                                Color.fromARGB(255, 255, 177, 41)
                              ])),
                          alignment: Alignment.center,
                          child: Text(
                            textAlign: TextAlign.center,
                            'Rs. ${option.price}',
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/${option.category}.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();
      });

      // Print the values of the options list
      options.forEach((option) {
        debugPrint('Category: ${option.category}');
        debugPrint('Price: ${option.price}');
        debugPrint('Amenities: ${option.amenities}');
      });
    } else {
      debugPrint('Failed to retrieve the Options');
    }
  }

  @override
  void initState() {
    super.initState();
    getVenueOptions();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/servicesbg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 75,
                padding: EdgeInsets.only(
                  left: 10,
                  top: 10,
                ),
                decoration: BoxDecoration(
                  color: Color(0xffBCC6CC),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                ),
                child: Text(
                  "Package Details",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2661FA),
                      fontSize: 36),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: packageContainers,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AmenityIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;

  const AmenityIcon({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Icon(
            icon,
            color: value ? Colors.green : Colors.grey,
            size: 15,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
