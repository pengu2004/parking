import 'package:flutter/material.dart';
import 'package:parking/config/parking_repository.dart';
import 'package:parking/widgets/FloorSelector.dart';
import 'package:parking/widgets/parkingfloor.dart';
import 'bookingConfirm.dart';
import '../config/parking_state.dart';

class MyBookPage extends StatefulWidget {
  const MyBookPage({
    super.key,
    required this.selectedVehicle,
    required this.userName,
  });
  final String selectedVehicle;
  final String userName;

  @override
  State<MyBookPage> createState() => _MyBookPageState();
}

class _MyBookPageState extends State<MyBookPage> {
  final int bikeSpaces = 9;
  late Map<int, bool> firstbikeSlots;
  late Map<int, bool> firstcarSlots;
  bool isLoading = true;

  final ParkingRepository _parkingRepository = ParkingRepository();
  Future<void> fetchParkingState() async {
    ParkingState parkingState = await _parkingRepository
        .getOccupiedSpotsToday();

    setState(() {
      firstbikeSlots = parkingState.bikeSlots;
      firstcarSlots = parkingState.carSlots;
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchParkingState();
  }

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
    if (isLoading || firstbikeSlots == null || firstcarSlots == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.selectedVehicle)),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FloorSelector(
                  // Handle floor selection if needed
                ),
                ParkingFloor(
                  floorName: "First Floor",
                  vehicleType: widget.selectedVehicle,
                  userName: widget.userName,
                  parkingState: widget.selectedVehicle == "Bike"
                      ? firstbikeSlots
                      : firstcarSlots,
                ),
                SizedBox(height: 20),
                ParkingFloor(
                  floorName: "Second Floor",
                  vehicleType: widget.selectedVehicle,
                  userName: widget.userName,
                  parkingState: widget.selectedVehicle == "Bike"
                      ? secondBikeParkingState
                      : secondCarParkingState,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
