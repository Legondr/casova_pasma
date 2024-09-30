import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  int _selectedIndex = 0; // To track the selected city index
  DateTime time = DateTime.now(); // Current time
  Timer? _timer;

  // Map of cities and their timezone offsets (in hours from UTC)
  final Map<String, int> cityTimezones = {
    'Prague': 2, // UTC+2
    'London': 1, // UTC+1
    'New York': -4, // UTC-4
    'Tokyo': 9, // UTC+9
  };

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        time = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Calculate the time for the selected city based on its UTC offset
  String getCityTime(String city) {
    int timezoneOffset = cityTimezones[city]!;
    DateTime cityTime = time.toUtc().add(Duration(hours: timezoneOffset));
    return DateFormat('hh:mm:ss a')
        .format(cityTime); // Format the time for display
  }

  // Function to handle BottomNavigationBar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index when tapped
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> cities =
        cityTimezones.keys.toList(); // Extract city names from the map
    String cityName =
        cities[_selectedIndex]; // Get the name of the selected city
    String cityTime =
        getCityTime(cityName); // Get the time of the selected city

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("World Clock"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                cityName, // Display the selected city
                style: const TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 10),
              Text(
                cityTime, // Display the selected city's time
                style: const TextStyle(fontSize: 24, color: Colors.grey),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: cities.map((city) {
            return BottomNavigationBarItem(
              icon: const Icon(Icons.location_city),
              label: city, // Label for each city
            );
          }).toList(),
          currentIndex: _selectedIndex, // The currently selected city index
          selectedItemColor:
              Colors.blue, // Color of the selected item (icon and label)
          unselectedItemColor:
              Colors.grey, // Color of unselected items (icon and label)
          onTap: _onItemTapped, // Handle tap on BottomNavigationBar items
          showUnselectedLabels:
              true, // Ensure that unselected labels are also shown
        ),
      ),
    );
  }
}
