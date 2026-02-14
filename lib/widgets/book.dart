import 'package:flutter/material.dart';
import 'package:parking/widgets/parkingfloor.dart';

class MyBookPage extends StatefulWidget {
  const MyBookPage({super.key, required this.selectedVehicle});
  final String selectedVehicle;

  @override
  State<MyBookPage> createState() => _MyBookPageState();
}

class _MyBookPageState extends State<MyBookPage> {
  final int bikeSpaces = 9;
  final List<int> bikeParkingSpaces = [
    320,
    355,
    358,
    362,
    363,
    364,
    365,
    366,
    377,
  ];
  final Map<int, bool> firstBikeParkingState = {
    300: true,
    301: false,
    302: true,
    304: true,
    305: false,
    306: false,
    307: false,
    308: true,
    311: true,
  };
  final Map<int, bool> secondBikeParkingState = {
    300: true,
    301: false,
    302: true,
    304: true,
    305: false,
    306: false,
    3007: false,
    308: true,
  };
  final Map<int, bool> firstCarParkingState = {
    300: true,
    301: false,
    302: true,
    304: true,
    305: false,
    306: false,
    307: false,
    308: true,
    311: true,
  };
  final Map<int, bool> secondCarParkingState = {
    300: true,
    301: false,
    302: true,
    304: true,
    305: false,
    306: false,
    307: false,
    308: true,
    311: true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.selectedVehicle)),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ParkingFloor(
                  floorName: "First Floor",
                  vehicleType: "Bike",
                  userName: "User",
                  parkingState: firstBikeParkingState,
                ),
                SizedBox(height: 20),
                ParkingFloor(
                  floorName: "Second Floor",
                  vehicleType: "Bike",
                  userName: "User",
                  parkingState: secondBikeParkingState,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
