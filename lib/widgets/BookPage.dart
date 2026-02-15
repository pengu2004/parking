import 'package:flutter/material.dart';
import 'package:parking/config/parking_repository.dart';
import 'package:parking/widgets/FloorSelector.dart';
import 'package:parking/widgets/parkingfloor.dart';
import 'bookingConfirm.dart';
import '../config/parking_state.dart';

class MyBookPage extends StatefulWidget {
  const MyBookPage({
    super.key,
    required this.tower,
    required this.selectedVehicle,
    required this.userName,
    required this.floors,
  });
  final String selectedVehicle;
  final String userName;
  final String tower;
  final List<String> floors;

  @override
  State<MyBookPage> createState() => _MyBookPageState();
}

class _MyBookPageState extends State<MyBookPage> {
  late Map<int, bool> firstbikeSlotsTower1;
  late Map<int, bool> firstbikeSlotsTower2;
  Map<int, bool> firstcarSlot = {};
  Map<int, bool> secondcarSlot = {};

  bool isLoading = true;
  int _selectedFloorIndex = 0;

  final ParkingRepository _parkingRepository = ParkingRepository();
  Future<void> fetchParkingState() async {
    ParkingState parkingState = await _parkingRepository
        .getOccupiedSpotsToday();
    _splitCarByFloor(parkingState);
    setState(() {
      firstbikeSlotsTower1 = parkingState.bikeSlotsTower1;
      firstbikeSlotsTower2 = parkingState.bikeSlotsTower2;

      isLoading = false;
    });
  }

  void _splitCarByFloor(ParkingState parkingState) {
    Map<int, bool> tempfirstcarSlot = {};
    Map<int, bool> tempsecondcarSlot = {};
    for (var slot in parkingState.carSlots.entries) {
      print(slot);
      if (slot.key <= 700) {
        tempfirstcarSlot[slot.key] = slot.value;
      } else {
        tempsecondcarSlot[slot.key] = slot.value;
      }
    }
    setState(() {
      firstcarSlot = tempfirstcarSlot;
      secondcarSlot = tempsecondcarSlot;
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
    if (isLoading ||
        firstbikeSlotsTower1 == null ||
        firstbikeSlotsTower2 == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.selectedVehicle)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FloorSelector(
                floors: widget.floors,
                selectedIndex: _selectedFloorIndex,
                onFloorSelected: (index) {
                  setState(() {
                    _selectedFloorIndex = index;
                  });
                },

                // Handle floor selection if needed
              ),
              ParkingFloor(
                tower: widget.tower,
                floorName: widget.floors[_selectedFloorIndex],
                vehicleType: widget.selectedVehicle,
                userName: widget.userName,
                parkingState: widget.selectedVehicle == "Bike"
                    ? (widget.tower == "Tower-1"
                          ? firstbikeSlotsTower1
                          : firstbikeSlotsTower2)
                    : (_selectedFloorIndex == 0
                          ? firstcarSlot
                          : secondcarSlot), // Pass the correct car slots based on floor and tower
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
    ),
    );
  }
}
