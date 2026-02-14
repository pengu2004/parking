import 'package:flutter/material.dart';
import 'package:parking/config/parking_repository.dart';
import 'bookingConfirm.dart';

class ParkingFloor extends StatefulWidget {
  final String floorName;
  final String vehicleType;
  final Map<int, bool> parkingState;
  final String userName;

  const ParkingFloor({
    super.key,
    required this.floorName,
    required this.vehicleType,
    required this.parkingState,
    required this.userName,
  });

  @override
  State<ParkingFloor> createState() => _ParkingFloorState();
}

class _ParkingFloorState extends State<ParkingFloor> {
  late Map<int, bool> spots;
  final ParkingRepository _parkingRepository = ParkingRepository();
  @override
  void initState() {
    super.initState();
    spots = Map.from(widget.parkingState);
  }

  void bookSpot(int spot) async {
    try {
      await _parkingRepository.saveUser(
        name: widget.userName,
        vehicleType: widget.vehicleType,
        slotNumber: spot,
      );
      await _parkingRepository.getOccupiedSpotsToday();
      setState(() {
        spots[spot] = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully booked spot $spot')),
        );
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmationPage(
            userName: widget.userName,
            vehicleType: widget.vehicleType,
            slotNumber: spot,
          ),
        ),
        (route) => false,

      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book spot $spot: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.floorName, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          physics: const NeverScrollableScrollPhysics(),
          children: spots.keys.map((spot) {
            final isAvailable = spots[spot]!;

            return InkWell(
              onTap: isAvailable
                  ? () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Parking Info"),
                          content: Text(
                            "${widget.vehicleType} $spot is available",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                bookSpot(spot);
                                Navigator.of(context).pop();
                              },
                              child: const Text("Book"),
                            ),
                          ],
                        ),
                      );
                    }
                  : null,

              child: Ink(
                color: isAvailable ? Colors.green[100] : Colors.grey,
                child: Center(
                  child: Text(
                    '$spot',
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
