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
    required this.floors,
  });
  final String selectedVehicle;
  final String userName;
  final List<String> floors;

  @override
  State<MyBookPage> createState() => _MyBookPageState();
}

class _MyBookPageState extends State<MyBookPage> {
  late Map<int, bool> firstbikeSlots;
  late Map<int, bool> firstcarSlots;
  bool isLoading = true;
  int _selectedFloorIndex = 0;

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
                  floors: ["1st Floor", "2nd Floor", "3rd Floor"],
                  selectedIndex: _selectedFloorIndex,
                  onFloorSelected: (index) {
                    setState(() {
                      _selectedFloorIndex = index;
                    });
                  },

                  // Handle floor selection if needed
                ),
                ParkingFloor(
                  floorName: widget.floors[_selectedFloorIndex],
                  vehicleType: widget.selectedVehicle,
                  userName: widget.userName,
                  parkingState: widget.selectedVehicle == "Bike"
                      ? firstbikeSlots
                      : firstcarSlots,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
